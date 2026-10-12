function [data, info] = readMatrix(filePath, layout, maxRows, maxHeaderLines)
%READMATRIX  Read a tabular file as a samples-by-columns double matrix.
%   [DATA, INFO] = READMATRIX(FILEPATH, LAYOUT) reads the whole file.
%   MAXROWS limits how many data rows are read. MAXHEADERLINES does NOT say
%   where the data starts - LAYOUT.headerLines does that - it only says how
%   many leading rows to copy into the slice the rows are read from, so that a
%   short read still has its header above it. Both are empty by default.
%   MAXROWS is what makes the layout sniffer cheap: it only ever needs a few
%   rows, and this way it never has to read a whole export to get them.
%
%   The data starts at LAYOUT.headerLines + 1 whenever the layout states a
%   header row count, so a forced one is honoured even when every row above it
%   holds a number; otherwise the leading rows that hold no number are taken as
%   the header. Empty columns at either end are dropped, so DATA is tight
%   around the numbers that are actually there.
%
%   DATA is SAMPLES x COLUMNS and double, and still contains the time column.
%   It is READTABULARFILE that drops that column from the channels.
%
%   Every text read names its file type rather than letting readmatrix work it
%   out from the extension: readmatrix knows .txt, .csv, .dat and the
%   spreadsheet formats, and refuses anything else, so a tab separated .tsv
%   used to end in "not a recognized file extension" instead of in its data.
%
%   Returned fields
%     numColumns, headerNames, numHeaderLines, headerLineIndices
%     rowCount, numericFraction
%     droppedLeadingRows, droppedTrailingRows, trimmedColumns, allNaN
%     transposed
%
%   When the layout says orientation is 'horizontal', the grid is TRANSPOSED
%   once, here, so that everything downstream - the trimming, the counts, the
%   blanks policy, the sampling rate - sees samples down the rows and channels
%   across the columns exactly as it always has. The name column is read from the
%   file before that, because after it the names are numbers or nothing at all.
%
%   Read orientation by name rather than as an argument, so the one field is the
%   single answer to the question and no caller can disagree with it.
%
%   When the layout says the file needs a decimal repair, the file is
%   rewritten to a temporary copy first and that copy is deleted on the way
%   out. See REPAIRDECIMALCOMMA.
%
%   See also DETECTLAYOUT, READTABULARFILE, REPAIRDECIMALCOMMA.

arguments
    filePath (1,1) string
    layout (1,1) struct
    % no size constraint: the default is the empty 0x0 double, which
    % cannot satisfy (1,1) on the releases that validate defaults
    % strictly, and the tests read that way
    maxRows double = []
    maxHeaderLines double = []
end

% numColumns and headerNames are part of the contract with DETECTLAYOUT, which
% uses them when the delimiter could not be decided from the text alone
info = struct('headerNames', {{}}, ...
              'rowCount', 0, ...
              'numericFraction', NaN, ...
              'numHeaderLines', 0, ...
              'headerLineIndices', [], ...
              'droppedLeadingRows', 0, ...
              'droppedTrailingRows', 0, ...
              'trimmedColumns', 0, ...
              'allNaN', false, ...
              'transposed', false, ...
              'skippedColumns', 0, ...
              'numColumns', 0);

% Whether the samples run across the columns. Asked once, here, because the
% answer is needed in four places and reading it off the layout each time would
% let a caller change it halfway through.
isHorizontal = isfield(layout, 'orientation') ...
    && strcmp(layout.orientation, 'horizontal');
% How many columns at the left are not data. Zero for a layout that says
% nothing, which is every layout built by hand before this field existed.
nameColumns = 0;
if isfield(layout, 'nameColumns') && ~isempty(layout.nameColumns)
    nameColumns = max(0, round(layout.nameColumns));
end

readablePath = char(filePath);

% How many header rows the FILE has, as the layout counted them, as opposed to
% the count a caller may have forced. Zero when the layout does not say, which
% is the case for one built by hand: then the count it states is all there is.
% Needed twice below - once for the repair, once for the row trimming - so it
% is worked out once here rather than by a helper called from two places.
detectedHeaderLines = 0;
if isfield(layout, 'detectedHeaderLines') && ~isempty(layout.detectedHeaderLines)
    detectedHeaderLines = layout.detectedHeaderLines;
elseif isfield(layout, 'headerLines')
    detectedHeaderLines = layout.headerLines;
end

tempPath = '';
if layout.convention.needsRepair
    % A European file may hold more than one sample per line, so repairing it
    % is a text transform over the whole file rather than a readmatrix call.
    % The header rows are named so that a label row is copied through instead
    % of being handed to the number converter - the rows the FILE has as a
    % header, not the count a caller forced, because those forced rows are
    % numbers that have to arrive converted for READMATRIX to drop them.
    headerForRepair = detectedHeaderLines;
    [tempPath, ~] = tabularImport.repairDecimalComma(filePath, layout.delimiter, ...
        headerForRepair);
    readablePath = tempPath;
end
if ~isempty(tempPath)
    cleanup = onCleanup(@() removeTempFile(tempPath));
end

% Names read from the name column BEFORE anything converts them, when the layout
% says the samples run across the columns. Held here rather than read at the
% point of use because by then the grid has been through STR2DOUBLE and the
% names are NaN.
%
% It has to be the REPAIRABLE path, not the original: a European file is read
% from the repaired copy, and reading the names from the original while reading
% the numbers from the copy is the same split that once made a European file
% with three header rows come back named col1, col2, ...
horizontalNames = {};
if isHorizontal
    horizontalNames = readNameColumn(readablePath, layout, nameColumns);
end

if layout.isSpreadsheet
    args = spreadsheetArgs(readablePath, layout, maxRows, maxHeaderLines);
    raw = readmatrix(readablePath, args{:});
    headerRows = 0;
    try
        % Bounded to FIVE rows for the same reason the main read is bounded:
        % READMATRIX on an unbounded range of a large sheet is the slowest
        % thing in the import, and all this probe wants to know is where the
        % numbers start.
        probeArgs = spreadsheetArgs(readablePath, layout, 5, 0);
        probe = readmatrix(readablePath, probeArgs{:});
    catch
        probe = [];
    end
    for r = 1:size(probe, 1)
        if any(~isnan(probe(r, :)))
            break;
        end
        headerRows = headerRows + 1;
    end
    if headerRows >= 1
        raw = raw(droppedLeadingRows(raw):end, :);
    end
    info.numHeaderLines = headerRows;
    info.headerLineIndices = 1:headerRows;
else
    % The slice has to be tall enough for MAXROWS data rows AND for the header
    % rows above them. With MAXHEADERLINES empty - which is what READTABULARFILE
    % passes for a full reading - the layout's own count is used, or "25 rows"
    % of a file with a header line would only ever yield 24.
    sliceHeader = maxHeaderLines;
    if isempty(sliceHeader)
        sliceHeader = layout.headerLines;
    end
    slicePath = sliceFirstRows(readablePath, maxRows, sliceHeader);
    if ~isempty(slicePath)
        readablePath = slicePath;
        sliceCleanup = onCleanup(@() removeTempFile(slicePath));
    end
    if isempty(layout.delimiter)
        raw = readmatrix(readablePath, 'FileType', 'text');
    else
        raw = readmatrix(readablePath, 'FileType', 'text', ...
            'Delimiter', char(layout.delimiter));
    end
    if size(raw, 2) == 1 && ~isempty(layout.delimiter)
        % readmatrix can collapse a one column file; splitting the text again
        % is the reliable way to recover the columns. readmatrix spells this
        % option 'OutputType' - it rejects 'TextType' outright, so the
        % collapse used to end in an error rather than in the columns
        raw = readmatrix(readablePath, 'FileType', 'text', ...
            'Delimiter', char(layout.delimiter), 'OutputType', 'string');
    end
end

if isempty(raw)
    info.allNaN = true;
    data = [];
    return;
end

% ---------------------------------------------------------------- trim rows
% readmatrix hands back a string array when a column holds text that is not a
% number, and ISNAN on a string throws rather than answering. Converting once,
% here, means a cell that does not hold a number is NaN from then on, which is
% what every step below assumes. Without it, forcing the wrong delimiter ended
% the import in "Invalid data type" from inside readmatrix's own result.
if ~isnumeric(raw)
    raw = str2double(raw);
end

% ------------------------------------------------------------ skip columns
% The columns the layout says are not data: the name column of a horizontal
% file, or a text label column at the left of anything.
%
% Done BEFORE the trims, and stated explicitly rather than left to the trim,
% because the trim works by looking for the first and last column that hold a
% number. That is the same answer when the skipped columns hold no numbers at
% all - which is the normal case - and a DIFFERENT answer when one of them does
% hold a number, such as a two level header whose outer level is a year. The
% count is the count; applying it is not a matter of what the columns happen to
% contain.
if ~isempty(raw) && nameColumns > 0
    keepFrom = min(nameColumns + 1, size(raw, 2));
    if keepFrom > 1
        % The columns actually dropped, which is KEEPFROM - 1 and not the width
        % that survived: raw is 201 columns wide for a sheet of four channels,
        % so size(raw,2) - keepFrom + 1 answers 200 - the number KEPT - and that
        % got reported as "200 columns were skipped" for a file that has one.
        info.skippedColumns = keepFrom - 1;
        raw = raw(:, keepFrom:end);
    end
end
% Rows that hold no number at all are not data. They are either a header or a
% trailing note, and keeping them would poison the median, the mean and every
% regression computed later.
rowHasNumber = any(~isnan(raw), 2);
lastRow = find(rowHasNumber, 1, 'last');
% READMATRIX has already dropped some or all of the leading rows of the FILE
% that hold no number - it does that on its own for a text read, and how many
% it dropped varies with the file - so RAW starts at or after file line
% HEADERLINES + 1 of the file as DETECTLAYOUT counted it. A header row count
% that has been forced above that count therefore has to skip that many rows of
% RAW itself, which is the whole of the difference between the two. Skipping
% HEADERLINES + 1 rows of RAW instead, as this did, dropped one data row too
% many on every single file: its header had already gone.
%
% Taking the LATER of the two starting rows covers both halves. The layout is
% what the caller asked for, so a forced count above the file's own is honoured
% and a header block that READMATRIX left in place - it keeps four such rows
% where it drops one - is still dropped, because those rows hold no number and
% would otherwise come back as a row of NaN at the top of every channel.
forced = max(0, layout.headerLines - detectedHeaderLines);
firstRow = 1 + forced;
if ~isempty(lastRow)
    firstRow = max(firstRow, find(rowHasNumber, 1, 'first'));
end
if isempty(lastRow) || firstRow > lastRow
    % The numbers are there, they are all above the header rows
    info.allNaN = isempty(lastRow);
    data = [];
    return;
end

info.droppedLeadingRows = forced;
info.droppedTrailingRows = size(raw, 1) - lastRow;
info.numHeaderLines = layout.headerLines;
info.headerLineIndices = 1:info.numHeaderLines;
raw = raw(firstRow:lastRow, :);

% ------------------------------------------------------------- trim columns
% A ragged export leaves empty columns at the right, and a metadata block can
% leave one at the left.
columnHasNumber = any(~isnan(raw), 1);
firstColumn = find(columnHasNumber, 1, 'first');
lastColumn = find(columnHasNumber, 1, 'last');
info.trimmedColumns = size(raw, 2) - (lastColumn - firstColumn + 1);
raw = raw(:, firstColumn:lastColumn);

% ------------------------------------------------------------ transpose
% The one place the two orientations meet. Below here everything is samples
% down the rows and channels across the columns, which is what the trims above,
% the counts, BLANKS and the sampling rate all already assume - so this is the
% only line that has to know.
%
% AFTER the trims, not before, and that order is the whole design: the name
% column of a horizontal file is text, so the column trim has already dropped
% it, and the metadata rows are text too, so the row trim has already dropped
% them. What survives is exactly the channels by the samples, and transposing it
% gives the matrix the rest of the package expects.
if isHorizontal && ~isempty(raw)
    raw = raw.';
    info.transposed = true;
end

data = raw;
info.rowCount = size(data, 1);
if ~isempty(data)
    info.numColumns = size(data, 2);
end
info.numericFraction = mean(~isnan(data(:)));
if isempty(data) || all(isnan(data(:)))
    info.allNaN = true;
end
%   Read from the file itself, never from the repaired copy: a repair rewrites
%   the numbers, so the row that is a data row under a larger header count
%   comes back as a number either way, while the real header row is text that
%   the repair never touched. Reading the repaired copy for a European file
%   with a one row header therefore found the right row by accident, and with
%   three header rows it found col1, col2, ... for every column.
if isHorizontal
    % The names are in the name COLUMN of the file, not in a header row, so
    % READHEADERNAMES cannot be used: it would name the channels from the row of
    % sample labels above them. They were read before the transpose, while they
    % were still text.
    info.headerNames = trimNames(horizontalNames, size(data, 2));
else
    info.headerNames = readHeaderNames(layout.filePath, layout, size(data, 2));
end
end


% =============================================================================
% =============================================================================
% =============================================================================
function names = readNameColumn(readablePath, layout, nameColumns)
%READNAMECOLUMN  The name column of a horizontal file, one entry per data row.
%   Read as TEXT on purpose. The names are the one thing in the file that is
%   not a number, so they have to be collected before anything converts them,
%   and they are the reason the transpose cannot simply be applied to RAW.
%
%   Only the NAMED columns are read, and by their LETTERS rather than by
%   reading the whole grid a second time. That matters for two reasons: a
%   horizontal file can be thousands of columns wide and the names are a couple
%   of them, and asking for a few columns keeps the row numbers aligned with the
%   rows of the numeric read instead of depending on how READMATRIX padded.
%
%   THE LAST OF THEM is the name. A file with one skipped column has its names
%   in column A, which is the case this was written for; a file with two - the
%   shape a two level header makes, Group | Name | v1 | v2 | ... - has its
%   specific names in the one nearest the data. Reading column A there would
%   name every channel "control".
%
%   An entry that is not text, or is empty, comes back empty, and TRIMNAMES
%   turns the gaps into col1, col2, ... rather than dropping the channel.
names = {};
rows = 2000;
% Zero name columns means the user has said the first column IS data, so there
% is no column to take the names from and they come back as col1, col2, ...
% Clamping zero up to one here would quietly read the names out of a column
% that was not skipped, which is the opposite of what was asked for - and it
% would disagree with the note in the warning pane, which reports the count the
% user set.
if nameColumns < 1
    return;
end
try
    if layout.isSpreadsheet
        letters = tabularImport.columnLetters(nameColumns);
        sheetGrid = readcell(readablePath, 'Sheet', char(layout.sheet), ...
            'Range', sprintf('%s1:%s%d', letters{1}, letters{end}, rows));
        if isempty(sheetGrid)
            return;
        end
        % Cut off the file's own header rows HERE, so that both branches below
        % work on a grid that already begins at the first data row.
        %
        % Skipping them later went wrong twice. Reading the whole sheet and
        % naming the channels from its first row gave 'sample, time, sig100,
        % ramp' for a sheet whose channels are time, sig100, ramp, const - the
        % header row's own labels, shifted up by one. Applying the offset a
        % second time to a grid the text branch had ALREADY cut took the names
        % from row three onwards and dropped the first channel.
        first = min(detectedHeaderCount(layout) + 1, size(sheetGrid, 1));
        grid = sheetGrid(first:end, :);
    else
        head = tabularImport.fileHead(readablePath, 512 * 1024);
        if isempty(head)
            return;
        end
        % +1, because the count says how many rows are ABOVE the data: a header
        % count of two means lines one and two are metadata and the names start
        % on line three. Reading from line two took the row of sample labels as
        % the first name, and every channel came out one place out - col1, time,
        % sig100, ramp for a four channel file.
        first = min(detectedHeaderCount(layout) + 1, numel(head));
        grid = cell(numel(head) - first + 1, nameColumns);
        for k = first:numel(head)
            fields = strsplit(char(head{k}), char(layout.delimiter));
            for c = 1:nameColumns
                if numel(fields) < c
                    grid{k - first + 1, c} = '';
                else
                    grid{k - first + 1, c} = strtrim(fields{c});
                end
            end
        end
    end
    % The LAST named column, for the reason in the help: it is the one nearest
    % the data, and so the one that names the channel. Both branches above have
    % already cut GRID to begin at the first data row, so there is no offset to
    % apply here - applying one is what took the names from row three.
    lastNameColumn = min(nameColumns, size(grid, 2));
    names = cell(1, size(grid, 1));
    for k = 1:size(grid, 1)
        value = grid{k, lastNameColumn};
        if isstring(value) || ischar(value)
            value = char(value);
            if numel(value) > 0
                names{k} = value;
            end
        end
    end
catch
    names = {};
end
end


% =============================================================================
function n = detectedHeaderCount(layout)
%DETECTEDHEADERCOUNT  The header count as the FILE has it, not as forced.
%   The name column starts below the file's own header rows. A forced count is
%   a row count the file may not have, and naming channels from rows that are
%   still metadata is worse than falling back to col1, col2, ...
n = 0;
if isfield(layout, 'detectedHeaderLines') && ~isempty(layout.detectedHeaderLines)
    n = layout.detectedHeaderLines;
elseif isfield(layout, 'headerLines')
    n = layout.headerLines;
end
end


% =============================================================================
function names = trimNames(found, count)
%TRIMNAMES  Channel names padded or cut to exactly COUNT of them.
%   The same job READHEADERNAMES ends with for a vertical file: whatever was
%   found is made to be exactly as long as there are channels, so nothing
%   downstream has to cope with a name list of the wrong length. A name that
%   was missing comes back as col1, col2, ... which is the wording the rest of
%   the package uses for a channel it could not name.
names = cell(1, count);
for c = 1:count
    names{c} = sprintf('col%d', c);
end
for c = 1:min(count, numel(found))
    if ~isempty(found{c})
        names{c} = found{c};
    end
end
end


% =============================================================================
function names = readHeaderNames(filePath, layout, numColumns)
%READHEADERNAMES  Best effort column names, one per column, always.
%   Falls back to Column_1..Column_N whenever the header row is missing,
%   unreadable or shorter than the data, so the caller never has to special
%   case an empty result. Kept as char, because the result ends up in a
%   uitable's Data, which rejects a string cell.
names = cell(1, numColumns);
for c = 1:numColumns
    names{c} = sprintf('col%d', c);
end
if numColumns < 1
    names = cell(1, 0);
    return;
end

try
    if layout.isSpreadsheet
        % '1:1' is a row select, so it comes back the width of the sheet's
        % used range and no wider. 'A1:ZZ1' asked for 702 columns to read one.
        raw = readcell(filePath, 'Sheet', char(layout.sheet), 'Range', '1:1');
        raw = raw(1, :);
    else
        headerRows = layout.headerLines;
        if headerRows < 1
            return;
        end
        raw = tabularImport.fileHead(filePath, 64 * 1024);
        if isempty(raw) || numel(raw) < headerRows
            return;
        end
        raw = strsplit(strtrim(raw{headerRows}), layout.delimiter);
    end
catch
    return;
end

raw = strtrim(string(raw));
% A row of numbers is data, not names, however many columns it splits into.
% DETECTLAYOUT asks that question before it names anything; here the answer
% went unchecked, so pointing the dialog at the wrong header row of a European
% file put a sample value such as "0,00100000" into the Name column, and the
% user was offered a channel named after one.
if any(cellfun(@(f) cellLooksNumeric(f, layout), cellstr(raw)))
    return;
end
for c = 1:numColumns
    if c <= numel(raw) && strlength(raw(c)) > 0
        names{c} = char(raw(c));
    end
end
end


% =============================================================================
function tf = cellLooksNumeric(token, layout)
%CELLLOOKSNUMERIC  Would this cell read as a number under the layout's settings?
%   DETECTLAYOUT answers the same question with a regex that accepts either
%   convention at once, because there it has not yet decided. Here the layout
%   already says which convention is in force, so the separators it names are
%   the ones to take out before asking.
token = strtrim(string(token));
if strlength(token) == 0
    tf = false;
    return;
end
grouping = '';
decimal = '.';
if isfield(layout, 'convention') && isstruct(layout.convention)
    if isfield(layout.convention, 'thousandsSep')
        grouping = char(layout.convention.thousandsSep);
    end
    if isfield(layout.convention, 'decimalSeparator')
        decimal = char(layout.convention.decimalSeparator);
    end
end
clean = char(token);
% An empty grouping separator would delete every character, so it is asked
% about rather than passed to strrep
if strlength(string(grouping)) > 0
    clean = strrep(clean, grouping, '');
end
if ~strcmp(decimal, '.')
    clean = strrep(clean, decimal, '.');
end
tf = ~isempty(regexp(clean, '^[+-]?(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?$', 'once'));
end


% =============================================================================
% =============================================================================
function stamp = fileSizeStamp(filePath)
%FILESIZESTAMP  How many bytes the file holds, for the SHEETWIDTH cache key.
%   Empty when it cannot be found, which makes the key wrong rather than the
%   answer: a file that cannot be opened is not going to be read either.
stamp = '';
fid = fopen(filePath, 'r');
if fid < 0
    return;
end
cleanup = onCleanup(@() fclose(fid));
% The size is read from the handle with FSEEK/FTELL rather than with DIR, and
% not only because DIR would come from a directory cache: DIR does not accept
% a file id on this release at all - it answers "Name must be a text scalar".
% SEEKING to the end of the open file asks the file system itself, so it cannot
% be a stale listing.
info = fseek(fid, 0, 'eof');
if info == 0
    stamp = sprintf('%d', ftell(fid));
end
end


% =============================================================================
function n = droppedLeadingRows(raw)
%DROPPEDLEADINGROWS  How many all-NaN rows RAW actually begins with.
%   READMATRIX drops leading all-text rows from a sheet when it is given no
%   RANGE, and keeps them when it is given one. Measured on the same sheet: the
%   unbounded read answered with four rows where the bounded read answered with
%   five, the header row simply absent from the first.
%
%   So the PROBE's count cannot be used to trim RAW: on the unbounded read that
%   threw a real data row away, and demo_horizontal.xlsx came back with three
%   channels instead of four - a channel lost with nothing to say so.
%
%   Counting the rows RAW actually has instead works either way. If READMATRIX
%   already dropped the header, RAW's first row holds numbers and this is zero.
n = 0;
if isempty(raw)
    return;
end
for r = 1:size(raw, 1)
    if any(~isnan(raw(r, :)))
        break;
    end
    n = n + 1;
end
% Never returned as an INDEX. Zero leading NaN rows is the ordinary answer,
% and RAW(0:end, :) is not "the whole array" in MATLAB - it is an invalid index
% and it throws, which is what happened the first time this was called on an
% empty sheet.
n = max(1, n);
end


% =============================================================================
function args = spreadsheetArgs(filePath, layout, maxRows, maxHeaderLines)
%SPREADSHEETARGS  The READMATRIX arguments for reading the top of a sheet.
%   A sheet name is always passed; a range only when there is a row limit to
%   impose.
%
%   The range used to end at column ZZ, which is column 702. Asking a
%   four-column sheet for a 702-column rectangle is what made the spreadsheet
%   path take half a minute on a 14 kB file: the same read took 9.7 s as
%   A1:ZZ50 and 0.5 s as A1:E50. So the columns now end where the sheet's used
%   range does.
%
%   No range at all is passed when the limit is unbounded, which is both what
%   the full read wants - READMATRIX then returns the sheet's own extent - and
%   what stops ROUND(Inf) reaching SPRINTF as 'Inf' and building 'A1:ZZInf',
%   which READMATRIX rejects outright with "Unable to determine range".
    args = {'Sheet', char(layout.sheet)};
    if isempty(maxRows) || ~isfinite(maxRows) || ...
            isempty(maxHeaderLines) || ~isfinite(maxHeaderLines)
        return;
    end
    lastRow = round(maxRows + maxHeaderLines);
    width = sheetWidth(filePath, layout.sheet);
    if isempty(width)
        % The probe failed. Falling back to the wide rectangle is slow but
        % correct, which beats refusing to read a sheet whose extent could not
        % be measured.
        args = [args, {'Range', sprintf('A1:ZZ%d', lastRow)}];
        return;
    end
    % The LAST letter closes the rectangle. Taking the first instead built
    % 'A1:A50' for a four column sheet, which readmatrix accepted and
    % returned as a single column - a preview of one channel that looked like
    % a successful read.
    letters = tabularImport.columnLetters(width);
    args = [args, {'Range', sprintf('A1:%s%d', letters{end}, lastRow)}];
end


function width = sheetWidth(filePath, sheet)
%SHEETWIDTH  How many columns the used range of SHEET reaches.
%   Measured with one row of READCELL, which costs about 0.7 s on the
%   reference fixture and never widens the sheet.
%
%   Cached per file and sheet. The extent of a sheet does not change while the
%   import dialog is open, and asking again on every re-read would put a
%   second parse of the workbook into what reads like a pure lookup.
persistent cachedKey cachedWidth
% The FILE'S SIZE is part of the key, not just its path.
%
% Without it the cache is a trap: a workbook that changes while MATLAB is
% open keeps being read at its old width for the rest of the session. Measured
% on demo_multisheet.xlsx - it was four columns, the generator rewrote it with
% ten, and the still-running session went on reporting four. Everything
% downstream agreed with that number, so the import dialog showed four columns,
% there was nothing hidden, and so there was no horizontal scrollbar to look
% for: the columns were not off the right hand edge, they were simply not in
% the file any more as far as MATLAB was concerned.
%
% Size rather than a timestamp because what is cached is a WIDTH, and a change
% in the number of columns changes the file's size. A rewrite that left the
% size alone cannot have changed the width, so nothing is lost by not looking.
% The stamp is taken from an OPEN FILE HANDLE rather than from DIR, which is
% the reason DEMOFFILE prefers FOPEN: a path lookup is served from a directory
% cache that a long session hands back stale, which is this same bug one level
% down.
key = sprintf('%s|%s|%s', char(filePath), char(sheet), fileSizeStamp(filePath));
if isequal(cachedKey, key)
    width = cachedWidth;
    return;
end
    width = [];
    try
        firstRow = readcell(filePath, 'Sheet', char(sheet), 'Range', '1:1');
        if ~isempty(firstRow)
            cells = firstRow(1, :);
            % A row select comes back exactly as wide as the used range, so the
            % width is simply how many cells arrived. A range wider than the
            % sheet would have padded them out with MISSING instead.
            width = numel(cells);
            for c = 1:numel(cells)
                if ismissing(cells{c}) || (ischar(cells{c}) && isempty(strtrim(cells{c})))
                    width = c - 1;
                    break;
                end
            end
        end
    catch
        width = [];
    end
    cachedKey = key;
    cachedWidth = width;
end


function slicePath = sliceFirstRows(filePath, maxRows, maxHeaderLines)
%SLICEFIRSTROWS  Copy the first rows of a text file to a temporary file.
%   Reading a few rows out of a huge export without this would mean reading
%   the whole thing first. An empty result means the original is to be read
%   as it is, which is what happens when the file is shorter than the slice.
slicePath = '';
if isempty(maxRows)
    return;
end

fid = fopen(filePath, 'r');
if fid < 0
    return;
end
cleanup = onCleanup(@() fclose(fid));

keep = round(maxRows) + round(maxHeaderLines);
slicePath = tempname();

out = fopen(slicePath, 'w');
if out < 0
    slicePath = '';
    return;
end
outCleanup = onCleanup(@() fclose(out));

written = 0;
while written < keep
    line = fgetl(fid);
    if ~ischar(line)
        break;
    end
    fprintf(out, '%s\n', line);
    written = written + 1;
end
if written < keep
    % The whole file fitted inside the slice, so the slice is a copy of it and
    % reading the original spares a second read. Handing back an empty path is
    % what says "use the original": leaving the slice in place here used to
    % read a temporary copy and then delete it for nothing.
    slicePath = '';
end
end


% =============================================================================
function removeTempFile(tempFile)
if isfile(tempFile)
    delete(tempFile);
end
end
