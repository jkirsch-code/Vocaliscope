function [data, time, report, keepRows] = fillBlanks(data, time, method)
%FILLBLANKS  Apply the chosen policy for cells that hold no number.
%   [DATA, TIME, REPORT, KEEPROWS] = FILLBLANKS(DATA, TIME, METHOD)
%
%   DATA     SAMPLES x CHANNELS, as it was read
%   TIME     SAMPLES x 1, or [] when the file has no time axis
%   KEEPROWS logical, one per row of DATA AS IT ARRIVED, saying which rows
%           survived. The single answer to "which samples is this policy
%           throwing away", so the import and the preview that shows its effect
%           cannot disagree about it.
%
%   A cell that holds no number arrives as NaN, and it is not always possible
%   to tell why: READMATRIX turns text in a numeric column into NaN exactly as
%   it turns an empty cell into NaN, so an empty cell and a stray word look the
%   same by the time they get here. What follows is therefore a policy for
%   NaNs, not a diagnosis of them.
%
%   The time axis
%   -------------
%   The axis is never interpolated, whatever METHOD says. A sample with no time
%   has no place on the axis: LINEAR would put it somewhere plausible and the
%   result would look right while being fiction, and PREVIOUS or NEXT would
%   put two samples at the same instant. Rows with a missing time are dropped
%   under EVERY method, including 'keep'. Dropping them means the result is no
%   longer uniformly sampled, so REPORT.nonUniform says so.
%
%   The methods
%   -----------
%     keep       NaN is left exactly as it is. The default, because inventing
%                values silently is worse than admitting there is a hole. This
%                is the ONE method that does not drop an unfillable hole - it
%                is the method for asking not to be helped.
%     drop       any row with a non-numeric channel is removed. Averages what
%                is left and loses the samples; REPORT says how many.
%     previous   nearest earlier value, flat across the gap
%     next       nearest later value, flat across the gap
%     nearest    nearest value either side, ties going to the earlier one
%     linear     straight line between the two ends of the gap
%     spline     cubic spline
%     pchip      shape preserving cubic spline
%     makima     modified Akima cubic Hermite
%
%   Nothing is EXTRAPOLATED
%   -----------------------
%   A gap needs a value on BOTH sides of it. A hole in the first row or the last
%   row of a channel has only one, and inventing the other is not interpolation
%   - it is fabrication, and FILLMISSING does it without being asked. Measured
%   on a channel that runs 1,2,NaN,NaN,3,4 with NaN at both ends:
%
%       previous  -> NaN 1 2 2 2 3 4 4      left one hole
%       next      ->  1  1 2 3 3 3 4 NaN     left one hole
%       linear    ->  0  1 2 2.3 2.7 3 4 5  INVENTED both ends
%       spline    -> -1  1 2 2.4 2.6 3 4 6  invented, and OVERSHOOT
%       makima    -> -0.09 ... 5.09          invented
%
%   A channel whose first real sample is 1 came back beginning at -1, because
%   that is what a cubic does when asked to continue past its data. Interpolating
%   is defensible; that is not, and nothing here can tell the user which of the
%   two a given cell was.
%
%   So every method above 'keep' FILLS THE INTERIOR AND DROPS THE REST. What is
%   still not a number after filling is a sample with no neighbour on one side,
%   and it is removed rather than guessed at. REPORT.droppedEdge counts them.
%   A consequence worth stating: a file whose very FIRST sample is missing loses
%   that sample and starts at the second one, rather than beginning with an
%   invented value. That is the honest reading of "fill what can be filled".
%
%   And the test is repeated after every removal, because removing a row moves
%   the edges: a hole that was interior can become the new first row, which is
%   unfillable after all. See the note at the loop.
%
%   REPORT fields: method, rowsBefore, rowsAfter, blanks, filled, unfilled,
%   droppedTime, droppedData, droppedEdge, nonUniform.
%
%   One function for both the preview and the import, so the dialog cannot
%   promise something the import does not deliver.
%
%   See also READTABULARFILE, PREVIEWDIALOG.

arguments
    % Deliberately unconstrained on shape. The natural orientation is
    % SAMPLES x CHANNELS, and FILLMISSING's default fill direction is down the
    % first dimension, which is what fills each channel along time. A (1,:)
    % constraint would have been wrong in a way that reads as correct: it
    % demands a row, and a single sample of many channels IS a row.
    data double
    time double = []
    method (1,1) string = "keep"
end

% Checked here rather than with MUSTBEVECTOR, which rejects [] because
% ISVECTOR([]) is false - and [] is the normal way of saying there is no axis.
% Testing the count against the samples catches a wrong length and a wrong
% shape in one go.
if ~isempty(time) && (numel(time) ~= size(data, 1) || ~isvector(time))
    error('tabularImport:badTimeAxis', ...
        ['TIME must be empty or a vector with one entry per sample (%d); ' ...
         'it is %s.'], size(data, 1), mat2str(size(time)));
end

% Declared after the ARGUMENTS block, which has to be the first executable
% statement of the function.
methods = {'keep', 'drop', 'previous', 'next', 'nearest', 'linear', ...
    'spline', 'pchip', 'makima'};

if ~any(strcmp(method, methods))
    error('tabularImport:badBlanksMethod', ...
        'unknown Blanks method "%s". Use one of: %s.', ...
        char(method), strjoin(methods, ', '));
end

report = struct('method', char(method), ...
    'rowsBefore', size(data, 1), 'rowsAfter', size(data, 1), ...
    'blanks', 0, 'filled', 0, 'unfilled', 0, ...
    'droppedTime', 0, 'droppedData', 0, 'droppedEdge', 0, ...
    'nonUniform', false);

% Which rows of DATA AS IT ARRIVED are still here, as indices into it. Carried
% alongside the data rather than as a mask, because every removal narrows this
% list AND the data by the same indices - and a mask would have to be a
% different length from the data after the first removal, which is how the
% preview's marking came to be asked about the wrong rows entirely.
rowIndex = 1:size(data, 1);

%% --------------------------------------------------- the time axis, dropped
% Always, and before anything else, so the rows and the axis stay the same
% length and the gap is not filled with a plausible lie.
if ~isempty(time)
    surviving = find(isfinite(time));
    if numel(surviving) < numel(time)
        report.droppedTime = numel(time) - numel(surviving);
        report.nonUniform = true;
        rowIndex = rowIndex(surviving);
        time = time(surviving);
        data = data(surviving, :);
    end
end

% Measured on the rows that SURVIVE the time drop, not on the rows as they
% arrived: a cell in a row dropped for its missing time is not a blank still to
% be accounted for.
report.blanks = sum(~isfinite(data(:)));

% Filled and unfilled are counted inside each branch rather than from a mask
% taken before it. A branch may remove rows - 'drop' does - and then a mask
% measured before it no longer matches the data it is compared against.
switch method
    case "keep"
        % Nothing to do. Reported so that the absence of holes is a statement
        % rather than an assumption, and the ONE method that keeps a hole it
        % cannot fill: 'keep' is the request not to be helped.
        report.unfilled = report.blanks;

    case "drop"
        surviving = find(all(isfinite(data), 2));
        if numel(surviving) < size(data, 1)
            report.droppedData = size(data, 1) - numel(surviving);
            report.nonUniform = report.nonUniform || ~isempty(time);
            rowIndex = rowIndex(surviving);
            data = data(surviving, :);
            if ~isempty(time)
                time = time(surviving);
            end
        end
        % Nothing was FILLED: the blanks went with their rows, which is what
        % droppedData counts. Anything still not a number would be a mistake.
        report.filled = 0;
        report.unfilled = sum(~isfinite(data(:)));

    otherwise
        % A gap needs a value on BOTH sides of it, so the holes that cannot be
        % filled have to be found BEFORE anything fills anything. This is the
        % part that is easy to get wrong: FILLMISSING does not leave an edge
        % hole as NaN for a second pass to catch, it WRITES a value there, and
        % then there is nothing left to recognise. Measured on 1,2,NaN,NaN,3,4
        % with NaN at both ends, SPLINE returned -1 ... 6 - it continued the
        % curve past its own data and the invented -1 was sitting in the result
        % looking exactly like a measurement.
        %
        % So the test is asked of the geometry rather than of the result: in one
        % column, a hole above the first finite value or below the last one has
        % a neighbour on one side only, and a hole between two finite values has
        % both. A whole column of holes has neither, and every row of it goes.
        %
        % AND IT IS ASKED AGAIN AFTER EVERY REMOVAL, which is the part that took
        % a while to find. Removing a row moves the edges, and a hole that was
        % interior can become the new first or last row - and then it is
        % unfillable after all. Measured: a hole at rows 3-5 of one channel, with
        % a leading hole in another channel taking rows 1-3. Those three rows go,
        % and what is left starts at row 4 - so rows 4 and 5 are now the FIRST
        % rows of the data, PREVIOUS has nothing above them, and it left both as
        % NaN. In the preview they got no mark of any kind, and two NaNs reached
        % the output of an import that had reported zero unfilled samples.
        %
        % The loop is bounded by the number of rows because each pass removes at
        % least one: every hole it finds is at an edge, and an edge hole cannot
        % survive the pass that removes it.
        while true
            notFillable = unfillableHoles(data);
            % A row goes if any one of its channels cannot be filled: the samples
            % have to line up across the channels, so one unfillable cell costs
            % the whole sample rather than desynchronising the channels from
            % each other.
            badRow = any(notFillable, 2);
            if ~any(badRow)
                break;
            end
            report.droppedEdge = report.droppedEdge + sum(badRow);
            report.nonUniform = report.nonUniform || ~isempty(time);
            surviving = find(~badRow);
            rowIndex = rowIndex(surviving);
            data = data(surviving, :);
            if ~isempty(time)
                time = time(surviving);
            end
            if isempty(data)
                break;
            end
        end

        % WHICH cells were blank, on the rows that are still here.
        wasBlank = ~isfinite(data);
        if report.blanks > 0
            data = fillmissing(data, char(method));
        end
        % Every hole left in here is interior by construction, so nothing this
        % writes is an extrapolation. That is the whole argument for doing the
        % removal first rather than second.
        report.filled = sum(wasBlank(:));
        report.unfilled = sum(~isfinite(data(:)));
end
report.rowsAfter = size(data, 1);

% The mask the preview marks against: one entry per row of DATA AS IT ARRIVED,
% false for every sample this policy threw away. Built from ROWINDEX rather than
% narrowed as we went, because narrowing a mask of the original length by the
% survivors makes it the length of the RESULT, and a caller asking which of ITS
% rows survived then gets a shorter answer than the question.
keepRows = false(report.rowsBefore, 1);
if ~isempty(rowIndex)
    keepRows(rowIndex) = true;
end
end


function notFillable = unfillableHoles(data)
%UNFILLABLEHOLES  Which cells have a neighbour on only ONE side.
%   A gap needs a value before it and a value after it. In one column, a hole
%   above the first finite value or below the last one has one; a hole between
%   two finite values has both. A column with no finite value at all has
%   neither, and every cell in it is unfillable.
%
%   Asked of the GEOMETRY rather than of the result, because FILLMISSING does
%   not leave an edge hole as NaN for a second pass to catch: it WRITES a value
%   there and there is nothing left to recognise. Measured on a channel running
%   1, 2, NaN, NaN, 3, 4 with NaN at both ends, SPLINE returned -1 ... 6 - it
%   continued the curve past its own data and the invented -1 sat in the result
%   looking exactly like a measurement.
notFillable = false(size(data));
if isempty(data)
    return;
end
% A COLUMN, so the comparison against the per-column finite flags below is
% elementwise. As a row it would be N-by-1 against 1-by-N, which MATLAB answers
% with an N-by-N implicit expansion, and the assignment into NOTFILLABLE then
% fails with a size mismatch that says nothing about which of the two shapes was
% intended.
rows = (1:size(data, 1))';
for c = 1:size(data, 2)
    finiteHere = isfinite(data(:, c));
    if ~any(finiteHere)
        notFillable(:, c) = ~finiteHere;
        continue;
    end
    first = find(finiteHere, 1, 'first');
    last = find(finiteHere, 1, 'last');
    notFillable(:, c) = ~finiteHere & ((rows <= first) | (rows >= last));
end
end