function [xdata, ydata, sampleRate, columnNames, info] = readTabularFile(filePath, varargin)
%READTABULARFILE  Open a text data file and import it as samples by channels.
%
%   [XDATA, YDATA] = READTABULARFILE(FILEPATH) imports FILEPATH. XDATA is the
%   time axis in seconds, a SAMPLES x 1 vector. YDATA is the channels, a
%   SAMPLES x CHANNELS matrix with the time column taken out of it. That split
%   is the shape of the whole result: one vector for the x axis, one matrix of
%   signals beside it, and neither of them carrying the other.
%
%   READTABULARFILE() with no file name asks you to pick one.
%
%   Returned values
%     XDATA          SAMPLES x 1, in seconds, [] when there is no time vector
%     YDATA          SAMPLES x CHANNELS, double, time column removed, [] when
%                    the import was cancelled or came to nothing
%     SAMPLERATE     in Hz, or NaN when none could be derived or asked for
%     COLUMNNAMES    1 x CHANNELS cell of char, one per column of YDATA
%     INFO.filePath  the file that was read
%     INFO.layout    the parsed layout that was used
%     INFO.rowCount  SAMPLES
%     INFO.sourceColumns  which column of the FILE each channel came from
%     INFO.warnings  1 x N cell of things worth knowing
%     INFO.accepted  false when the dialog was cancelled
%
%   Outputs are positional: MATLAB fills the leading ones, so a caller who only
%   wants the channels has to say [~, ydata] = ..., not [ydata] = ... .
%
%   Every path out assigns all five. A cancelled import, a file picker closed
%   with nothing chosen, and a sampling rate that was never confirmed all give
%   XDATA [], YDATA [], SAMPLERATE NaN, COLUMNNAMES {} and INFO.accepted false.
%   None of them raise, and deliberately so: an output left unset makes the
%   CALLER fail with "Output argument not assigned", which reports a broken
%   function rather than a cancelled import.
%
%   The dialog
%   ----------
%   It shows two panes side by side. The left one lists the first lines of
%   the file exactly as they are on disk. The right one has a table of the
%   columns to choose from - a name to give each channel, whether to import it
%   at all, and which one is the time vector - above a table of the numbers as
%   they were parsed, with the columns that will be imported shaded and the
%   time column shaded differently, and every row tagged with the line of the
%   file it came from. A wrong delimiter, a wrong header row count, a wrong
%   decimal mark or a column that got swallowed all show up as a difference
%   between the two panes, and the Import button is greyed whenever the settings
%   could not bring in anything at all. See PREVIEWDIALOG.
%
%   Importing without the dialog
%   ----------------------------
%   Pass 'NoDialog', true to import straight away using the detected layout,
%   which is what you want from a script.
%
%   Name-value options
%     'NoDialog'     skip the preview dialog (default false)
%     'SampleRate'   force the sample rate instead of deriving or asking
%     'Delimiter'    force the field delimiter
%     'HeaderLines'  force the number of leading non-data rows
%     'ColumnNames'  force the column names, one per COLUMN OF THE FILE, the
%                   time column included; a column with no name of its own
%                   comes back as colN and the count is reported in INFO.warnings
%     'Sheet'        select a worksheet of a workbook
%     'TimeColumn'   force the time column index, or [] when there is none
%     'Parent'       uifigure to parent the dialog to
%     'Orientation'  'vertical' or 'horizontal' - which way the samples run.
%                   Empty by default, which is the instruction to let the file
%                   decide; a horizontal file carries its channel names down the
%                   first column and its samples across, and is read sideways.
%                   The result is turned upright either way, so everything here
%                   - the channel names, the blanks policy, the rate - is in
%                   the same terms whichever way the file was written.
%     'NameColumns'  how many columns at the left are NOT data. In a horizontal
%                   file these are the name columns and the channel names are
%                   read from the LAST of them, so a count of two on a file with
%                   Group | Name | v1 | v2 | ... takes the names from the inner
%                   one. In a vertical file it is usually zero. NaN by default,
%                   which is the instruction to let the sniff decide; above the
%                   detected count it discards real data, which is the caller's
%                   own choice and the same bargain 'HeaderLines' makes.
%     'Blanks'       what to do with cells holding no number: 'keep' (the
%                   default), 'drop', or any of the FILLMISSING methods -
%                   'previous', 'next', 'nearest', 'linear', 'spline', 'pchip',
%                   'makima'. Every method except 'keep' fills what can be
%                   filled and DROPS the samples it cannot: a hole at the start
%                   or the end of a channel has nothing on one side to
%                   interpolate from, and is removed rather than invented.
%                   See TABULARIMPORT.FILLBLANKS.
%
%   Examples
%   --------
%   Open any file, picked from a browse dialog:
%       tabularImport.readTabularFile();
%
%   Look at one of the demo files that ships in this package. Nothing has to
%   be added to the path and no directory has to be changed, because
%   DEMOFILE finds the folder relative to the package:
%       tabularImport.readTabularFile( ...
%           tabularImport.demoFile('demo_german_decimalcomma.csv'))
%
%   That file is semicolon separated and its numbers use a decimal comma.
%   Watch the left pane in the dialog: each line splits into four fields, and
%   the warning box says the decimal separator was detected. Set Decimal to
%   "point ." and the numbers turn into nonsense, which is the fastest way to
%   see what that dropdown does.
%
%   The other demo files, each exercising one thing:
%       tabularImport.demoFile('demo_comma.csv')               plain comma
%       tabularImport.demoFile('demo_german_decimalcomma.csv')  semicolon, decimal comma
%       tabularImport.demoFile('demo_german_thousands.csv')    "1.234.567,5" grouping
%       tabularImport.demoFile('demo_tab.tsv')                  tab separated
%       tabularImport.demoFile('demo_whitespace_noheader.txt')  spaces, no header
%       tabularImport.demoFile('demo_twoheaderrows.csv')        a name row over a unit row
%       tabularImport.demoFile('demo_shortheader.csv')          two names for four columns
%       tabularImport.demoFile('demo_nonuniform_time.csv')      a gap in the time axis
%       tabularImport.demoFile('demo_notimecolumn.txt')         no time vector at all
%       tabularImport.demoFile('demo_multisheet.xlsx')          two worksheets
%       tabularImport.demoFile('demo_metadatablock_notphotron.csv')  metadata on top
%   DEMOFILE() with no argument lists them all.
%
%   Import one straight through, without the dialog, and plot it. XDATA is the
%   axis, YDATA the signals, and SAMPLERATE the number the title quotes:
%       [x, y, fs, names] = tabularImport.readTabularFile( ...
%           tabularImport.demoFile('demo_comma.csv'), 'NoDialog', true);
%       plot(x, y(:,1))
%       xlabel('time (s)'); ylabel(names{1});
%       title(sprintf('%d samples at %g Hz', size(y,1), fs))
%
%   Two header rows: the dialog should keep "Header rows" at 2 and name the
%   channels from the first row, not from the unit row underneath it:
%       tabularImport.readTabularFile( ...
%           tabularImport.demoFile('demo_twoheaderrows.csv'))
%
%   A workbook, picking the second worksheet:
%       [~, y] = tabularImport.readTabularFile( ...
%           tabularImport.demoFile('demo_multisheet.xlsx'), ...
%           'NoDialog', true, 'Sheet', 'other');
%
%   Force a layout instead of detecting it, for a file with no header. The
%   names are one per column of the file and the time column is one of them,
%   which is the same thing the dialog's Name column shows:
%       [x, y, ~, names] = tabularImport.readTabularFile( ...
%           tabularImport.demoFile('demo_whitespace_noheader.txt'), ...
%           'NoDialog', true, 'Delimiter', ' ', 'HeaderLines', 0, ...
%           'ColumnNames', {'time', 'sig100', 'ramp', 'const'});
%   % names is {'sig100' 'ramp' 'const'} and x is 0, 0.001, 0.002, ... - the
%   % time column is not a channel, so its name does not come back as one
%
%   When there is nothing to import
%   -----------------------------
%   Three layouts produce no channels at all, and each raises rather than
%   handing back an empty DATA. An empty DATA is a silent failure: the caller
%   gets a zero row matrix back and has no way of telling a file with nothing in
%   it from a parse that went wrong.
%
%   Nothing in the file reads as a number with the layout given - a delimiter
%   that does not fit, usually:
%       tabularImport.readTabularFile( ...
%           tabularImport.demoFile('demo_comma.csv'), ...
%           'NoDialog', true, 'Delimiter', ';')
%       % Error using tabularImport.readTabularFile
%       % nothing in this file reads as a number with the layout given ...
%   with the id tabularImport:nothingReadable.
%
%   A header row count that covers the whole file, so no data row is left:
%       tabularImport.readTabularFile( ...
%           tabularImport.demoFile('demo_comma.csv'), ...
%           'NoDialog', true, 'HeaderLines', 400)
%       % Error using tabularImport.readTabularFile
%       % ... all 400 header row(s) cover the whole file.
%   with the id tabularImport:noDataColumn. A forced header row count used to
%   be ignored outright on the reading that is returned, so this used to hand
%   back the whole file instead.
%
%   A selection with no column ticked raises tabularImport:noColumnsSelected,
%   which only the dialog can produce - a head-less call has no ticks to clear.
%
%   A file with no time vector
%   ----------------------------
%   The time vector is only taken from the first column, and only when it
%   really is one: strictly increasing, and not a plain 0,1,2,... counter.
%   If there is none, every column is treated as data and a sampling frequency
%   is asked for, because there is nothing to derive one from. With the dialog
%   you get a small window to type it into; head-less there is nobody to ask,
%   so the call says so and stops:
%       [x, y, fs] = tabularImport.readTabularFile( ...
%           tabularImport.demoFile('demo_notimecolumn.txt'), ...
%           'NoDialog', true, 'SampleRate', 44100);
%   % Error using tabularImport.readTabularFile
%   % demo_notimecolumn.txt has no time column, so the sampling rate cannot
%   % be worked out. Pass 'SampleRate', in Hz, ...
%
%   A Photron Graph Express export is refused on purpose, because Vocaliscope
%   reads those with its own dedicated importer:
%       tabularImport.readTabularFile( ...
%           tabularImport.demoFile('demo_photron_typeA.csv'))
%   % Error: this file looks like a Photron Graph Express export, ...
%
%   See also DEMOFILE, PREVIEWDIALOG, DETECTLAYOUT, READMATRIX, ...
%              DECIMALCONVENTION, TESTREADTABULARFILE.
%
%   This package has no dependency on Vocaliscope, so it can be lifted into
%   any other tool that has to read a delimited text or spreadsheet file and
%   show the user what it made of it.

arguments
    filePath (1,1) string = ""
end
% A bare varargin in the block above is only tolerated by newer releases; it
% has to be declared as a Repeating argument to be accepted everywhere.
arguments (Repeating)
    varargin
end

if strlength(filePath) == 0
    [name, folder] = uigetfile('*.*', 'Choose a data file to import');
    if isequal(name, 0)
        % picking nothing is the same answer as cancelling the dialog.
        %
        % EVERY output is assigned on the way out, not just the two that carry
        % a value. An output left unset makes the CALLER fail with "Output
        % argument "xdata" not assigned a value", so somebody asking for all
        % five results would be told the function is broken rather than that
        % the import was cancelled.
        xdata = [];
        ydata = [];
        sampleRate = NaN;
        columnNames = {};
        info = emptyInfo();
        return;
    end
    filePath = string(fullfile(folder, name));
end

% varargin is already a cell array, so it has to be spread with {:}; passing it
% bare hands parseOptions one argument - the cell itself - and every pair then
% looks like half a pair
options = parseOptions(varargin{:});

% DetectLayout is where the time goes on a spreadsheet, and it happens BEFORE
% the preview dialog exists, so this is the only place a progress window can
% be put up for it. Only when the dialog is coming: 'NoDialog' is the
% programmatic path, and putting a window on screen for a caller that asked
% for no windows - the test suites among them - is not a courtesy.
if options.NoDialog
    layout = tabularImport.detectLayout(filePath, layoutOverrides(options));
else
    layout = tabularImport.withProgress( ...
        @() tabularImport.detectLayout(filePath, layoutOverrides(options)), ...
        [], "Analysing the file");
end

if strcmp(layout.fileKind, 'photron')
    error('tabularImport:photronNeedsOwnImporter', ...
        ['%s looks like a Photron Graph Express export. Vocaliscope reads ' ...
         'those with its own dedicated importer, so this importer will not ' ...
         'touch it.'], char(java.io.File(char(filePath)).getName()));
end

% ------------------------------------------------------------------- dialog
if ~options.NoDialog
    previewRowCount = 25;
    [preview, previewInfo] = tabularImport.readMatrix(layout.filePath, layout, ...
        previewRowCount, previewRowCount);
    [accepted, layout] = tabularImport.previewDialog(layout, preview, ...
        previewInfo, options.Parent);
    if ~accepted
        xdata = [];
        ydata = [];
        sampleRate = NaN;
        columnNames = {};
        info = emptyInfo();
        return;
    end
end

% --------------------------------------------------------------------- read
[ydata, readInfo] = tabularImport.readMatrix(layout.filePath, layout, [], []);

if isempty(ydata)
    % An empty DATA is a silent failure: the caller cannot tell a file with no
    % data in it from a parse that went wrong, so this says which it was and
    % stops. The dialog greys its Import button for exactly these cases; this
    % is the same rule for a head-less call.
    name = char(java.io.File(char(filePath)).getName());
    if isfield(readInfo, 'allNaN') && readInfo.allNaN
        error('tabularImport:nothingReadable', ...
            ['%s holds nothing that reads as a number with the layout given ' ...
             '(delimiter "%s", %d header row(s)). Try another delimiter, ' ...
             'header row count or decimal mark.'], name, layout.delimiter, ...
            layout.headerLines);
    end
    error('tabularImport:noDataColumn', ...
        ['%s holds no numeric rows below its header: all %d header row(s) ' ...
         'cover the whole file.'], name, layout.headerLines);
end

% ----------------------------------------------------------- time and rate
timeColumn = options.TimeColumn;
if isempty(timeColumn)
    timeColumn = layout.timeColumn;
end

nRows = size(ydata, 1);
time = [];
sampleRate = NaN;
hasTimeColumn = ~isempty(timeColumn) && timeColumn >= 1 && ...
    timeColumn <= size(ydata, 2);
if hasTimeColumn
    candidate = ydata(:, timeColumn);
    % The rate is worked out from the samples that ARE there, not from the whole
    % axis. One dropped sample in a recording is ordinary, and the old test -
    % reject the column outright if a single value is not finite - answered a
    % five second glitch by throwing away a two hour time axis and asking the
    % user for a frequency the file already contained.
    %
    % MEDIAN is NaN propagating: one NaN among the steps is enough to make it
    % answer NaN, and the rate would then be NaN as well. Hence the finite
    % samples only.
    present = candidate(isfinite(candidate));
    if numel(present) >= 2 && all(diff(present) > 0)
        time = candidate;
        sampleRate = readableRate(1 / median(diff(present)));
        if ~isfinite(sampleRate) || sampleRate <= 0
            sampleRate = NaN;
            time = [];
        end
    end
end

if isfinite(options.SampleRate) && options.SampleRate > 0
    % An explicit rate wins, and it is what makes a time axis for a file that
    % has none of its own.
    sampleRate = options.SampleRate;
    if isempty(time)
        time = (0:nRows-1)' / sampleRate;
    end
elseif isempty(time)
    % Nothing to derive a rate from. Ask for one rather than inventing it.
    if options.NoDialog
        error('tabularImport:noTimeColumn', ...
            ['%s has no time column, so the sampling rate cannot be worked ' ...
             'out. Pass ''SampleRate'', in Hz, or use the dialog and fill the ' ...
             'rate in there.'], char(java.io.File(char(filePath)).getName()));
    end
    sampleRate = tabularImport.askSampleRate('tabularImport', [], ...
        options.Parent);
    if isempty(sampleRate) || ~isfinite(sampleRate) || sampleRate <= 0
        % the window was closed, so the import is abandoned. As with the cancel
        % path above, every output is assigned before returning.
        xdata = [];
        ydata = [];
        sampleRate = NaN;
        columnNames = {};
        info = emptyInfo();
        info.warnings = {'the sampling frequency was not confirmed'};
        return;
    end
    time = (0:nRows-1)' / sampleRate;
end

% ------------------------------------------------- which columns are channels
% The dialog may have narrowed the selection, and the time column is never a
% channel, so it is dropped from the selection as well.
keep = 1:size(ydata, 2);
if isfield(layout, 'selectedColumns') && ~isempty(layout.selectedColumns)
    candidate = layout.selectedColumns(:).';
    if all(candidate >= 1) && all(candidate <= size(ydata, 2))
        keep = candidate;
    end
end
% A column marked as the time vector is the time axis, not a channel, so it is
% removed from the selection. The time values themselves are kept, because
% they are the whole point of marking it.
if ~isempty(timeColumn) && any(keep == timeColumn)
    keep(keep == timeColumn) = [];
end
if isempty(keep)
    % Same reasoning as the empty read above: an empty DATA here would be
    % indistinguishable from a successful import of a file with no channels.
    error('tabularImport:noColumnsSelected', ...
        ['%s: no column is ticked as data, so there is nothing to import. ' ...
         'Tick at least one column as data.'], ...
        char(java.io.File(char(filePath)).getName()));
end

% The names have to be picked with the same indices as the data. Dropping the
% time column and then keeping the first N names left every name shifted by
% one, so the first signal channel was reported under the name "time".
allNames = layout.columnNames;
unnamedColumns = 0;
if numel(allNames) < size(ydata, 2)
    unnamedColumns = size(ydata, 2) - numel(allNames);
    for c = numel(allNames)+1:size(ydata, 2)
        allNames{c} = sprintf('col%d', c);
    end
end
names = allNames(keep);

% colN is what the importer invents when a name is missing, so those
% placeholders are renumbered by their position in the imported channel list:
% keeping the original index would leave "col2" as the first channel whenever
% the time column in front of it had been dropped.
%
% The loop counts rather than iterating over FIND: with a logical mask and an
% empty result, FIND hands back an empty, and an indexed assignment with an
% empty index is what raises "Assigning to 0 elements using a simple assignment
% statement". Counting cannot produce an empty index, so the renumbering cannot
% fail on that ground whatever the mask came out as.
names = cellfun(@char, names(:).', 'UniformOutput', false);
for c = 1:numel(names)
    if ~isempty(regexp(names{c}, '^col\d+$', 'once'))
        names{c} = sprintf('col%d', c);
    end
end

ydata = ydata(:, keep);

% ------------------------------------------------------- cells holding no number
% Applied to the SELECTED channels only, so a blank in a column nobody asked
% for cannot shorten the result. The time axis goes in beside them because a
% row dropped here has to come out of both, and FILLBLANKS is the only place
% that knows how to keep them in step.
[ydata, time, blankReport] = tabularImport.fillBlanks(ydata, time, options.Blanks);

% -------------------------------------------------------------------- info
warnings = layout.warnings;
warnings = blanksWarning(warnings, blankReport);
% The two trims are reported only for a VERTICAL read. Turned on its side, the
% same numbers mean the opposite thing: the trimmed column is the NAME column,
% which was taken for channel names and must never be offered as a channel, and
% the trimmed rows are the metadata block that the orientation note already
% accounts for. Reporting them again would claim that a channel had been
% discarded - which is the one thing a user reading sideways is most likely to
% worry about.
if ~strcmp(layout.orientation, 'horizontal')
    if isfield(readInfo, 'trimmedColumns') && readInfo.trimmedColumns > 0
        warnings{end+1} = sprintf('%d empty column(s) were discarded', ...
            readInfo.trimmedColumns);
    end
    if isfield(readInfo, 'droppedLeadingRows') && readInfo.droppedLeadingRows > 0
        warnings{end+1} = sprintf('%d row(s) above the numeric data were discarded', ...
            readInfo.droppedLeadingRows);
    end
end
if unnamedColumns > 0
    % The layout named fewer columns than the file holds. That is a silent loss
    % of a name, and often of a column's worth of meaning, so it is said out
    % loud instead of coming back as a channel called col7.
    warnings{end+1} = sprintf(['%d column(s) had no name and were called ' ...
        'colN after the ones that did'], unnamedColumns);
end
if isempty(warnings)
    warnings = {''};
end

xdata=time;
columnNames=names;

info = struct('filePath', char(filePath), ...
              'layout', layout, ...
              'accepted', true, ...
              'rowCount', size(ydata, 1), ...
              'sourceColumns', keep(:), ...
              'blanks', blankReport, ...
              'warnings', {warnings});
end


% =============================================================================
function warnings = blanksWarning(warnings, report)
%BLANKSWARNING  Say what was done about the cells that hold no number.
%   Only says anything when something was done: a file with no blanks in it
%   needs no note, and a warning about nothing is noise.
%
%   Every count here is about the WHOLE file. The import dialog can only count
%   the rows it previewed, and it says "in the preview" when it does - so the
%   two never claim to be the same number.
    if report.droppedTime > 0
        warnings{end+1} = sprintf( ...
            ['%d row(s) were dropped because the time axis has no value for ' ...
             'them; a sample with no time has no place on the axis, and ' ...
             'nothing was invented for it'], report.droppedTime);
    end
    if report.droppedData > 0
        warnings{end+1} = sprintf( ...
            '%d row(s) were dropped because a value in them is not a number', ...
            report.droppedData);
    end
    if report.filled > 0
        warnings{end+1} = sprintf( ...
            '%d of %d cell(s) that held no number were filled by %s', ...
            report.filled, report.blanks, report.method);
    end
    if report.droppedEdge > 0
        % Its own sentence, because this is the anti-extrapolation rule and it
        % is the one place where a sample is lost that no policy asked to lose
        % it. A hole at the very start or the very end of a channel has values
        % on one side only; FILLMISSING will invent the other, so the sample is
        % removed here instead of being continued past the data.
        warnings{end+1} = sprintf( ...
            ['%d row(s) were dropped rather than filled: the gap runs to the ' ...
             'start or the end of a channel, where there is nothing on the ' ...
             'other side to interpolate from and nothing was invented'], ...
            report.droppedEdge);
    end
    if report.unfilled > 0
        % Now only reachable under 'keep', which is the one method that leaves
        % a hole rather than removing the sample. Worth its own sentence: it is
        % the difference between a hole the user asked for and one nobody saw.
        warnings{end+1} = sprintf( ...
            ['%d cell(s) still hold no number, because "%s" was asked to keep ' ...
             'them; every other method removes a sample it cannot fill'], ...
            report.unfilled, report.method);
    end
if report.nonUniform
    warnings{end+1} = ['rows were removed, so the samples are no longer ' ...
        'evenly spaced in time; the sampling frequency reported is the median ' ...
        'spacing, which is not a spacing every pair of samples shares'];
end
end


% =============================================================================
function options = parseOptions(varargin)
%PARSEOPTIONS  Validate the name-value pairs.
validators = {'NoDialog', 'numeric', 'SampleRate', 'positive', ...
    'Delimiter', 'char', 'HeaderLines', 'nonnegative', ...
    'ColumnNames', 'cellstr', 'Sheet', 'char', ...
    'TimeColumn', 'nonnegative', 'Parent', 'uifigure', ...
      'Blanks', 'char', 'Orientation', 'char', ...
    'NameColumns', 'nonnegative'};
if mod(numel(varargin), 2) ~= 0
    error('tabularImport:notNameValue', ...
        'Options must be given as name-value pairs.');
end
options = struct('NoDialog', false, 'SampleRate', NaN, 'Delimiter', '', ...
    'HeaderLines', NaN, 'ColumnNames', {{}}, 'Sheet', '', ...
    'TimeColumn', [], 'Parent', [], 'Blanks', 'keep', ...
    'Orientation', '', 'NameColumns', NaN);
for k = 1:2:numel(varargin)
    name = varargin{k};
    value = varargin{k+1};
    if ~ischar(name) && ~(isstring(name) && isscalar(name))
        error('tabularImport:notNameValue', 'Option names must be text.');
    end
    name = char(string(name));
    if ~any(strcmpi(name, validators(1:2:end)))
        error('tabularImport:unknownOption', ...
            'Unknown option "%s". Known options: %s.', name, ...
            strjoin(validators(1:2:end)', ', '));
    end
    switch name
        case 'NoDialog'
            options.NoDialog = logical(value);
        case 'SampleRate'
            if ~isnumeric(value) || ~isscalar(value) || ~isfinite(value) || value <= 0
                error('tabularImport:badSampleRate', ...
                    'SampleRate must be a positive number of Hz.');
            end
            options.SampleRate = value;
        case 'Delimiter'
            options.Delimiter = char(string(value));
        case 'HeaderLines'
            if ~isnumeric(value) || ~isscalar(value) || value < 0
                error('tabularImport:badHeaderLines', ...
                    'HeaderLines must be a non-negative whole number.');
            end
            options.HeaderLines = value;
        case 'ColumnNames'
            if isstring(value) || ischar(value)
                options.ColumnNames = cellstr(string(value(:).'));
            else
                options.ColumnNames = value(:).';
            end
        case 'Sheet'
            options.Sheet = char(string(value));
        case 'Orientation'
            % 'vertical', 'horizontal', or '' for the sniff. An empty default
            % rather than 'vertical', because DETECTLAYOUT is the thing that
            % decides it and forcing the answer here would hide the decision
            % from the dialog as well as from the caller.
options.Orientation = char(string(value));
        case 'NameColumns'
            % How many columns at the left are not data. In a horizontal file
            % these are the name columns, and there may be more than one; in a
            % vertical one they are usually none. NaN by default, which is the
            % instruction to let the sniff decide.
            options.NameColumns = value;
        case 'Blanks'
            % Validated by FILLBLANKS itself, which is where the list of
            % methods lives. Duplicating the list here would be a second
            % answer to the same question waiting to disagree with the first.
            options.Blanks = char(string(value));
        case 'TimeColumn'
            if isempty(value)
                options.TimeColumn = [];
            elseif ~isnumeric(value) || ~isscalar(value) || value < 1
                error('tabularImport:badTimeColumn', ...
                    'TimeColumn must be a column index, or [] for none.');
            else
                options.TimeColumn = value;
            end
        case 'Parent'
            options.Parent = value;
    end
end
end


% =============================================================================
function overrides = layoutOverrides(options)
%LAYALOVERRIDES  The subset of the options DETECTLAYOUT understands.
overrides = struct('Delimiter', string(options.Delimiter), ...
                     'Sheet', string(options.Sheet), ...
                     'Orientation', string(options.Orientation), ...
                     'NameColumns', options.NameColumns, ...
                     'HeaderLines', options.HeaderLines, ...
                     'ColumnNames', string(options.ColumnNames));
end


% =============================================================================
function info = emptyInfo()
%EMPTYINFO  What is returned when nothing was imported.
%   The same fields as a successful import, with the same shape, so a caller
%   can read INFO.filePath or INFO.warnings without first checking INFO.accepted.
%   Time, rate and channel names are not here at all: they are separate outputs
%   now, and they come back as [], NaN and {} beside this.
info = struct('filePath', '', ...
              'layout', struct(), ...
              'accepted', false, ...
              'rowCount', 0, ...
              'sourceColumns', [], ...
              'warnings', {{'the import was cancelled'}});
end


% =============================================================================
function rate = readableRate(rate)
%READABLERATE  Round a worked out sampling rate to a number someone would write.
%   The rate is 1/median(diff(time)), a quotient of two doubles, so a file
%   recorded at exactly 1000 Hz comes back as 999.999999999999. That is not
%   wrong, it is arithmetic, but it is the number that ends up in a file name, a
%   legend and a channel label, and nobody ever wrote it down. Nine significant
%   figures is far more than a rate has digits in: it takes the arithmetic
%   noise off and leaves every digit a real recording could have come from.
%
%   A rate that is not a positive finite number is passed straight back, so the
%   caller still sees the failure - and the OUTPUT IS ALWAYS ASSIGNED, because
%   returning early without assigning it makes the caller fail with "Assigning
%   to 0 elements using a simple assignment statement" instead of being told
%   that the rate was no good.
if isfinite(rate) && rate > 0
    scale = 8 - floor(log10(abs(rate)));
    rate = round(rate * 10^scale) / 10^scale;
end
end
