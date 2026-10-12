function [accepted, layout, fig] = previewDialog(layout, preview, previewInfo, ~, varargin)
%PREVIEWDIALOG  Show the file and the parsed data, and let the user correct them.
%   [ACCEPTED, LAYOUT] = PREVIEWDIALOG(LAYOUT, PREVIEW, PREVIEWINFO) shows a
%   modal dialog and waits, which is what READTABULARFILE wants. Pass PARENT
%   to centre the window on an existing uifigure.
%
%   The layout of the window
%   ------------------------
%   The file is on the LEFT, exactly as it is on disk, because that is how a
%   person reads: the first thing you want to see is the thing itself. The
%   parsed data is on the RIGHT, because that is what you have to judge.
%
%   The right pane has two tables. The upper one has one row per column of the
%   file and three editable entries:
%     Name             the name to call the channel, and the suffix to use later
%     Treat as Data    tick the columns to bring in; the time column is not one
%     Treat as time    tick the one column that is the time vector
%   The lower one is the file as it was parsed, every column of it, with the
%   columns that will be imported shaded and the time column shaded differently,
%   so the two tables can be compared line for line and column for column.
%
%   Import is unavailable while the settings could not produce any data: while
%   the file cannot be read at all, while nothing in it reads as a number, and
%   while no column is ticked. Those are the three cases in which the import
%   itself would return nothing, so the button is greyed rather than left to
%   fail after the fact.
%
%   Nothing is stale. Changing the delimiter, the header row count or the
%   decimal mark re-reads the file and rebuilds both tables, so the preview
%   always shows what the current settings actually produce. If a setting
%   cannot be read at all, the last good reading stays and the reason is put
%   in the warning box. A name the user typed survives every re-read; a name
%   that was only detected does not, because the fresh reading knows better.
%
%   Names come from the header row when it has one entry per column, and are
%   called col1, col2, ... otherwise.
%
%   How this file is put together
%   ----------------------------
%   Everything below the layout is a NESTED function, so all of it shares the
%   one LAYOUT and can reach every control by name. There is deliberately no
%   second copy of the layout to reconcile against: LAYOUT is both the dialog's
%   working state and its output, and what the dialog hands back is what it was
%   working with all along. The shared pieces are LAYOUT itself, NAMEDITED,
%   LASTREADNOTE and RAWTEXT, and nothing else.
%
%   The re-read builds a CANDIDATE and only commits it to LAYOUT once it has
%   succeeded, so a setting that cannot be read leaves the last good reading on
%   screen instead of a half-updated one.
%
%   Non-modal, for tests
%   --------------------
%   'NonModal', true returns the figure as the third output and does not
%   wait, so a test can drive the real controls and fire their callbacks with
%   no timer and no modal loop. 'OnAccept', f calls f with the edited layout
%   just before the figure closes, which is the only chance to get it out.
%
%   ACCEPTED and LAYOUT cannot report anything in 'NonModal' mode: the
%   function has returned by the time the buttons are pressed, so both come
%   back as they were when it did. That mode is for driving the dialog, and
%   'OnAccept' is how a caller learns what was accepted.
%
%   See also READTABULARFILE, DETECTLAYOUT, READMATRIX, FILEHEAD.
% The fourth argument is the figure the import was started from. It is no
% longer used: DIALOGPOSITION decides the size and the place from the SCREEN,
% so the window is the same whichever application started the import. Sizing to
% the parent made a narrow application window quietly give the parsed pane half
% the room, and ten channels stopped fitting for a reason the user could neither
% see nor change.


options = parseDialogOptions(varargin);
accepted = false;

% How much of the file to show, and how much of the data. Both are capped so
% a huge export cannot lock the dialog up.
MAX_TEXT_LINES = 300;
% How many data rows the preview carries. Every pane - the raw lines, the sheet
% table and the parsed table - shows this many rows below the header, so all
% three describe the same range of the file and the numbers in one can be found
% in the others.
%
% It is deliberately more rows than the window can show: the dialog is already
% as tall as the screen allows, so extra rows are there to be scrolled to, not
% to be visible at once. A preview that stops at what fits showed a 20 row file
% as a wall of data with no way to see what was below it.
MAX_DATA_ROWS = 100;
% The parsed pane's column widths are not set here. CHANNELWIDTHS gives the
% leading column '1x' and every channel column 'fit', which is one decision and
% no arithmetic: a column as wide as what it holds, and one that is never the
% reason a scrollbar appears. Earlier there were two constants here, a floor of
% 52 px and a leading width of 44 px, for a scheme that computed pixel widths
% per channel; they went when it did, because a leftover constant is an
% invitation to change a number that no longer has a user.

% The shading of the lower table. An imported channel and the time column have
% to be told apart at a glance, and a column that is neither is left unshaded so
% that "will not be imported" looks like what it is.
IMPORT_FILL = [0.87 0.94 0.87];
TIME_FILL   = [0.85 0.90 1.00];
% A filled cell holds a value nobody measured, so it is amber rather than the
% green of a column that will be imported whole. A row that will be dropped is
% red, across every column including the line number, because the whole row is
% going.
FILLED_FILL = [1.00 0.90 0.70];
DROPPED_FILL = [1.00 0.80 0.80];

% ---- the shared state, and the only shared state there is --------------------

layout.selectedColumns = 1:numel(layout.columnNames);
if ~isfield(layout, 'timeColumn')
    layout.timeColumn = [];
end

% Which names are the user's own rather than detected ones. This has to be
% remembered as a separate answer instead of worked out by comparing against
% the names the file was opened with: a name typed here is otherwise put back
% by the next re-read, because the settings table is rebuilt from the layout
% and the layout only ever heard about names it had detected itself. Comparing
% the two also cannot tell a deliberate rename to a name the file already used
% from no rename at all.
nameEdited = false(1, numel(layout.columnNames));

% Why the last re-read failed, so the button and the warning box can both be
% brought up to date from onColumnEdited as well as from refreshViews.
lastReadNote = '';

% The head of the file as shown on the left. Held rather than recomputed: the
% warning text needs it, and reading it again for that put a second full read
% of the file inside what looked like a pure formatting call.
rawText = {};

% What to do about a cell that holds no number, for the PREVIEW. It is applied
% to the numbers the pane shows and never to what the import returns: the fill
% itself happens in READTABULARFILE, over the whole file, through the same
% FILLBLANKS. Keeping it to the display is what stops the pane from quietly
% becoming the result.
blanksMethod = blanksFromOptions(options);

% Which cells of the right pane were filled, and which rows are about to be
% dropped, so the two can be marked. Held rather than recomputed at style time.
filledCells = zeros(0, 2);
doomedRows = zeros(1, 0);

% What the chosen policy did to the rows on show. Shared so the warning pane
% can say so: the numbers that matter for the FILE are in INFO.blanks once the
% import has happened, and these are the same facts about the PREVIEW.
previewReport = [];

% Take the first reading before the window exists, so the layout is complete by
% the time the controls are wired up. refreshViews cannot run yet: it reads the
% dropdowns, which have not been created.
try
    % No parent: the dialog has not been built yet, so the progress window has
    % to be a window of its own. This is the first analysis of the file and
    % the only feedback there is before the window appears.
    [layout.preview, layout.previewInfo] = tabularImport.withProgress( ...
        @() tabularImport.readMatrix( ...
        layout.filePath, layout, MAX_DATA_ROWS, ...
        max(layout.headerLines, MAX_DATA_ROWS)), [], "Reading the file");
catch
    layout.preview = preview;
    layout.previewInfo = previewInfo;
end
rawText = readFileHead(layout.headerLines + MAX_DATA_ROWS);

% ----------------------------------------------------------------- the window

fig = uifigure('Name', 'Import tabular data', ...
    'Position', dialogPosition(), ...
    'CloseRequestFcn', @cancelDialog, 'Visible', 'off');

grid = uigridlayout(fig, [5, 1]);
grid.Padding = [12 12 12 12];
grid.RowSpacing = 8;
% Explicit pixel heights, on purpose. Two adjacent 'fit' rows are merged into
% one by uigridlayout, so a RowHeight like {'fit','fit','1x',...} comes back
% shorter than the grid has rows; every child after the merged pair is then
% placed in the wrong row, the slack is never handed out, and the preview
% collapses to its bare minimum.
infoHeight    = 24;
controlsHeight = 50;
warningHeight  = 58;
buttonHeight   = 34;
settingsHeight = 132;
grid.RowHeight = {infoHeight, controlsHeight, '1x', warningHeight, buttonHeight};

fileName = char(java.io.File(char(layout.filePath)).getName());

% --- the line that says what is currently proposed
infoText = uilabel(grid, 'FontSize', 13, 'FontWeight', 'bold');
% The text is left empty on purpose: it has to describe the delimiter and the
% header row count, and both of those live in controls that are not built yet.
% Naming one of them here raised "Unrecognized function or variable" and took
% the whole dialog with it. refreshViews runs once every control exists and
% fills this in, so the window is never shown without its header.
infoText.Text = '';

% --- delimiter, skip rows, skip cols, decimal mark, blanks, orientation, sheet
% Six label/control pairs, plus a seventh for the worksheet selector when there
% is more than one. Counted rather than fixed, because a grid of the wrong width
% does not complain: this said nine columns with ten widths for several days and
% simply squeezed the last control into nothing.
hasSheetChoice = layout.isSpreadsheet && numel(layout.sheetNames) > 1;
controls = uigridlayout(grid, [1, 2 * (6 + double(hasSheetChoice))]);
controls.ColumnWidth = repmat({'1x', 'fit'}, 1, 6 + double(hasSheetChoice));
controls.Padding = [0 0 0 0];

uilabel(controls, 'Text', 'Delimiter:', 'HorizontalAlignment', 'right');
delimiterCandidates = {',', ';', sprintf('\t'), '|', ' '};
delimiterDropDown = uidropdown(controls, ...
    'Items', {'comma ,', 'semicolon ;', 'tab', 'pipe |', 'space', 'none'}, ...
    'ItemsData', [delimiterCandidates, {''}], ...
    'Value', delimiterValue(layout.delimiter));
delimiterDropDown.Tag = 'tabularImport.delimiter';

uilabel(controls, 'Text', 'Skip rows:', 'HorizontalAlignment', 'right','WordWrap','on');
headerSpinner = uispinner(controls, 'Limits', [0 Inf], 'Step', 1, ...
    'Value', layout.headerLines);
headerSpinner.Tag = 'tabularImport.headerRows';

% The columns at the left that are not data. Its job depends on which way the
% samples run: in a HORIZONTAL file this is the name column, and a file may
% have more than one, so this is the control that can say so. In a VERTICAL
% file it is usually zero and is there for the text label column the reader
% would otherwise drop in silence - which is why it is shown either way rather
% than only when the orientation needs it. Two controls that are both useful is
% a better answer than one control that changes its meaning.
uilabel(controls, 'Text', 'Skip cols:', 'HorizontalAlignment', 'right','WordWrap','on');
nameColsSpinner = uispinner(controls, 'Limits', [0 8], 'Step', 1, ...
    'Value', columnCountOf(layout, 'nameColumns'));
nameColsSpinner.Tag = 'tabularImport.nameColumns';

uilabel(controls, 'Text', 'Decimal:', 'HorizontalAlignment', 'right');
if layout.convention.needsRepair
    decimalStart = '.';
    if strcmp(layout.convention.decimalSeparator, ',')
        decimalStart = ',';
    end
else
    decimalStart = 'auto';
end
decimalDropDown = uidropdown(controls, ...
    'Items', {'auto', 'point .', 'comma ,'}, ...
    'ItemsData', {'auto', '.', ','}, ...
    'Value', decimalStart);
decimalDropDown.Tag = 'tabularImport.decimal';

% What to do about a cell that holds no number. Placed beside the decimal mark
% because the two are the same kind of question - "how do I read this file" -
% and a third row of controls would be a lot more height than the question is
% worth.
%
% 'keep' is NOT offered here, though FILLBLANKS still supports it and
% 'Blanks','keep' still works for a caller who asks for it in code. It is off the
% menu because it is the one method that hands back a matrix with holes in it,
% and a hole in the data is not something a recording should arrive with: every
% method on show either fills the gap or removes the sample that cannot be
% filled, so the import always comes back with numbers throughout. A caller who
% wants the holes kept is usually a program that will check for them itself.
%
% 'linear' is first and is the default, as the one that invents nothing: it puts
% a straight line between the two measured values on either side of the gap.
blanksItems = {'linear', 'drop', 'previous', 'next', 'nearest', ...
    'spline', 'pchip', 'makima'};
blanksLabels = {'linear', 'drop the row', 'previous', 'next', 'nearest', ...
    'spline', 'pchip', 'makima'};
uilabel(controls, 'Text', 'Blanks:', 'HorizontalAlignment', 'right');
blanksDropDown = uidropdown(controls, ...
    'Items', blanksLabels, 'ItemsData', blanksItems, ...
    'Value', blanksMethod);
blanksDropDown.Tag = 'tabularImport.blanks';

uilabel(controls, 'Text', 'Sheet:','HorizontalAlignment','right');
% Samples along the rows or across the columns. The values are chosen from
    % what the file was found to be rather than from a fixed list, so the
    % dropdown shows the DETECTED orientation and the user is correcting a guess
    % rather than picking a setting. Two items either way, so a layout built by
    % hand with an orientation this version does not know still has something
    % to correct it with.
    orientations = {'Samples go down the rows', 'Samples go across the columns'};
    current = 'Samples go down the rows';
    if isfield(layout, 'orientation') && strcmp(layout.orientation, 'horizontal')
        current = orientations{2};
    end
    orientationDropDown = uidropdown(controls, 'Items', orientations, ...
        'Value', current);
    orientationDropDown.Tag = 'tabularImport.orientation';

    if layout.isSpreadsheet && numel(layout.sheetNames) > 1
        sheetDropDown = uidropdown(controls, ...
            'Items', cellstr(layout.sheetNames), 'Value', layout.sheet);
    else
        sheetDropDown = uilabel(controls, 'Text', '');
    end
% Tagged like every other control here. It had no tag at all, which meant no
% test could reach it and the sheet-change path was never covered - the one
% path that is slowest of all, because it re-reads the workbook.
sheetDropDown.Tag = 'tabularImport.sheet';

% --- the two panes
% The two halves of the window share ONE grid rather than each having a grid of
% its own, and sharing is what makes them line up. Two independent grids have to
% be measured against each other and re-tuned whenever a font, a padding or a
% row height changes; here the left pane's height follows from the same rows the
% right pane uses, so it cannot drift away from it.
%
% The four rows are exactly what the right half needs. The left hand control
% spans rows 2 to 4, so it begins level with the columns table and finishes
% level with the parsed data table - which makes it as tall as those two tables
% put together, plus the band where the right half says "As parsed".
panes = uigridlayout(grid, [4, 2]);
panes.ColumnWidth = {'1x', '1x'};
panes.Padding = [0 0 0 0];
panes.RowSpacing = 0;
panes.RowHeight = {'fit', settingsHeight, 'fit', '1x'};

% --- column 1: the file, exactly as it is on disk
leftCaption = uilabel(panes, 'Text', 'In the file (first 100 rows)', 'FontWeight', 'bold');
rawTextArea = uitextarea(panes, 'Editable', 'off', 'WordWrap', 'off');
rawTextArea.Tag = 'tabularImport.text';
rawTextArea.FontName = get(0, 'FixedWidthFont');
rawTextArea.FontSize = 10;

% A spreadsheet cannot be shown the way a text file is. FILEHEAD reads bytes
% and cuts them at line breaks, and XLSX is a ZIP container, so it returned
% zip headers and XML fragments - the "weird mixture" this pane replaces. The
% used range of the sheet goes in as a table instead.
%
% Both controls want the same cells and one of them is hidden, rather than the
% control being swapped: a child of a UIGRIDLAYOUT set Visible off is dropped
% from the layout and the other takes its space.
sheetTable = uitable(panes, 'ColumnEditable', false, 'RowName', []);
sheetTable.Tag = 'tabularImport.sheetPreview';
if isprop(sheetTable, 'RowStriping')
    sheetTable.RowStriping = 'on';
end

% Every child is placed explicitly rather than left to the order the code
% happens to create them in, because two of them claim the same three cells of
% column 1 and only one is ever visible.
leftCaption.Layout.Row = 1;
leftCaption.Layout.Column = 1;
rawTextArea.Layout.Row = [2 4];
rawTextArea.Layout.Column = 1;
sheetTable.Layout.Row = [2 4];
sheetTable.Layout.Column = 1;
if layout.isSpreadsheet
    rawTextArea.Visible = 'off';
    leftCaption.Text = 'In the sheet (first 100 rows)';
else
    sheetTable.Visible = 'off';
end

% --- column 2: what was made of it
columnsLabel = uilabel(panes, 'Text', 'Columns', 'FontWeight', 'bold');
% The name comes FIRST, because that is the one entry in this table a person
% actually types, and it reads as the subject of the row with the two ticks
% beside it. "Import / Name / Time" put the thing being typed between two
% checkboxes, which made the name look like the label of the tick to its left.
settingsTable = uitable(panes, ...
    'ColumnName', {'Name (click to edit)', 'Treat as Data', 'Treat as time'}, ...
    'ColumnWidth', {'1x', 115, 115}, ...
    'ColumnEditable', [true true true], ...
    'ColumnFormat', {'char', 'logical', 'logical'});
settingsTable.Tag = 'tabularImport.columns';
if isprop(settingsTable, 'RowStriping')
    settingsTable.RowStriping = 'on';
end

parsedLabel = uilabel(panes, 'Text', 'As parsed', 'FontWeight', 'bold');
dataTable = uitable(panes, ...
    'ColumnName', {'row #'}, ...
    'ColumnEditable', false(1, 1), 'RowName', []);
dataTable.Tag = 'tabularImport.data';

columnsLabel.Layout.Row = 1;
columnsLabel.Layout.Column = 2;
settingsTable.Layout.Row = 2;
settingsTable.Layout.Column = 2;
parsedLabel.Layout.Row = 3;
parsedLabel.Layout.Column = 2;
dataTable.Layout.Row = 4;
dataTable.Layout.Column = 2;
if isprop(dataTable, 'RowStriping')
    % OFF here, unlike on the table above: the striping and the column shading
    % are two competing ways of saying the same thing, and where both are on it
    % is not clear which one the eye is meant to read.
    dataTable.RowStriping = 'off';
end

% --- warnings
warningsTextField = uitextarea(grid, 'Editable', 'off', 'Value', {''});
warningsTextField.FontColor = [0.45 0.30 0.00];
warningsTextField.Tag = 'tabularImport.warnings';

% --- buttons
buttons = uigridlayout(grid, [1, 3]);
buttons.ColumnWidth = {'1x', 110, 110};
buttons.Padding = [0 0 0 0];
uilabel(buttons, 'Text', '');
% the tags are the stable way to reach these controls, so the app and the
% tests never have to depend on the order the children happen to be built in
cancelButton = uibutton(buttons, 'Text', 'Cancel', ...
    'ButtonPushedFcn', @cancelDialog);
cancelButton.Tag = 'tabularImport.cancel';

importButton = uibutton(buttons, 'Text', 'Import', ...
    'ButtonPushedFcn', @acceptDialog);
importButton.Tag = 'tabularImport.import';
importButton.FontWeight = 'bold';

% Every control exists now, so the callbacks can reach all of them.
refreshViews();
delimiterDropDown.ValueChangedFcn = @refreshViews;
headerSpinner.ValueChangedFcn  = @refreshViews;
nameColsSpinner.ValueChangedFcn = @refreshViews;
decimalDropDown.ValueChangedFcn   = @refreshViews;
blanksDropDown.ValueChangedFcn   = @refreshViews;
orientationDropDown.ValueChangedFcn = @refreshViews;
if isgraphics(sheetDropDown) && isprop(sheetDropDown, 'Items')
    sheetDropDown.ValueChangedFcn  = @refreshViews;
end
settingsTable.CellEditCallback   = @onColumnEdited;

% Shown only now, once there is a whole dialog behind it. UIFIGURE is visible
% from the moment it is created, so before this the window appeared while it
% was still being built: it had no rows in either table for a moment, and a
% caller driving the dialog from a timer could act on it - close it, say -
% part way through this file, leaving the rest of the construction writing to
% a figure that no longer existed.
fig.Visible = 'on';

if options.NonModal
    % The caller drives the figure and closes it. No wait, no timer.
    return;
end

waitfor(fig);
if isvalid(fig)
    delete(fig);
end

% =============================================================================
% Nested functions. All of them share LAYOUT and every control above, which is
% why none of them takes a parameter for any of it.
% =============================================================================


    function refreshViews(~, ~)
    %REFRESHVIEWS  Take the settings off the controls, re-read, and repaint.
        candidate = layout;
        candidate.delimiter = char(delimiterDropDown.Value);
        candidate.headerLines = headerSpinner.Value;
        candidate.nameColumns = nameColsSpinner.Value;
        if isgraphics(sheetDropDown) && isprop(sheetDropDown, 'Items')
            candidate.sheet = char(sheetDropDown.Value);
        end
    % Read off the dropdown rather than carried through from LAYOUT, for the
    % same reason as the blank policy: this is a DISPLAY choice until the import
    % happens. It changes the SHAPE of the result, so it is the one setting the
    % dialog says plainly what it did.
    candidate.orientation = orientationValue(orientationDropDown.Value);
        candidate.convention = resolveConvention(decimalDropDown.Value);

          % Taken straight off the control rather than off CANDIDATE, which
          % comes from LAYOUT: the blank policy is a DISPLAY choice until the
          % import happens, so it has no business being carried through a
          % re-read like the delimiter is.
          blanksMethod = char(blanksDropDown.Value);

        % Re-read with the candidate settings so nothing on screen is stale.
        % A combination that cannot be read leaves the last good reading in
        % place, and says so, rather than blanking the window - which is why
        % LAYOUT is only written once the read has actually succeeded.
        % MATLAB's try/catch has no ELSE clause, so success is a flag rather
        % than a branch of the try itself.
        readOk = false;
        try
            % The progress window goes up for EVERY re-read, whichever
            % control asked for it. A small text file re-reads in well under a
            % frame and the window never really appears; a workbook takes
            % seconds, and that is the case it exists for.
            [candidate.preview, candidate.previewInfo] = ...
                tabularImport.withProgress(@() ...
                tabularImport.readMatrix(candidate.filePath, candidate, ...
                MAX_DATA_ROWS, max(candidate.headerLines, MAX_DATA_ROWS)), ...
                fig, "Reading the file");
            readOk = true;
        catch ME
            lastReadNote = sprintf('these settings cannot be read: %s', ...
                ME.message);
        end
        if readOk
            % The names are not part of the read, they are part of the LAYOUT,
            % and the layout being edited still holds the names detected for
            % the settings as they were when the dialog opened. So moving the
            % header row count shifted the data and left every name exactly
            % where it was, and the one control whose whole job is "read the
            % names from a different row" looked like it did nothing. They come
            % from PREVIEWINFO, which READMATRIX has just filled in for exactly
            % these settings; asking DETECTLAYOUT again would have gone back to
            % sniffing the file and returned the header rows it finds on its
            % own - the very thing the user just overrode.
            names = {};
            if isfield(candidate, 'previewInfo') && ...
                    isfield(candidate.previewInfo, 'headerNames')
                names = candidate.previewInfo.headerNames;
            end
            if ~isempty(names)
                candidate.columnNames = names;
                candidate.numColumns = numel(names);
            end
            layout = reconcileColumns(layout, candidate);
            lastReadNote = '';
        end

        % The left pane follows the header row count even when the read failed,
        % because it is only the first lines of the file and that is still what
        % the user is looking at.
        rawText = readFileHead(candidate.headerLines + MAX_DATA_ROWS);

        % A PANE that cannot be drawn must not stop the import. Everything the
        % user has chosen is readable and applied either way; only the picture
        % is missing, and saying so in the pane is more useful than an
        % exception that takes the whole dialog with it.
        %   This is not a repair of one bug. A spreadsheet preview hands a
        %   UITABLE whatever READCELL returned - MISSING, DATETIME, a nested
        %   cell - and the table accepts a fixed set of types, so every one of
        %   those is a way for an import to die on its opening screen. The
        %   cells are normalised further down SHEETPREVIEW; this is the belt
        %   to that braces, so the next type nobody thought of is a note in a
        %   pane instead of a crash.
        try
            updateLeftPane();
        catch ME
            sheetTable.Visible = 'off';
            rawTextArea.Visible = 'on';
            rawTextArea.Value = {sprintf('the sheet could not be previewed: %s', ...
                ME.message)};
            leftCaption.Text = 'In the sheet';
        end

        settingsTable.Data = fillSettingsTable();
        try
            updateDataTable();
        catch ME
            lastReadNote = sprintf('the parsed data could not be drawn: %s', ...
                ME.message);
        end
        updateImportState();

        if isempty(layout.delimiter)
            where = 'no field delimiter';
        elseif layout.delimiter == sprintf('\t')
            where = 'tab separated';
        else
            where = sprintf('"%s" separated', layout.delimiter);
        end
        infoText.Text = sprintf(['%s  -  %s, %d column(s), %d header row(s), ' ...
            '%d channel(s) selected'], fileName, where, layout.numColumns, ...
            layout.headerLines, numel(channelsToImport()));
    end


    function updateImportState()
    %UPDATEIMPORTSTATE  Grey the Import button while the import would be empty,
    %   and say why in the warning box. Separate from REFRESHVIEWS because
    %   ONCOLUMNEDITED needs it without re-reading the file underneath a name
    %   that is still being typed.
        blocked = whyImportBlocked();
        if isempty(blocked)
            importButton.Enable = 'on';
        else
            importButton.Enable = 'off';
        end
        warningsTextField.Value = {warningLines(blocked)};
    end


    function onColumnEdited(~, event)
        rows = settingsTable.Data;
        row = event.Indices(1);
        column = event.Indices(2);
        if column == 3
            if logical(rows{row, 3})
                % one time column at a time, and a time column is not a channel
                rows(:, 3) = {false};
                rows{row, 3} = true;
                rows{row, 2} = false;
                settingsTable.Data = rows;
                layout.timeColumn = row;
            else
                % Clearing the tick has to clear the LAYOUT as well. Without
                % this the tick sprang straight back: the settings table is
                % rebuilt from the layout further down, and it reads the time
                % column off the one that was never updated, so it re-ticked
                % the very box that had just been cleared. The layout that came
                % back then still named a time column, so READTABULARFILE
                % never reached ASKSAMPLERATE and there was no question to ask.
                %
                % The column is deliberately left OUT of the import rather than
                % becoming an ordinary channel. Un-ticking "Treat as time" says
                % "this is not a time vector", and it does not say "and now it
                % is a signal": the column was excluded from the channels when
                % it became the time vector, and it stays excluded. To bring it
                % in as a channel, tick "Treat as Data" on it as well - which
                % is what the other box is for.
                layout.timeColumn = [];
            end
        elseif column == 2 && logical(rows{row, 2})
            % Ticking a channel by hand clears the time tick on it. The layout
            % has to forget it as well, not just the table: the shading is drawn
            % from the layout, so a column that stopped being the time column
            % kept its time colour, and because that style is added last it sat
            % on top of the imported one - the column stayed blue and looked
            % like nothing had changed at all.
            rows{row, 3} = false;
            settingsTable.Data = rows;
            if ~isempty(layout.timeColumn) && layout.timeColumn == row
                layout.timeColumn = [];
            end
        elseif column == 1
            % A typed name goes into the LAYOUT there and then. It used to stay
            % in the table only, and the table is rebuilt from the layout on
            % every re-read, so the next change of delimiter, header row count
            % or decimal mark put the detected name back and the typing was
            % lost.
            typed = strtrim(char(rows{row, 1}));
            if isempty(typed)
                typed = sprintf('col%d', row);
            end
            % Brace indexing grows the cell, so a row past the end of the
            % current names needs no special case
            layout.columnNames{row} = typed;
            if row > numel(nameEdited)
                nameEdited(end+1:row) = false;
            end
            nameEdited(row) = true;
            % Only the header of the lower table moves: a full refresh would
            % re-read the file underneath a name that is still being typed.
            updateDataTable();
            return;
        end
        layout.selectedColumns = find(tickedValues(rows(:, 2)));
        updateImportState();
        updateDataTable();
    end


    function updateDataTable()
    %UPDATEDATATABLE  Repaint the lower table: the numbers, their names, the
    %   file line each row came from, and the shading.
    %
    %   Every column of the file is shown, not only the imported ones, because
    %   the whole point of the shading is to show which columns the ticks
    %   select: a table that left the unticked columns out would hide them
    %   instead of marking them, and there would be nothing for the time column
    %   to be a different colour from.
    %
    %   The leading column is the line of the FILE each row came from, not its
    %   position in the table. With a header row count of H the first row shown
    %   is line H+1, so the numbers line up with the file pane beside it;
    %   counting from 1 again put 1..6 in front of lines 196..201 and the two
    %   panes could not be compared without counting the header rows by hand.
        keep = 1:max(layout.numColumns, numel(layout.columnNames));
        if ~isempty(layout.preview)
            keep = keep(keep <= size(layout.preview, 2));
        end

        if isempty(layout.preview) || isempty(keep)
            dataTable.Data = cell(0, 1);
            dataTable.ColumnName = {'row #'};
            removeStyle(dataTable);
            return;
        end

        nRows = min(size(layout.preview, 1), MAX_DATA_ROWS);
        keep = keep(keep >= 1 & keep <= size(layout.preview, 2));
        shown = layout.preview(1:nRows, keep);
        original = shown;

        % The blank policy is applied HERE, to what the pane shows, and never
        % to what the import returns. The fill itself happens in
        % READTABULARFILE over the whole file, through this same FILLBLANKS, so
        % the two cannot disagree about a number - but the pane holding filled
        % values is a display, not a result.
        %
        % The time axis comes from the LAYOUT rather than from the shown columns,
        % because a row about to be dropped has to lose its time too or the two
        % halves of the pane would describe different rows.
        previewTime = [];
        if ~isempty(layout.timeColumn) && layout.timeColumn >= 1 && ...
                layout.timeColumn <= size(layout.preview, 2)
            % Cut to the rows ON SHOW, not to all of them. The pane is holding
            % the first NROWS samples and a time vector for all 199 of them is a
            % different length from the data beside it - which is harmless as
            % long as the policy only ever looked at it, and stops being
            % harmless the moment something checks that the two agree. The
            % previous version of this took the whole axis and silently ignored
            % the difference, so a row about to be dropped could have been judged
            % against the time of a row nobody is looking at.
            previewTime = layout.preview(1:nRows, layout.timeColumn);
        end

        % NO time axis is passed in here, and that is deliberate. FILLBLANKS
        % removes the rows whose time is missing, and a table that removed them
        % would have nothing left to MARK: the whole point of showing the
        % effect is that the rows about to go are still there, in red. Which
        % rows those are is worked out separately below, by the same rule.
        [shown, ~, previewReport] = tabularImport.fillBlanks(shown, [], ...
            blanksMethod);

        % Which cells were filled and which rows are going, so both can be
        % marked. Which rows, asked rather than inferred from the report's
        % counts, because a count says nothing about which.
        filledCells = zeros(0, 2);
        doomedRows = zeros(1, 0);
        if ~isempty(original)
            doomedRows = find(doomedByPolicy(original, previewTime, blanksMethod));
            % Which cells were filled, and what they were filled WITH.
            %
            % Under a fill method FILLBLANKS returns FEWER ROWS than it was
            % given, because the samples it cannot interpolate are removed - so
            % its rows and the pane's rows are no longer the same rows. Taking
            % them by position is what put an interpolated value under the
            % WRONG sample: the first row of the result is the fourth row of
            % the input, so marking row 1 of the pane as filled really marked
            % row 4, and the ramp's leading hole was reported as filled when it
            % had been dropped.
            %
            % ROWINDEX is the map back, and FILLBLANKS returns it precisely so
            % that a caller marking its own rows cannot get this wrong.
            filledValues = original;
            if ~strcmp(blanksMethod, 'drop')
                [probe, ~, ~, keepRows] = tabularImport.fillBlanks( ...
                    original, [], blanksMethod);
                survivor = find(keepRows);
                rowInProbe = zeros(size(original, 1), 1);
                rowInProbe(survivor) = 1:numel(survivor);
                wasBlank = ~isfinite(original);
                % Only cells that were holes AND whose row survived AND that
                % now hold a number count as filled. Anything else is a hole the
                % policy declined to fill, which the red marking is about.
                mark = false(size(original));
                kept = find(rowInProbe > 0);
                if ~isempty(kept)
                    mark(kept, :) = wasBlank(kept, :) ...
                        & isfinite(probe(rowInProbe(kept), :));
                end
                [filledRow, filledColumn] = find(mark);
                filledCells = [filledRow, filledColumn];
                for k = 1:size(filledCells, 1)
                    r = filledCells(k, 1);
                    c = filledCells(k, 2);
                    filledValues(r, c) = probe(rowInProbe(r), c);
                end
            end

            % What the pane SHOWS is the original grid with only the genuinely
            % filled values written into it, never the return value of
            % FILLBLANKS: that has had rows taken out of it, and the pane has to
            % keep showing them - a sample that is about to be discarded is
            % exactly the one the user needs to look at, and the red marking
            % says so.
            shown = filledValues;
        end

        data = cell(nRows, numel(keep) + 1);
        % What the leading column is, which depends on which way the samples run.
        %
        % For a VERTICAL file it is the line of the FILE each sample came from,
        % which is what puts the two panes in step: with a header count of H the
        % first sample shown is line H+1, so the numbers line up with the lines
        % in the pane beside it.
        %
        % For a HORIZONTAL file it cannot be a line at all. The samples are
        % across the columns, so a sample has no line - it has a COLUMN - and
        % printing a line number there numbered 24 rows of samples against a
        % six line file, none of which was the one on show. A column of the file
        % is the honest label, and for a WORKSHEET it is shown as the letter the
        % sheet preview on the left uses, so the two panes can be read against
        % each other by name.
        fileLabels = filePositionLabels(nRows, layout);
        for r = 1:nRows
            % No braces around the label: FILEPOSITIONLABELS hands back cells,
            % and wrapping one puts a cell inside a cell, which is the thing
            % UITABLE refuses with "values within a cell array must be numeric,
            % logical, or char".
            data(r, 1) = fileLabels(r);
            for c = 1:numel(keep)
                % Parens, not braces: assigning a cell THROUGH a brace index
                % nests that cell inside the cell, so every value in this table
                % arrived as a 1x1 cell and uitable refused the whole table
                % with "values within a cell array must be numeric, logical,
                % or char". A paren index is what unwraps a one element cell
                % onto the right cell.
                data(r, c+1) = {shown(r, c)};
            end
        end
        dataTable.Data = data;

        names = layout.columnNames(:).';
        if numel(names) < layout.numColumns
            names(end+1:layout.numColumns) = {'col'};
        end
        for c = 1:layout.numColumns
            if isempty(names{c})
                names{c} = sprintf('col%d', c);
            end
        end
        keep = keep(keep <= numel(names));
        dataTable.ColumnName = [{leadingColumnLabel(layout)}, names(keep)];
        dataTable.ColumnWidth = channelWidths(numel(names(keep)));

        % Only the columns that are actually IMPORTED are shaded, which is not
        % the same as the ones shown: the time column is shown, because a time
        % column you cannot see is one you cannot check, but it is not a
        % channel, so it gets its own colour and none of the other one.
        % Shading every shown column put the green over the blue as well.
        %
        % Every style is cleared first, because the ticks are edited one at a
        % time and a style applied to a cell that has since been unticked would
        % still be on it.
        removeStyle(dataTable);
        imported = cellIndices(channelsToImport(), nRows);
        if ~isempty(imported)
            addStyle(dataTable, uistyle('BackgroundColor', IMPORT_FILL), ...
                'cell', imported);
        end
        if isscalar(layout.timeColumn) && layout.timeColumn <= numel(names)
            addStyle(dataTable, uistyle('BackgroundColor', TIME_FILL), ...
                'cell', cellIndices(layout.timeColumn, nRows));
        end

        % Marked LAST, so it lands on top of the column colours above.
        % These two say something the column colours cannot: a filled cell holds
        % a value nobody measured, and a doomed row is not going to be imported
        % at all. Both are added as CELL styles, which UITABLE resolves over a
        % COLUMN style on the same cell.
        if ~isempty(doomedRows)
            % The second column is the COLUMN NUMBER, repeated down the rows -
            % ones(...) filled a block the width of the table instead, which
            % made this an N-by-(1+nCols) array and ADDSTYLE refused it with
            % "Option for 'cell' must be an N-by-2 matrix of positive integers".
            % A doomed row is marked right across, so it needs every column,
            % not one of them.
            doomedCells = wholeRowCells(doomedRows, size(dataTable.Data, 1), ...
                size(dataTable.Data, 2));
            if ~isempty(doomedCells)
                addStyle(dataTable, uistyle('BackgroundColor', DROPPED_FILL), ...
                    'cell', doomedCells);
            end
        end
        if ~isempty(filledCells)
            % Shifted one column right: column 1 of this table is the file line
            % number, which is never filled. A copy, because the shift must not
            % write back into the shared FILLEDCELLS - which is also what the
            % style was added from, so changing it twice would compound.
            amberCells = filledCells;
            amberCells(:, 2) = amberCells(:, 2) + 1;
            lastColumn = size(dataTable.Data, 2);
            amberCells = amberCells(amberCells(:, 1) <= size(dataTable.Data, 1) ...
                & amberCells(:, 2) <= lastColumn, :);
            if ~isempty(amberCells)
                addStyle(dataTable, uistyle('BackgroundColor', FILLED_FILL), ...
                    'cell', amberCells);
            end
        end
    end


    function pairs = wholeRowCells(rows, nTableRows, nTableColumns)
    %WHOLEROWCELLS  Every cell of the given table rows, as [row column] pairs.
    %   Built cell by cell rather than as [rows(:), repmat(1:nCols, n, 1)],
    %   which is wrong twice over and was wrong quietly. FIND on a column
    %   answers a ROW, so rows(:) is N x 1 and the other term is 1 x nCols -
    %   concatenating them gives 1 x (1+nCols), and ADDSTYLE rejects that with
    %   "Option for 'cell' must be an N-by-2 matrix of positive integers".
    %   With a single doomed row it happens to come out 1 x 3, which is wrong
    %   but at least the right KIND of wrong; with two rows the pieces do not
    %   even line up.
    rows = rows(:).';
    rows = rows(rows >= 1 & rows <= nTableRows);
    pairs = zeros(numel(rows) * nTableColumns, 2);
    at = 0;
    for r = rows
        for c = 1:nTableColumns
            at = at + 1;
            pairs(at, :) = [r, c];
        end
    end
    end


    function widths = channelWidths(nChannels)
%CHANNELWIDTHS  How wide each column of the parsed pane is.
%   The leading column gets '1x' and every channel column 'fit'.
%
%   FIT is sized to the content of its column, which is what a table full of
%   numbers wants: a channel holding "-0.0012345" needs more room than one
%   holding "3.5", and an equal share of the width would give both the same and
%   waste the space on the short one.
%
%   The LEADING column is told 'fit' and every channel column '1x', which is the
%   other way round from what this did before and is better: 'fit' gives the
%   line-number column exactly as much room as its digits need and no more,
%   while '1x' shares what is LEFT between the channels. Giving the leading
%   column a share of its own took a share away from every channel.
%
%   Returns a CELL, because UITABLE takes ColumnWidth as a cell of any mixture:
%   a plain numeric array is rejected outright with "ColumnWidth must be an
%   array containing 'fit', 'auto', positive numbers...".
widths = [{'fit'}, repmat({'1x'}, 1, nChannels)];
end


% =============================================================================
function label = leadingColumnLabel(layout)
%LEADINGCOLUMNLABEL  The heading of the pane's first column.
%   'row #' for a vertical file, whose first column holds the line of the file
%   each sample came from, and 'col #' for a horizontal one, whose holds the
%   column. Chosen by the layout rather than hard-coded in both places, so the
%   heading and the values under it cannot disagree about which they are.
if strcmp(layout.orientation, 'horizontal')
    label = 'col #';
else
    label = 'row #';
end
end


% =============================================================================
function labels = filePositionLabels(nRows, layout)
%FILEPOSITIONLABELS  What to print beside each row of the data pane.
%   The file position of the sample, which is a LINE for a vertical file and a
%   COLUMN for a horizontal one - see the comment where it is built.
%
%   The column numbering starts after the skipped ones, because those are where
%   the names are: sample one of demo_horizontal.csv is in column B, and
%   labelling it "1" would point at the name column instead.
skipped = columnCountOf(layout, 'nameColumns');
if ~strcmp(layout.orientation, 'horizontal')
    labels = num2cell(layout.headerLines + (1:nRows));
    return;
end
if isFieldTrue(layout, 'isSpreadsheet')
    % Letters, because that is what the sheet preview on the LEFT is using, and
    % a column labelled DP can be found there.
    %
    % Only in a workbook. In a text file the left pane shows LINES, so a letter
    % points at nothing at all - the user cannot look for 'D' anywhere in a row
    % of comma separated numbers. The number is the position along the line,
    % which is countable, so a number is the honest label there even though it
    % has to be counted by eye.
    letters = tabularImport.columnLetters(min(nRows + skipped, 16384));
    labels = letters(skipped + (1:nRows));
    return;
end
labels = num2cell(skipped + (1:nRows));
end


% =============================================================================
function value = columnCountOf(layout, field)
%COLUMNCOUNTOF  A count off the layout, or zero when the layout does not have it.
%   Every layout built by hand predates this field, and the dialog is called
%   with one in the tests, so reading it straight out would fail on the very
%   inputs most likely to be wrong. Zero is the right answer in every case:
%   skipping nothing is what an absent field means.
value = 0;
if isfield(layout, field) && ~isempty(layout.(field))
    value = layout.(field);
end
end


% =============================================================================
function tf = isFieldTrue(layout, field)
%ISFIELDTRUE  Whether a logical field of the layout is set.
%   FALSE for a layout that has no such field, which is the answer wanted: the
%   field is new and an older layout simply does not carry it.
tf = isfield(layout, field) && ~isempty(layout.(field)) && layout.(field);
end


% =============================================================================
function orientation = orientationValue(label)
    %ORIENTATIONVALUE  The layout orientation a dropdown label stands for.
    %   The label is what the user reads and the word is what the layout speaks,
    %   so the two are kept apart deliberately: rewording the control cannot
    %   silently change the meaning.
    %
    %   Anything unrecognised falls back to 'vertical'. That is the default and
    %   the safe direction, because this setting changes the SHAPE of the result
    %   rather than a name on it, and vertical is what every existing file means.
        label = lower(char(string(label)));
        if contains(label, 'across')
            orientation = 'horizontal';
        else
            orientation = 'vertical';
        end
    end


    function doomed = doomedByPolicy(shown, time, method)
    %DOOMEDBYPOLICY  The rows the blank policy will remove.
    %   This used to be a second, hand-written copy of the rule, which is the
    %   one arrangement guaranteed to drift: it knew only about 'drop' and about
    %   a missing time, so when FILLBLANKS learned to remove a sample whose gap
    %   runs off the end of a channel, the pane went on marking only the rows it
    %   had always marked and the import dropped the rest in silence.
    %
    %   It asks FILLBLANKS instead and reads back the KEEPROWS mask, so there is
    %   exactly one implementation of the policy. The count in REPORT would not
    %   do: the table has to be told WHICH rows, and a count says nothing about
    %   which.
    if isempty(shown)
        doomed = false(0, 1);
        return;
    end
    nRows = size(shown, 1);
    % A time axis shorter than the pane is not a reason to mark rows that were
    % never in question, so it is padded rather than rejected.
    if ~isempty(time) && numel(time) < nRows
        time(end+1:nRows, 1) = 0;
    end
    [~, ~, ~, keepRows] = tabularImport.fillBlanks(shown, time, char(method));
    doomed = ~keepRows;
end


    function acceptDialog(~, ~)
        applyEdits();
        accepted = true;
        if ~isempty(options.OnAccept)
            % The layout as it stands, which is what OnAccept is for: in
            % 'NonModal' mode this callback is the only way a caller ever
            % learns what was accepted, and it was being handed the state from
            % before the settings table was touched.
            options.OnAccept(layout);
        end
        closeFigure();
    end


    function cancelDialog(~, ~)
    %CANCELDIALOG  Closing the window IS the answer "no".
    %   This is kept apart from CLOSING the window because ACCEPTDIALOG closes
    %   it too and used to come through here: this set ACCEPTED back to false,
    %   so pressing Import reported a CANCELLATION. READTABULARFILE reads that
    %   as "the user pressed Cancel" and returns an empty result without ever
    %   asking for a sampling rate - the window was never in doubt, only the
    %   flag was.
        accepted = false;
        closeFigure();
    end


    function closeFigure()
        if isvalid(fig)
            delete(fig);
        end
    end


    function applyEdits()
    %APPLYEDITS  Read the settings table back into the layout, which is what
    %   the caller is handed once the figure closes. The table is the truth
    %   about what the user chose, so what it holds goes into the LAYOUT itself
    %   and not into a scratch copy: the accept callback above, and the values
    %   READTABULARFILE is handed after the figure closes, both come from here.
        rows = settingsTable.Data;
        names = rows(:, 1);
        for c = 1:numel(names)
            if isempty(names{c})
                names{c} = sprintf('col%d', c);
            end
        end
        layout.columnNames = names;
        layout.numColumns = numel(names);
        layout.selectedColumns = find(tickedValues(rows(:, 2)));
        % columnNames keeps one entry per column of the file so that
        % selectedColumns and timeColumn stay interpretable as indices into it
        hit = find(tickedValues(rows(:, 3)));
        if isempty(hit)
            layout.timeColumn = [];
        else
            layout.timeColumn = hit(1);
        end
        layout.delimiter = char(delimiterDropDown.Value);
        layout.headerLines = headerSpinner.Value;
        layout.convention = resolveConvention(decimalDropDown.Value);
    end


    function data = fillSettingsTable()
    %FILLSETTINGSTABLE  The Name / Treat as Data / Treat as time table, one
    %   row a column.
        n = layout.numColumns;
        names = layout.columnNames(:);
        if numel(names) < n
            names(end+1:n) = {'col'};
        end
        data = cell(max(n, 1), 3);
        for c = 1:n
            isTime = isscalar(layout.timeColumn) && (layout.timeColumn == c);
            isData = any(layout.selectedColumns == c);
            if isTime
                isData = false;
            end
            data(c, :) = {names{c}, isData, isTime};
        end
    end


    function keep = channelsToImport()
    %CHANNELSTOIMPORT  The columns that would come back as channels.
    %   The time column is one of them however it is ticked, because a time axis
    %   is not a channel: the importer takes the values and drops it from the
    %   channels.
        keep = layout.selectedColumns(:).';
        if ~isempty(layout.timeColumn)
            keep(keep == layout.timeColumn) = [];
        end
        keep = keep(keep >= 1);
        if ~isempty(layout.preview)
            keep = keep(keep <= size(layout.preview, 2));
        end
    end


    function reason = whyImportBlocked()
    %WHYIMPORTBLOCKED  Why the import would come back empty, as a sentence.
    %   Empty means there is nothing wrong. Each case names a way the import in
    %   READTABULARFILE ends in an empty result rather than in data: the read
    %   throws, or the file holds nothing that reads as a number, or no column is
    %   ticked. Greying the button is only worth anything if it matches those,
    %   and the reason goes into the warning box so the grey button is not just a
    %   button that refuses.
        reason = '';
        if ~isempty(lastReadNote)
            reason = 'these settings cannot be read, so the import cannot be made';
        elseif isempty(channelsToImport())
            reason = 'no column is ticked as data, so the import would bring in nothing';
        elseif isempty(layout.preview) || size(layout.preview, 2) < 1
            reason = 'the file holds no data columns, so the import would bring in nothing';
        elseif isfield(layout, 'previewInfo') && ...
                isfield(layout.previewInfo, 'allNaN') && layout.previewInfo.allNaN
            reason = ['nothing in this file reads as a number with the layout ' ...
                'above, so the import would bring in nothing'];
        elseif headerRowUnsplit()
            % Not empty, but wrong: the read succeeds and hands back numbers,
            % and every one of them comes back named col1, col2, ... because
            % the header row came through as a single field while the data rows
            % split. That is the delimiter, not the header.
            reason = ['the header row does not split while the data rows do, ' ...
                'which points at the delimiter rather than the header'];
        end
    end


    function [headerWidth, dataWidth, counts] = fieldCounts()
    %FIELDSCOUNTS  How many fields the last header row splits into, how many
    %   the data rows split into, and the count for every line shown.
    %   Those numbers answer three questions, and asking them as ONE test is
    %   what was wrong: a header row naming FEWER columns than the data has is
    %   ordinary - READMATRIX pre-fills col2, col3 and the table lets the user
    %   rename them - and refusing the import over it blocked files that were
    %   already reading correctly. Only the first question blocks:
    %     - the header did not split at all while the data did    BLOCKS
    %     - the header names some of the columns                  note
    %     - the header is wider than the data                     note
    %
    %   Only the LAST header row is asked about, because that is the one the
    %   names come from: a metadata block above it may legitimately be a
    %   different width from the data, and a file with one of those must still
    %   import.
        headerWidth = 0;
        dataWidth = 0;
        counts = zeros(1, numel(rawText));
        delimiter = char(layout.delimiter);
        if isempty(delimiter) || isempty(rawText)
            return;
        end
        for r = 1:numel(rawText)
            if isempty(strtrim(rawText{r}))
                continue;
            end
            counts(r) = numel(strsplit(rawText{r}, delimiter));
        end
        dataCounts = counts(layout.headerLines+1:end);
        dataCounts = dataCounts(dataCounts > 0);
        if isempty(dataCounts)
            return;
        end
        dataWidth = mode(dataCounts);
        if layout.headerLines < 1 || layout.headerLines > numel(counts)
            return;
        end
        headerWidth = counts(layout.headerLines);
    end


    function unsplit = headerRowUnsplit()
    %HEADERROWSPLIT  Did the header row fail to split while the data rows did?
    %   That is what a wrong delimiter looks like. The read still succeeds - a
    %   whole line is still one field, and the numbers inside it are still
    %   numbers - but the names in the table are then the invented col1, col2,
    %   ... and not the ones written in the file. Importing that would hand the
    %   user a single channel called col1 and call it a success, so the dialog
    %   withholds the button, not just notes the problem.
    %
    %   A header that DID split, however narrow, is left alone. Two names over
    %   four columns is a file with two names in it, and the other two are
    %   sitting in the table as col3 and col4 waiting to be renamed.
        [headerWidth, dataWidth] = fieldCounts();
        unsplit = dataWidth > 1 && headerWidth == 1;
    end


    function text = warningLines(blockedReason)
    %WARNINGLINES  Everything the user should know before confirming.
    %   The list is built in place rather than grown, because MATLAB will not let
    %   the analyzer see a fixed size when the count is only known at the end.
    %   It has to be big enough for every note below plus whatever the layout
    %   brought with it, and there is no upper bound on the layout's own list.
        notes = cell(1, 16);
        nNotes = 0;

        if ~isempty(blockedReason)
            nNotes = nNotes + 1;
            notes{nNotes} = sprintf('Import is unavailable, because %s', blockedReason);
        end
        if ~isempty(lastReadNote)
            nNotes = nNotes + 1;
            notes{nNotes} = lastReadNote;
        end
        if isfield(layout, 'warnings')
            % The settings notes are SKIPPED and built again below, from the
            % layout as it stands. DETECTLAYOUT wrote them once, when it first
            % looked at the file, and two of them name the sheet and the decimal
            % mark - both of which the dialog lets the user change. Copying them
            % through left the pane claiming a worksheet had been chosen after
            % the user had chosen a different one. The entries to skip are found
            % by the index DETECTLAYOUT recorded rather than by matching their
            % text, so the wording stays free to change.
            skip = zeros(1, numel(layout.warnings));
            if isfield(layout, 'settingNoteIndex') && ~isempty(layout.settingNoteIndex)
                skip(layout.settingNoteIndex) = true;
            end
            for n = 1:numel(layout.warnings)
                if skip(n)
                    continue;
                end
                nNotes = nNotes + 1;
                notes{nNotes} = char(layout.warnings{n});
            end
        end
        % Live, because the user can change what they say. Kept in the same place
        % in the list, after the notes about the file itself.
        live = tabularImport.settingNotes(layout);
        for n = 1:numel(live)
            nNotes = nNotes + 1;
            notes{nNotes} = char(live{n});
        end
        if isfield(layout.previewInfo, 'droppedLeadingRows') && ...
                layout.previewInfo.droppedLeadingRows > 0
            nNotes = nNotes + 1;
            notes{nNotes} = sprintf( ...
                '%d row(s) above the numeric data were discarded', ...
                layout.previewInfo.droppedLeadingRows);
        end
        if isfield(layout.previewInfo, 'trimmedColumns') && ...
                layout.previewInfo.trimmedColumns > 0
            nNotes = nNotes + 1;
            notes{nNotes} = sprintf('%d empty column(s) on the right were discarded', ...
                layout.previewInfo.trimmedColumns);
        end
        if isfield(layout.previewInfo, 'allNaN') && layout.previewInfo.allNaN
            nNotes = nNotes + 1;
            notes{nNotes} = ['nothing in this file reads as a number with the layout ' ...
                'above; compare the two panes and try another delimiter, a different ' ...
                'header row count, or a different decimal mark'];
        end
        if isempty(layout.timeColumn)
            nNotes = nNotes + 1;
            notes{nNotes} = ['no column is marked as the time vector, so a sampling ' ...
                'frequency will be asked for on import'];
        end

        % What the blank policy does to the rows on show. Every count here is
        % about the PREVIEW and is worded as such: the window holds
        % MAX_DATA_ROWS rows, while INFO.blanks counts the whole file once the
        % import has happened, and a note claiming a file-wide number it cannot
        % know would be worse than none.
        if ~isempty(previewReport)
            if ~isempty(doomedRows)
                nNotes = nNotes + 1;
                notes{nNotes} = sprintf( ...
                    '%d row(s) in the preview will be dropped rather than filled', ...
                    numel(doomedRows));
            end
            if previewReport.filled > 0
                nNotes = nNotes + 1;
                notes{nNotes} = sprintf( ...
                    ['%d cell(s) in the preview that hold no number are marked ' ...
                     'amber: %s will be put there on import'], ...
                    previewReport.filled, previewReport.method);
            end
        end

        % A ragged file is the classic import mistake and it is worth saying so,
        % but only for the data rows: a metadata or unit row may legitimately
        % have fewer fields than the data.
        if ~isempty(layout.delimiter)
            [headerWidth, dataWidth, counts] = fieldCounts();
            dataCounts = counts(layout.headerLines+1:end);
            dataCounts = dataCounts(dataCounts > 0);
            if numel(unique(dataCounts)) > 1
                nNotes = nNotes + 1;
                notes{nNotes} = sprintf( ...
                    'the data rows do not all split into the same number of fields (%s)', ...
                    strjoin(string(unique(dataCounts)), ', '));
            end
            if dataWidth > 1 && headerWidth == 1
                % The one that blocks. Worded to name the delimiter, because
                % that is what has to change.
                nNotes = nNotes + 1;
                notes{nNotes} = sprintf(['the header row splits into %d field(s) but ' ...
                    'the data rows into %d, so the names below are not the ones in ' ...
                    'the file'], headerWidth, dataWidth);
            elseif headerWidth >= 2 && headerWidth < dataWidth
                % Information, not a problem: the file simply does not name
                % every column, and the ones it leaves unnamed are already in
                % the table as col3, col4 and can be renamed there.
                nNotes = nNotes + 1;
                notes{nNotes} = sprintf(['the header row names %d of the %d columns; ' ...
                    'the rest are shown as col%d onwards and can be renamed here'], ...
                    headerWidth, dataWidth, headerWidth + 1);
            elseif dataWidth > 0 && headerWidth > dataWidth
                nNotes = nNotes + 1;
                notes{nNotes} = sprintf(['the header row splits into %d field(s) but ' ...
                    'the data rows into %d'], headerWidth, dataWidth);
            end
        end

        if strcmp(decimalDropDown.Value, 'auto') && layout.convention.needsRepair
            nNotes = nNotes + 1;
            notes{nNotes} = 'the decimal separator was detected, check the preview';
        end

        if nNotes == 0
            text = '';
        else
            text = strjoin(notes(1:nNotes), newline);
        end
    end


    function updateLeftPane()
    %UPDATELEFTPANE  Fill the left pane with whichever view the file calls for.
    %   A text file is shown as the lines the importer split, because that is
    %   what makes a wrong delimiter, a stray quote or a wrong decimal mark
    %   visible without opening the file somewhere else.
    %
    %   A spreadsheet cannot be shown that way and is not shown as text any
    %   more. It is a ZIP container, so reading its bytes gave zip headers and
    %   XML fragments; its used range goes into a table instead, labelled with
    %   the letters Excel uses for those columns and the row numbers of the
    %   sheet, so a row or a column can be pointed at on either side of the
    %   window.
        if ~layout.isSpreadsheet
            leftCaption.Text = 'In the file (first 100 rows)';
            sheetTable.Visible = 'off';
            rawTextArea.Visible = 'on';
            rawTextArea.Value = cellstr(rawText(:));
            return;
        end
        leftCaption.Text = 'In the sheet (first 100 rows)';
        rawTextArea.Visible = 'off';
        sheetTable.Visible = 'on';
        [data, truncated] = sheetPreview();
        if isempty(data)
            sheetTable.ColumnName = {'-'};
            sheetTable.RowName = {};
            sheetTable.Data = {''};
            return;
        end
        if truncated
            % Said rather than hidden: a preview that quietly stops short of
            % the data is how the earlier version of this pane managed to show
            % a hundred rows of which ninety were nothing.
            leftCaption.Text = sprintf( ...
                'In the sheet (first %d rows, first %d columns)', ...
                MAX_DATA_ROWS, size(data, 2));
        end
        % Letters and row numbers before the data, because UITABLE checks that
        % the column names are as many as the columns of Data.
        sheetTable.ColumnName = tabularImport.columnLetters(size(data, 2));
        sheetTable.RowName = arrayfun(@(n) sprintf('%d', n), 1:size(data, 1), ...
            'UniformOutput', false);
        sheetTable.Data = data;
    end


    function [data, truncated] = sheetPreview()
    %SHEETPREVIEW  The top of the sheet, as a cell array for the left pane.
    %   Rows 1 .. HEADERLINES + MAX_DATA_ROWS: the same span the right pane
    %   shows, so the two halves of the window describe the same rows.
    %
    %   TRUNCATED is true when the sheet is wider than the cap, so the caption
    %   can say so rather than quietly showing less than the sheet holds.
    %
    %   The read is bounded in BOTH directions, by a rectangle rather than a
    %   row select. A row select comes back the full width of the used range,
    %   which for a settings workbook is 112 columns and for a pathological one
    %   could be sixteen thousand; the rectangle asks only for what can be
    %   shown. Unbounded columns was also what made importing a spreadsheet
    %   take half a minute, when the range ended at column ZZ.
    %
    %   Three things then have to be settled before the result can go into a
    %   UITABLE, and each of them was a crash on a real recording workbook. The
    %   General sheet of TEST_BATCHMODE.XLSX is 112 columns wide but only 10
    %   rows deep, so a 100 row request came back as 100 x 112 with 10857 of
    %   those cells MISSING:
    %     - MISSING is not a value a table will take. Setting Data raises
    %       "Values within a cell array must be numeric, logical, or char", so
    %       every cell goes through SHEETCELLVALUE.
    %     - the padding is trimmed off the bottom as well as the right, or ten
    %       rows of data are shown inside a hundred mostly empty ones.
    %     - what is left is capped, so a very wide sheet cannot make a table
    %       too large to draw.
        maxColumns = 200;
        nRows = layout.headerLines + MAX_DATA_ROWS;
        truncated = false;
        try
            letters = tabularImport.columnLetters(maxColumns);
            data = readcell(layout.filePath, 'Sheet', char(layout.sheet), ...
                'Range', sprintf('A1:%s%d', letters{end}, nRows));
        catch
            data = {};
            return;
        end
        if isempty(data)
            data = {};
            return;
        end
        truncated = size(data, 2) >= maxColumns;

        % Trailing blanks are padding from a range bigger than the sheet.
        % Stopping at the first one with content keeps a genuine gap in the
        % middle from hiding the columns or rows after it.
        keep = true(1, size(data, 2));
        for c = size(data, 2):-1:1
            if allBlank(data(:, c))
                keep(c) = false;
            else
                break;
            end
        end
        keepRows = true(size(data, 1), 1);
        for r = size(data, 1):-1:1
            if allBlank(data(r, :))
                keepRows(r) = false;
            else
                break;
            end
        end
        data = data(keepRows, keep);

        data = cellfun(@sheetCellValue, data, 'UniformOutput', false);
    end


    function tf = allBlank(line)
    %ALLBLANK  True when every cell of LINE is an empty cell of the sheet.
    %   READCELL returns MISSING for an empty cell rather than an empty string,
    %   so a cell holding a space is content and is not trimmed away.
        tf = all(cellfun(@(v) isscalar(v) && ismissing(v), line));
    end


    function value = sheetCellValue(value)
    %SHEETCELLVALUE  A cell in a form a UITABLE will accept.
    %   A table takes numeric, logical and char. READCELL hands back MISSING for
    %   an empty cell, DATETIME for a date-formatted one, and now and then a
    %   nested cell or an embedded object - and one cell it will not take is
    %   enough to stop the import before the dialog has even appeared.
    %
    %   The numeric test comes FIRST because ISMISSING(NaN) is TRUE: a real NaN
    %   written in the sheet is a number, and it has to survive as one rather
    %   than be turned into an empty cell.
        if ischar(value) || isnumeric(value) || islogical(value)
            return;
        end
        if isscalar(value) && ismissing(value)
            value = '';
            return;
        end
        % DATETIME, DURATION, a nested cell, anything else: shown as what it
        % prints as rather than dropped. CHAR of a STRING is always a char
        % array, so there is nothing to check afterwards; the catch covers the
        % value that cannot be converted at all, and its '' is a char too.
        try
            value = char(string(value));
        catch
            value = '';
        end
    end


    function text = readFileHead(nLines)
    %READFILEHEAD  The head of the file, for the left pane. Only the LAYOUT's
    %   own path and the line cap are needed from outside, and both are shared,
    %   so this is called with the number of lines it should show and nothing
    %   else.
    %
    %   Clamped at both ends. The top is MAX_TEXT_LINES so a file with a huge
    %   header block cannot ask for the whole thing; the bottom is a floor, so
    %   the pane is never left blank by a caller that asks for almost nothing.
    %   Both callers now ask for HEADERLINES + MAX_DATA_ROWS, the same span the
    %   other two panes show, so the floor is only ever reached by a future
    %   caller rather than by the ordinary path - which is what it is for.
        wanted = min(MAX_TEXT_LINES, max(20, nLines));
        text = tabularImport.fileHead(layout.filePath, wanted);
        if isempty(text)
            text = {'(the file could not be read)'};
        end
    end


    function merged = reconcileColumns(old, new)
    %RECONCILECOLUMNS  Carry the user's choices across a re-read.
    %   The names, the import ticks and the time tick are all keyed to a column
    %   index, so they survive a re-read that does not change the column count,
    %   which is the normal case when only the delimiter or the decimal mark moved.
    %
    %   A name is carried over only if the user changed it. NAMEDITED is the
    %   dialog's own record of that, kept as the edits happen: working it out by
    %   comparing against the names the file was opened with cannot tell a rename
    %   to the name the file already used from no rename at all, and it also lost
    %   every rename the moment one was typed, because the typing never reached
    %   the layout this compares against.
        nNew = new.numColumns;
        names = new.columnNames(:).';
        if numel(names) < nNew
            names(end+1:nNew) = {'col'};
        end
        for c = 1:nNew
            if isempty(names{c})
                names{c} = sprintf('col%d', c);
            end
        end
        new.columnNames = names(1:nNew);
        new.numColumns = nNew;

        if numel(old.columnNames) == nNew
            for c = 1:nNew
                % an empty entry is a placeholder rather than an answer, so a
                % fresh one is worth more than nothing
                if c <= numel(nameEdited) && nameEdited(c) && ...
                        ~isempty(old.columnNames{c})
                    new.columnNames{c} = old.columnNames{c};
                end
            end
        end
        if numel(old.selectedColumns) > 0 && max(old.selectedColumns) <= nNew
            new.selectedColumns = old.selectedColumns;
        else
            new.selectedColumns = 1:nNew;
        end
        if isempty(old.timeColumn) || old.timeColumn > nNew
            new.timeColumn = new.timeColumn;
        end
        merged = new;
    end


    function convention = resolveConvention(choice)
    %RESOLVECONVENTION  Build the convention struct for a chosen decimal mark.
        switch choice
            case '.'
                convention = layout.convention;
                convention.needsRepair = false;
                convention.decimalSeparator = '.';
                convention.thousandsSep = ',';
                convention.reason = 'decimal point chosen in the import dialog';
            case ','
                convention = layout.convention;
                convention.needsRepair = true;
                convention.decimalSeparator = ',';
                convention.thousandsSep = '.';
                convention.reason = 'decimal comma chosen in the import dialog';
            otherwise
                convention = tabularImport.decimalConvention(layout.filePath, ...
                    layout.delimiter);
        end
    end


    function value = delimiterValue(delimiter)
    %DELIMITERVALUE  Map a detected delimiter onto the dropdown's item data.
        candidates = {',', ';', sprintf('\t'), '|', ' '};
        index = find(strcmp(delimiter, candidates), 1);
        if isempty(index)
            value = '';
        else
            value = candidates{index};
        end
    end


    function value = tickedValues(column)
    %TICKEDVALUES  The truth of a tick column, one logical per row.
    %   An unticked box can come back as an EMPTY rather than as false, and
    %   LOGICAL([]) is empty, so the result would shrink a row and FIND would
    %   then report the wrong rows as ticked. Each cell is therefore looked at
    %   on its own.
        if ~iscell(column)
            column = num2cell(column);
        end
        value = false(size(column));
        for r = 1:numel(column)
            entry = column{r};
            if ~isempty(entry)
                value(r) = logical(entry);
            end
        end
    end


    function indices = cellIndices(columns, nRows)
    %CELLINDICES  [row column] pairs for a set of table columns, one per row.
    %   addStyle wants every cell named, so a shaded column is nRows pairs. The
    %   lower table counts its data columns from 2 because column 1 holds the
    %   line number, which is why a file column is shifted one place here.
        indices = zeros(0, 2);
        for c = columns
            indices = [indices; (1:nRows)', repmat(c + 1, nRows, 1)]; %#ok<AGROW>
        end
    end


      function position = dialogPosition()
          %DIALOGPOSITION  Where the window goes, and how large it is.
          %
          %   IGNORES any parent figure. The window is the same size and in the
          %   same place whether the import was started from an application or
          %   from the Command Window.
          %
          %   That is not tidiness, it is a fix. Sizing to the parent meant a
          %   narrow application window quietly handed the parsed pane half as
          %   much room: a 700 px parent gave a 660 px window, so 318 px for the
          %   channel table instead of 508, and ten channels stopped fitting for
          %   a reason the user could neither see nor do anything about. The window
          %   is now full width, EIGHT TENTHS of the screen's height, and a tenth
          %   of the way up.
          %
          %   ScreenSize is measured from the BOTTOM left of the screen, so the
          %   screen's own offset is ADDED rather than subtracted. Subtracting it
          %   hangs the window off the top left by however far the desktop is from
          %   the origin, which is the bug the clamp below used to paper over.
          try
              screen = get(groot, 'ScreenSize');
          catch
              screen = [0 0 1920 1080];
          end
          if numel(screen) < 4 || any(~isfinite(screen)) || screen(3) < 200 || screen(4) < 200
              screen = [0 0 1920 1080];
          end
          width = screen(3);
          height = round(0.8 * screen(4));
          position = [screen(1) + round(0.0 * screen(3)), ...
              screen(2) + round(0.1 * screen(4)), width, height];
          position = max(round(position), [1 1 200 150]);
      end
function options = parseDialogOptions(args)
%PARSEDIALOGOPTIONS  NonModal and OnAccept exist for the tests.
    options = struct('NonModal', false, 'OnAccept', [], 'Blanks', 'linear');
    if mod(numel(args), 2) ~= 0
        error('tabularImport:notNameValue', ...
            'Options must be given as name-value pairs.');
    end
    for k = 1:2:numel(args)
        name = char(string(args{k}));
        switch lower(name)
            case 'nonmodal'
                options.NonModal = logical(args{k+1});
            case 'onaccept'
                if isempty(args{k+1}) || ~isa(args{k+1}, 'function_handle')
                    error('tabularImport:badOnAccept', ...
                        'OnAccept must be a function handle.');
                end
                options.OnAccept = args{k+1};
            case 'blanks'
                % Not validated here. The list of methods lives in FILLBLANKS,
                % and a second copy of it in the dialog would be a second
                % answer to the same question waiting to disagree with the
                % first. An unknown value is rejected the first time the pane
                % is filled, with the dialog's own options already on screen.
                options.Blanks = char(string(args{k+1}));
            otherwise
                error('tabularImport:unknownOption', 'Unknown option "%s".', name);
        end
    end
end


% =============================================================================
function method = blanksFromOptions(options)
%BLANKSFROMOPTIONS  The chosen blank policy, checked against FILLBLANKS.
%   The list is FILLBLANKS's own, INCLUDING 'keep', which this menu does not
%   offer: a caller who passes 'Blanks','keep' in code still gets it, and the
%   dropdown falls back to the default rather than refusing to open.
%   Keeping one list in one place matters more than the length - a second copy
%   is a second answer to the same question waiting to disagree with the first.
    method = 'linear';
    if ~isfield(options, 'Blanks') || isempty(options.Blanks)
        return;
    end
    methods = {'keep', 'drop', 'previous', 'next', 'nearest', 'linear', ...
        'spline', 'pchip', 'makima'};
    if ~any(strcmp(options.Blanks, methods))
        error('tabularImport:badBlanksMethod', ...
            'unknown Blanks method "%s". Use one of: %s.', ...
            options.Blanks, strjoin(methods, ', '));
    end
    if strcmp(options.Blanks, 'keep')
        % Not on the menu. The dialog shows the default and the warning pane
        % says so, because quietly importing something other than what was asked
        % for is the one thing a settings window must never do.
        method = 'linear';
        return;
    end
    method = options.Blanks;
end
end
