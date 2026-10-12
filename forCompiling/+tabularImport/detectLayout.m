function layout = detectLayout(filePath, options)
%DETECTLAYOUT  Work out how a tabular data file is put together.
%   LAYOUT = DETECTLAYOUT(FILEPATH) inspects FILEPATH and returns a struct
%   describing it, without reading the whole file. LAYOUT = DETECTLAYOUT(
%   FILEPATH, OPTIONS) lets the caller override what was detected.
%
%   Returned fields
%     filePath      the file that was inspected
%     extension     lower case, with the dot
%     isSpreadsheet true for .xlsx, .xls, .xlsm
%     sheetNames    cell of worksheet names, empty for a text file
%     sheet         the worksheet to read
%     delimiter     the field separator, '' when there is none
%     headerLines   how many leading rows are not data
%     columnNames   1 x numColumns cell of char
%     numColumns    columns of data, time column included
%     fileKind      'generic' or 'photron'
%     timeColumn    index of the time column, or []
%     warnings      1 x N cell of things worth telling the user
%     convention    struct from DECIMALCONVENTION
%
%   OPTIONS is a struct, and may carry any of ColumnNames, HeaderLines,
%   Sheet, Delimiter and FileKind. An override always wins over what was
%   detected, except fileKind: a Photron export is a property of the file
%   and is still recognised after the overrides.
%
%   Only the head of the file is read, so detection stays cheap on a
%   multi hundred megabyte export.
%
%   See also READTABULARFILE, READMATRIX, DECIMALCONVENTION, PREVIEWDIALOG.

arguments
    filePath (1,1) string
    options (1,1) struct = struct()
end

% The probe read has to reach past the header rows into real data. Reading the
% header alone comes back as all NaN and reports no columns at all.
probeRowCount = 25;

layout = struct();
layout.filePath = char(filePath);
% fileparts hands back path, name, extension: taking the second output leaves
% the base name, so "demo_multisheet.xlsx" reported its extension as
% "demo_multisheet", isSpreadsheet was never true, and the whole spreadsheet
% branch below was unreachable
[~, ~, layout.extension] = fileparts(char(filePath));
layout.extension = lower(layout.extension);
layout.isSpreadsheet = any(strcmp(layout.extension, {'.xlsx', '.xls', '.xlsm', '.xlsb'}));
layout.sheetNames = {};
layout.sheet = '';
layout.delimiter = '';
layout.headerLines = 0;
layout.columnNames = {};
layout.numColumns = 0;
layout.fileKind = 'generic';
layout.timeColumn = [];
% How many columns at the left hold no number. Their job depends on which way
% the samples run: in a HORIZONTAL file these are the name columns, and a file
% may well have more than one, so the count is what the import dialog's
% 'Skip cols:' starts from and what READNAMECOLUMN reads the names out of. In a
% VERTICAL file there are usually none, and the one that exists is a text label
% the column trim would drop anyway - now it can be seen and changed.
layout.nameColumns = 0;
% Which way the samples run. 'vertical' is the ordinary case and stays the
% default, so nothing that exists changes; 'horizontal' is for a file that
% carries its channel names down the first column and its samples across the
% columns. There is no third value and no separate code path - one field, and
% READMATRIX transposes on it.
layout.orientation = 'vertical';
layout.warnings = {};
% Which entries of WARNINGS describe the settings rather than the file. Empty
% when none do, which is the case for a text file that needs no repair.
layout.settingNoteIndex = [];
% a default so the spreadsheet branch, which never runs detectDelimiter,
% still has a convention to report
layout.convention = struct('needsRepair', false, 'decimalSeparator', '.', ...
                          'thousandsSep', '', 'reason', 'the file already uses a decimal point');

%% ------------------------------------------------------------- text files
if ~layout.isSpreadsheet
    [layout.delimiter, columnNames, headerLines] = sniffText(layout.filePath);
    if isempty(columnNames)
        % No delimiter could be decided from the text. Rather than give up, read
        % a short block and ask the number parser: a file with no separator at
        % all still has columns, and a single column file still has one.
        probe = tabularImport.fileHead(layout.filePath, 40);
        if isempty(strtrim(probe))
            layout.warnings{end+1} = 'the file looks empty';
        else
            [~, probeInfo] = tabularImport.readMatrix(layout.filePath, layout, probeRowCount);
            columnNames = probeInfo.headerNames;
            headerLines = probeInfo.numHeaderLines;
            layout.numColumns = probeInfo.numColumns;
        end
    else
        layout.numColumns = numel(columnNames);
    end
    layout.headerLines = headerLines;
    layout.columnNames = columnNames;
    layout.convention = tabularImport.decimalConvention(layout.filePath, layout.delimiter);
    % Which way the samples run, decided BEFORE the time axis: a horizontal file
    % is asked for a time ROW, and asking it for the first column would look in
    % the name column, where nothing increases.
    layout.orientation = sniffOrientation(layout, options);
    layout.nameColumns = leadingTextColumns(layout);
    layout.detectedNameColumns = layout.nameColumns;
    % The name columns can be forced as well as detected, for the same reason
    % as the orientation: a caller who knows their file knows. Applied HERE and
    % not with the other overrides, because the names are read a few lines
    % below and it is the count those are read with - forcing it afterwards left
    % the names coming out of a column the caller had said was data.
    % Above the detected count this discards real data, which is the caller's
    % explicit choice and the same bargain 'HeaderLines' has always made.
    wantedNameColumns = optionValue(options, 'NameColumns', NaN);
    if isnumeric(wantedNameColumns) && isscalar(wantedNameColumns) && ...
            ~isnan(wantedNameColumns)
        layout.nameColumns = max(0, round(wantedNameColumns));
    end
    if strcmp(layout.orientation, 'horizontal')
        layout.headerLines = leadingBlankRows(layout);
        % The names come from READMATRIX, not from here.
        %
        % They used to be read here as well, from column A, and the two answers
        % were allowed to disagree: setting 'NameColumns' to zero and then
        % getting the channel names anyway is the last thing a caller who has
        % said "the first column is data" would expect. READMATRIX already knows
        % the rule - the LAST skipped column is the one that names the channel -
        % so this asks it rather than keeping a second reading of it here.
        [~, horizontalInfo] = tabularImport.readMatrix(layout.filePath, ...
            layout, probeRowCount, layout.headerLines);
        layout.columnNames = horizontalInfo.headerNames;
        layout.numColumns = numel(layout.columnNames);
    end
    % An empty column means the text could not be read as numbers, which is a
    % different answer from "the column is not a time axis", so the emptiness
    % is honoured here rather than trimmed away inside FINDTIMECOLUMN.
    if strcmp(layout.orientation, 'horizontal')
        % Samples run across the columns, so the time axis is a ROW. Looking in
        % the first column would look in the name column, where nothing
        % increases and the file would be reported as having no time axis at
        % all - which is how this went wrong before the orientation existed.
        layout.timeColumn = findTimeColumn(horizontalRowValues(layout));
    else
        column = firstColumnValues(layout.filePath, layout.delimiter, ...
            layout.convention, layout.headerLines);
        if isempty(column)
            layout.timeColumn = [];
        else
            layout.timeColumn = findTimeColumn({column});
        end
    end
end

%% ------------------------------------------------------------ spreadsheets
if layout.isSpreadsheet
    layout.sheetNames = sheetnames(layout.filePath);
    if isempty(layout.sheetNames)
        layout.sheetNames = {'Sheet1'};
    end
    wanted = char(string(optionValue(options, 'Sheet', "")));
    if strlength(wanted) > 0
        if any(strcmp(wanted, layout.sheetNames))
            layout.sheet = wanted;
        else
            layout.warnings{end+1} = sprintf( ...
                'there is no worksheet called "%s", using the first one', wanted);
            layout.sheet = layout.sheetNames{1};
        end
    else
        layout.sheet = layout.sheetNames{1};
    end

    [sheetProbe, sheetInfo] = tabularImport.readMatrix(layout.filePath, layout, probeRowCount);
    layout.numColumns = sheetInfo.numColumns;
    layout.columnNames = sheetInfo.headerNames;
    layout.headerLines = sheetInfo.numHeaderLines;
    layout.orientation = sniffOrientation(layout, options);
    layout.nameColumns = leadingTextColumns(layout);
    layout.detectedNameColumns = layout.nameColumns;
    % The name columns can be forced as well as detected, for the same reason
    % as the orientation: a caller who knows their file knows. Applied HERE and
    % not with the other overrides, because the names are read a few lines
    % below and it is the count those are read with - forcing it afterwards left
    % the names coming out of a column the caller had said was data.
    % Above the detected count this discards real data, which is the caller's
    % explicit choice and the same bargain 'HeaderLines' has always made.
    wantedNameColumns = optionValue(options, 'NameColumns', NaN);
    if isnumeric(wantedNameColumns) && isscalar(wantedNameColumns) && ...
            ~isnan(wantedNameColumns)
        layout.nameColumns = max(0, round(wantedNameColumns));
    end
    if strcmp(layout.orientation, 'horizontal')
        layout.headerLines = leadingBlankRows(layout);
        % The names come from READMATRIX, not from here.
        %
        % They used to be read here as well, from column A, and the two answers
        % were allowed to disagree: setting 'NameColumns' to zero and then
        % getting the channel names anyway is the last thing a caller who has
        % said "the first column is data" would expect. READMATRIX already knows
        % the rule - the LAST skipped column is the one that names the channel -
        % so this asks it rather than keeping a second reading of it here.
        [~, horizontalInfo] = tabularImport.readMatrix(layout.filePath, ...
            layout, probeRowCount, layout.headerLines);
        layout.columnNames = horizontalInfo.headerNames;
        layout.numColumns = numel(layout.columnNames);
    end
    % A spreadsheet has no text to scan, so the same test is applied to the
    % probe numbers instead.
    if isempty(sheetProbe)
        layout.timeColumn = [];
    elseif strcmp(layout.orientation, 'horizontal')
        layout.timeColumn = findTimeColumn(horizontalRowValues(layout));
    else
        layout.timeColumn = findTimeColumn({sheetProbe(:, 1)});
    end
end

%% --------------------------------------------------------------- overrides
% What the file itself says, kept next to what the caller asked for. A caller
% who forces a header row count is asking for a row count the file does not
% have, and READMATRIX needs to know which of the two it is looking at: it has
% already dropped the rows the file really has as a header, so a forced count
% is the difference to skip, not the count to skip.
layout.detectedHeaderLines = layout.headerLines;
layout.detectedDelimiter = layout.delimiter;
layout.detectedOrientation = layout.orientation;
layout.detectedNameColumns = layout.nameColumns;
% The orientation is overridden rather than merged: a caller who names one is
% answering a question the sniff cannot be sure of, and being wrong about it
% changes the SHAPE of the result rather than the names on it.
wantedOrientation = lower(char(string(optionValue(options, 'Orientation', ""))));
if strcmp(wantedOrientation, 'horizontal') || strcmp(wantedOrientation, 'vertical')
    layout.orientation = wantedOrientation;
elseif strlength(wantedOrientation) > 0
    layout.warnings{end+1} = sprintf( ...
        'orientation "%s" is not one of vertical or horizontal', wantedOrientation);
end
if strlength(string(optionValue(options, 'Delimiter', ""))) > 0
    layout.delimiter = char(string(optionValue(options, 'Delimiter', "")));
    layout.convention = tabularImport.decimalConvention(layout.filePath, layout.delimiter);
end
if strlength(string(optionValue(options, 'Sheet', ""))) > 0
    layout.sheet = char(string(optionValue(options, 'Sheet', "")));
end

if isfield(options, 'HeaderLines') && isscalar(options.HeaderLines) && ...
        ~isnan(options.HeaderLines)
    layout.headerLines = options.HeaderLines;
end
columnOverride = optionValue(options, 'ColumnNames', strings(1, 0));
if ~isempty(columnOverride)
    if isstring(columnOverride)
        layout.columnNames = cellstr(columnOverride(:).');
    else
        layout.columnNames = columnOverride(:).';
    end
    layout.numColumns = numel(layout.columnNames);
end
if strlength(string(optionValue(options, 'FileKind', "generic"))) > 0
    layout.fileKind = char(string(optionValue(options, 'FileKind', "generic")));
end

% The notes that describe the SETTINGS rather than the file - which worksheet is
% read, and whether the numbers are being rewritten for a decimal comma. Both
% are things the import dialog lets the user change, so they are built by
% SETTINGNOTES from the layout as it stands, and the indices they landed at are
% recorded: a dialog showing these notes live has to be able to drop the ones
% this call produced instead of showing a stale copy beside the current one.
%
% The decimal note comes after the overrides on purpose, so a forced delimiter
% is judged on its own and not on what was detected.
newNotes = tabularImport.settingNotes(layout);
layout.settingNoteIndex = numel(layout.warnings) + (1:numel(newNotes));
layout.warnings = [layout.warnings, newNotes];

% A Photron Graph Express export is a property of the file, not a
% preference, so it is checked after the overrides and cannot be turned off.
%
% This block was commented out at some point, which left the fileKind at
% 'generic' for a Photron export: the file was then imported by the generic
% parser instead of being refused, so READTABULARFILE handed back plausible
% numbers from a file it had no business reading. Nothing above depends on it.
if tabularImport.isPhotronTypeA(layout.filePath)
    layout.fileKind = 'photron';
    layout.warnings{end+1} = ['this file looks like a Photron Graph Express export, ' ...
        'which Vocaliscope reads with its own dedicated importer'];
end
end


% =============================================================================
function [delimiter, columnNames, headerLines] = sniffText(filePath)
%SNIFFTEXT  Decide the delimiter, the header row count and the column names.
delimiter = '';
columnNames = {};
headerLines = 0;

raw = tabularImport.fileHead(filePath, 40);
if isempty(raw)
    return;
end

probe = raw(1:min(30, numel(raw)));
delimiter = detectDelimiter(probe);
if isempty(delimiter)
    return;
end

% Leading rows that hold no numeric data are header rows: a metadata block, a
% unit row, or the variable names.
nonNumericRows = 0;
for k = 1:numel(probe)
    if countNumericValues(probe(k:k), delimiter, 1) == 0
        nonNumericRows = nonNumericRows + 1;
    end
end
headerLines = nonNumericRows;

numericCount = countNumericValues(probe, delimiter, numel(probe));
numColumns = max(1, round(numericCount / max(1, numel(probe) - nonNumericRows)));

% The header row directly above the data describes it most specifically, so
% start there. A file carrying a metadata block would otherwise be named after
% its first metadata row. When that last row holds nothing but short unit
% strings it is a unit row, and the row above it carries the variable names.
nameRow = '';
if headerLines >= 1
    nameRow = raw{headerLines};
    if headerLines >= 2 && looksLikeUnitRow(raw{headerLines}, delimiter)
        nameRow = raw{headerLines-1};
    end
end
columnNames = parseNameRow(nameRow, numColumns, delimiter);
end


% =============================================================================
function fields = splitRow(rowText, delimiter)
%SPLITROW  Split one line on DELIMITER, or on whitespace when there is none.
%   This pair of lines was written out four times over, and the copies could
%   disagree: splitting a semicolon file on whitespace returns the whole header
%   row as one field, so the column names came out as a single long string.
if isempty(delimiter)
    fields = strsplit(strtrim(rowText));
else
    fields = strsplit(strtrim(rowText), delimiter);
end
end


% =============================================================================
function [best, bestCounts] = detectDelimiter(probe)
%DETECTDELIMITER  Score every plausible field separator on the probe rows.
%   The score rewards three things: most of the cells are numbers, every row
%   splits into the same number of fields, and that number is more than one.
%   A candidate that never splits a single row cannot win unless nothing else
%   qualifies, which is the single column file case.
candidates = {',', ';', sprintf('\t'), '|', ' '};
best = '';
bestCounts = [];
bestScore = -Inf;
bestFallback = '';
bestFallbackCounts = [];
bestFallbackScore = -Inf;

for k = 1:numel(candidates)
    dl = candidates{k};
    counts = zeros(1, numel(probe));
    cellsByLine = cell(1, numel(probe));
    usable = false;
    for r = 1:numel(probe)
        fields = splitRow(probe{r}, dl);
        if ~any(cellfun(@isNumericToken, fields))
            continue;
        end
        usable = true;
        cellsByLine{r} = fields;
        counts(r) = numel(fields);
    end
    if ~usable
        continue;
    end

    % horizontal concatenation, never vertcat: the rows hold a differing
    % number of fields and vertcat stacks them as rows and pads the result into
    % a 2D cell array whose per column mean is a vector, not a number
    flat = [cellsByLine{counts > 0}];
    if isempty(flat)
        continue;
    end
    rawOk = cellfun(@isNumericToken, flat);
    commaOk = cellfun(@(x) isNumericToken(strrep(x, ',', '.')), flat);
    numericFraction = max(mean(rawOk), mean(commaOk));

    used = counts(counts > 0);
    if std(used) == 0
        consistency = 1;
    else
        consistency = 1 / (1 + std(used));
    end

    score = numericFraction * 10 + consistency - 0.1 * mean(used);

    if mean(used) < 2
        if score > bestFallbackScore
            bestFallbackScore = score;
            bestFallback = dl;
            bestFallbackCounts = counts;
        end
        continue;
    end

    if score > bestScore
        bestScore = score;
        best = dl;
        bestCounts = counts;
    end
end

if isempty(best)
    best = bestFallback;
    bestCounts = bestFallbackCounts;
end
end


% =============================================================================
function isNumeric = isNumericToken(token)
%ISNUMERICTOKEN  True when TOKEN already has the shape of a number.
%   The token is deliberately NOT cleaned up first. Stripping the offending
%   characters out of a header cell such as "time;sig100" leaves "100100",
%   which parses as a number, so a header row was counted as numeric and any
%   candidate that returned the whole line in one field scored as well as the
%   real delimiter - which is how a tab "delimiter" beat a semicolon.
%   Two shapes are accepted: a plain number, optionally with ',' or '.' as the
%   decimal mark, and a grouped number such as "1.234,5".
token = strtrim(token);
if isempty(token)
    isNumeric = false;
    return;
end
token = strrep(token, ' ', '');

plainPattern = '^[+-]?(\d+|\d*[.,]\d+)([eE][+-]?\d+)?$';
groupedPattern = '^[+-]?\d{1,3}([.,]\d{3})+([.,]\d+)?([eE][+-]?\d+)?$';
isNumeric = ~isempty(regexp(token, plainPattern, 'once')) || ...
            ~isempty(regexp(token, groupedPattern, 'once'));
end


% =============================================================================
function count = countNumericValues(lines, delimiter, maxRows)
%COUNTNUMERICVALUES  How many cells of LINES hold a number.
%   A cell counts under either decimal convention, so a header row comes out
%   as zero whatever decimal mark the file happens to use, and a data row
%   comes out as its number of columns.
%
%   The test is ISNUMERICTOKEN, the same one the delimiter scoring uses, and
%   that is what makes the column count come out right for a file that groups
%   its digits. Reading the cells with str2double instead missed every grouped
%   cell whose grouping separator is a dot - "1.234.567,5" is a number to the
%   regex and NaN to str2double - so a five column file was counted as four and
%   its columns were then named from a miscount.
count = 0;
if isempty(delimiter)
    return;
end
limit = min(numel(lines), maxRows);
for r = 1:limit
    fields = splitRow(lines{r}, delimiter);
    count = count + sum(cellfun(@(f) isNumericToken(strtrim(f)), fields));
end
end


% =============================================================================
function names = parseNameRow(nameRow, numColumns, delimiter)
%PARSENAMEROW  Turn a header line into NUMCOLUMNS cleaned up column names.
%   Placeholders are pre-filled, so a file with no header row, or one whose
%   header row is shorter than the data, still yields a name per column.
names = cell(1, numColumns);
for c = 1:numColumns
    names{c} = sprintf('col%d', c);
end
if isempty(nameRow) || numColumns < 1
    return;
end
fields = splitRow(nameRow, delimiter);
for c = 1:numel(fields)
    name = strtrim(fields{c});
    if ~isempty(name) && c <= numColumns
        names{c} = name;
    end
end
end


% =============================================================================
function tf = looksLikeUnitRow(rowText, delimiter)
%LOOKSLIKEUNITROW  True when a header row holds nothing but short unit strings.
%   "s;deg;ratio;Pa" is a unit row; "time;sig100;ramp;const" is not, because
%   "sig100" is longer than a unit would be.
fields = splitRow(rowText, delimiter);
fields = cellfun(@strtrim, fields, 'UniformOutput', false);
fields = fields(~cellfun(@isempty, fields));
if isempty(fields)
    tf = false;
    return;
end
for c = 1:numel(fields)
    if strlength(fields{c}) > 5 || isNumericToken(fields{c})
        tf = false;
        return;
    end
end
tf = true;
end


% =============================================================================
% =============================================================================
function orientation = sniffOrientation(layout, options)
%SNIFFORIENTATION  Decide whether the samples run down the rows or across the
%   columns.
%   'vertical' unless the caller said otherwise, and unless the file looks
%   horizontal in a way that cannot be mistaken for the ordinary case.
%
%   The test is STRUCTURAL, and both halves of it are required:
%     - the first column holds no number on ANY row, while at least two other
%       columns do. That is what a name column is, and it is why the existing
%       column trim drops it by itself.
%     - at least two rows hold numbers. One numeric row would also fit a file
%       that is simply ragged, and calling that horizontal would transpose a
%       result that was already right.
%
%   Neither half is enough alone: a metadata block makes the first row of a
%   perfectly ordinary file non-numeric, and a ragged export leaves trailing
%   empty columns. Together they are the shape of a file that carries its
%   channel names down the side.
%
%   Note what is NOT asked: whether the numbers start on the first line. They
%   almost never do, because the header row of sample labels is itself text and
%   a metadata block usually sits above it. Requiring the numbers to begin on
%   line one rejected every real horizontal file and was the first version of
%   this test.
%
%   A file that fails the test is read vertically rather than refused. Being
%   wrong here cannot produce an error, only a different answer, so it is far
%   better to hand back a guess the dialog can correct than to refuse to import.
orientation = 'vertical';
wanted = lower(char(string(optionValue(options, 'Orientation', ""))));
if strcmp(wanted, 'horizontal') || strcmp(wanted, 'vertical')
    orientation = wanted;
    return;
end

grid = numericGrid(layout, 60);
if isempty(grid)
    return;
end
columnHasNumber = any(~isnan(grid), 1);
if columnHasNumber(1) || sum(columnHasNumber) < 3
    return;
end
if sum(any(~isnan(grid), 2)) < 2
    return;
end
orientation = 'horizontal';
end


% =============================================================================
function grid = numericGrid(layout, maxRows)
%NUMERICGRID  The file as a matrix of numbers, whatever kind of file it is.
%   The same read for both kinds, so the orientation test is written once and
%   cannot come to mean two things. Text is read and split; a worksheet is read
%   with READMATRIX. Cells that hold no number come back NaN.
grid = [];
try
    if layout.isSpreadsheet
        grid = readmatrix(layout.filePath, 'Sheet', char(layout.sheet));
    elseif isempty(layout.delimiter)
        grid = readmatrix(layout.filePath, 'FileType', 'text');
    else
        grid = readmatrix(layout.filePath, 'FileType', 'text', ...
            'Delimiter', char(layout.delimiter));
    end
catch
    return;
end
if isempty(grid)
    return;
end
if ~isnumeric(grid)
    grid = str2double(grid);
end
% A worksheet has its leading all-text rows put BACK as NaN, so that row r of
% this grid is row r of the sheet.
  %
  % READMATRIX drops them: measured on a sheet of one header row and four data
  % rows it answered with four rows, and the header row was simply not there.
  % That is harmless for the arithmetic of a single reader and wrong for
  % everything that counts rows against it - the horizontal time test skipped
  % the channel that IS the time and picked the one after it instead, so
  % demo_horizontal.xlsx reported its time column as 2 when sig100 is 2.
  % LEADINGBLANKROWS answers from READCELL for exactly this reason; the padding
  % here is what makes that answer usable.
  if isSheet(layout) && ~isempty(grid)
      dropped = leadingBlankRows(layout);
      if dropped > 0
          grid = [nan(dropped, size(grid, 2)); grid];
      end
  end
  grid = grid(1:min(maxRows, size(grid, 1)), :);
  end


% =============================================================================
function n = leadingTextColumns(layout)
%LEADINGTEXTCOLUMNS  How many columns at the left hold no number at all.
%   The counterpart of LEADINGBLANKROWS, and the answer the 'Skip cols:'
%   control starts from.
%
%   Counted over the DATA ROWS only, not over the header. That matters for a
%   horizontal file: its header row is a row of sample labels, which are text,
%   so a test that looked at the header as well would call every column text
%   and swallow the whole file.
%
%   Useful in BOTH orientations, which is why it is not a horizontal-only
%   notion. A vertical file whose first column is a text label is common, and
%   until now that column was dropped silently by the column trim with no way to
%   see or change it; here it becomes a number the dialog shows and the user can
%   alter.
%
%   Capped at eight. Past that it is far more likely to be a file with no
%   numbers at all than a file with eight label columns, and the spinner's
%   limit is the same.
grid = numericGrid(layout, 200);
n = 0;
if isempty(grid)
    return;
end
first = leadingBlankRows(layout) + 1;
if first > size(grid, 1)
    return;
end
block = grid(first:end, :);
while n < min(size(block, 2), 8) && ~any(isfinite(block(:, n + 1)))
    n = n + 1;
end
end


% =============================================================================
function n = leadingBlankRows(layout)
%leadingBlankRows  How many rows sit above the first row that holds a number.
%   Counted the same way as for a vertical file, which turns out to be right
%   here too: the name column is text, so a metadata block and a header row are
%   both rows that hold no number at all.
%
%   That is also why the count has to be asked for rather than assumed to be
%   zero. The name column makes EVERY row partly non-numeric, so a count of
%   "rows holding no number" would return the whole file.
%
%   In a WORKBOOK the count is taken from READCELL rather than from the numeric
%   grid, and that is not a preference. READMATRIX silently drops an all text
%   first row from a sheet - measured, a sheet of one header row and four data
%   rows came back as four rows - so the numeric grid is already one row short
%   before anything is counted, and counting inside it answers "zero" for a
%   file that plainly has a header. Everything downstream then reads one row
%   too high, and the channel names come back as the header's own labels.
%
%   READCELL gives every row, header and all, so the count is taken of the file
%   as it is written rather than of what the reader chose to hand back.
if isSheet(layout)
    n = leadingBlankRowsOfSheet(layout);
    return;
end
grid = numericGrid(layout, 200);
n = 0;
if isempty(grid)
    return;
end
rowHasNumber = any(~isnan(grid), 2);
first = find(rowHasNumber, 1, 'first');
if isempty(first)
    n = size(grid, 1);
    return;
end
% Only the run at the top counts. A gap in the middle is data with a hole in
% it, and that is the BLANKS policy's business, not the header's.
while n + 1 < first
    n = n + 1;
end
end


% =============================================================================
function n = leadingBlankRowsOfSheet(layout)
%LEADINGBLANKROWSOFSHEET  The same count for a workbook, from the cells.
rows = 200;
n = 0;
try
    letters = tabularImport.columnLetters(8);
    grid = readcell(layout.filePath, 'Sheet', char(layout.sheet), ...
        'Range', sprintf('A1:%s%d', letters{end}, rows));
catch
    return;
end
if isempty(grid)
    return;
end
for r = 1:size(grid, 1)
    % One row of the sheet read as text, converted a cell at a time rather than
    % by passing the whole grid to STRTOD: the first cell of a horizontal row is
    % a channel NAME, so an all text row here is a channel name and not a hole,
    % and what matters is whether the row holds a NUMBER anywhere.
    rowIsData = false;
    for c = 1:size(grid, 2)
        value = grid{r, c};
        if isnumeric(value) || islogical(value)
            rowIsData = true;
            break;
        end
        if iscell(value)
            value = value{1};
            if isnumeric(value) && ~isnan(value)
                rowIsData = true;
                break;
            end
        end
    end
    if rowIsData
        return;
    end
    n = n + 1;
end
end


% =============================================================================
function tf = isSheet(layout)
%ISSHEET  Whether this layout points at a workbook rather than a text file.
tf = isfield(layout, 'isSpreadsheet') && ~isempty(layout.isSpreadsheet) ...
    && layout.isSpreadsheet;
end


% =============================================================================
function candidates = horizontalRowValues(layout)
%HORIZONTALROWVALUES  One numeric column per data row, for the time axis test.
%   The transpose of FIRSTCOLUMNVALUES, which is the whole point: with the
%   samples across the columns, a time axis is a ROW and has to be offered as
%   one. A cell per row rather than a matrix, because FINDTIMECOLUMN asks about
%   each candidate separately and an empty one has to stay distinguishable from
%   a short one.
candidates = {};
grid = numericGrid(layout, 200);
if isempty(grid)
    return;
end
first = leadingBlankRows(layout) + 1;
last = size(grid, 1);
if first > last
    return;
end
block = grid(first:last, :);
% The name column holds no numbers by definition, so it is already NaN and is
% left out here rather than offered as a candidate that can never win.
block = block(:, any(~isnan(block), 1));
for r = 1:size(block, 1)
    values = block(r, :);
    values = values(isfinite(values));
    if numel(values) >= 2
        candidates{end+1} = values(:); %#ok<AGROW>
    end
end
end


% =============================================================================
function values = firstColumnValues(filePath, delimiter, convention, headerLines)
%FIRSTCOLUMNVALUES  The first column of a text file as numbers, or [] if any
%   row of it fails to read.
%
%   Only the first column is read. A time axis belongs at the front of a data
%   file; if it is not there, the user is better served by being asked for a
%   sampling frequency than by having a data column silently promoted.
%
%   One unreadable row rejects the whole column rather than being skipped. That
%   is the difference from the spreadsheet path, which trims the gaps: here the
%   rows are text and a row that does not parse means the column is not what it
%   appears to be.
values = [];
if isempty(delimiter)
    return;
end
raw = tabularImport.fileHead(filePath, 32 * 1024);
if isempty(raw)
    return;
end
% Every header row has to be dropped, not just the first one: with a unit row
% still in place the very first value fails to parse and the whole time column
% is missed.
lines = raw;
if ~isempty(headerLines) && numel(lines) > headerLines
    lines = lines(headerLines+1:end);
end
if numel(lines) < 2
    return;
end
% Measured with a rule that TOLERATES gaps. It used to reject the whole
    % column if a single value did not parse, which meant one dropped sample
    % made a file with an obvious time axis look as though it had none - the
    % user was asked for a sampling frequency that the file contained. The
    % unparseable value is kept as NaN instead, and FINDTIMECOLUMN then works
    % on the finite samples; a column that is not numbers at all comes back as
    % nothing but NaN and is rejected there for the same reason as before.
    values = nan(numel(lines), 1);
    for r = 1:numel(lines)
        fields = splitRow(lines{r}, delimiter);
        values(r) = parseNumber(strtrim(fields{1}), convention);
    end
end


% =============================================================================
function idx = findTimeColumn(candidates)
%FINDTIMECOLUMN  The first of CANDIDATES that looks like a time axis.
%   CANDIDATES is a cell array of numeric column vectors. A time axis is
%   strictly increasing and is not a plain 0,1,2,... counter; the counter test
%   is what keeps an index column from being mistaken for one.
%
%   The text and the spreadsheet paths used to be two functions repeating this
%   test between them. It is one test, and they differed only in where the
%   numbers came from, so the caller supplies them now. Non-finite values are
%   dropped here rather than treated as a failure: that suits the spreadsheet,
%   whose blanks are genuinely gaps.
idx = [];
for c = 1:numel(candidates)
    values = candidates{c};
    values = values(isfinite(values));
    if numel(values) < 2
        continue;
    end
    if any(diff(values) <= 0)
        continue;
    end
    % Compared with a tolerance, because a counter read from a text file rarely
    % lands on exactly 1.0.
    span = values - values(1);
    n = numel(span);
    if n > 1 && max(abs(span - (0:n-1)')) < 1e-9
        continue;
    end
    idx = c;
    return;
end
end


% =============================================================================
function value = parseNumber(token, convention)
%PARSENUMBER  Read one token as a number under the given convention.
if convention.needsRepair
    value = str2double(strrep(token, ',', '.'));
    if isnan(value)
        value = str2double(strrep(strrep(token, ' ', ''), ',', ''));
    end
else
    value = str2double(token);
    if isnan(value)
        value = str2double(strrep(token, ',', ''));
    end
end
end


% =============================================================================
function value = optionValue(options, name, fallback)
%OPTIONVALUE  Read a field from the OPTIONS struct, with a fallback.
if isfield(options, name) && ~isempty(options.(name))
    value = options.(name);
else
    value = fallback;
end
end