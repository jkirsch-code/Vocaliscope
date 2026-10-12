function convention = decimalConvention(filePath, delimiter, maxBytes, maxSamples)
%DECIMALCONVENTION  Decide how the numbers in FILEPATH are punctuated.
%   Returns a struct with the fields
%     needsRepair       true when the file has to be rewritten before it can
%                       be read as numbers
%     decimalSeparator  ',' or '.'
%     thousandsSep      ',', '.' or '' when there is none
%     reason            a sentence for the import dialog
%
%   A cell is classified by which separators it contains: none, one or both.
%   When every cell uses a single comma, that comma is the decimal mark and
%   the file needs repairing. When cells use both, the LAST separator is the
%   decimal mark, which is the rule that makes "1.234,5" and "1,234.5" both
%   come out right.
%
%   MAXBYTES caps how much of the file is read and MAXSAMPLES how many cells
%   are looked at, so a multi hundred megabyte export is not scanned whole.
%   Both default generously: reading more costs time, reading too little
%   costs correctness, and a file's punctuation does not change halfway down.
%
%   See also REPAIRDECIMALCOMMA, DETECTLAYOUT, READMATRIX.

arguments
    filePath (1,1) string
    delimiter (1,1) string = ""
    maxBytes (1,1) double {mustBePositive} = 64 * 1024
    maxSamples (1,1) double {mustBePositive} = 20000
end

convention = struct('needsRepair', false, 'decimalSeparator', '.', ...
                    'thousandsSep', '', 'reason', 'the file already uses a decimal point');

if isempty(delimiter)
    return;
end

fid = fopen(filePath, 'r');
if fid < 0
    return;
end
cleanup = onCleanup(@() fclose(fid));

% the row size must be given explicitly, or fread returns a column and
% char() of a column is a char matrix that regexp refuses
text = fread(fid, [1, maxBytes], '*char', 'native');
text = char(text(:).');
if isempty(text)
    return;
end

lines = regexp(text, '\r\n|\n|\r', 'split');
lines = lines(~cellfun(@isempty, strtrim(lines)));

tokens = {};
for k = 1:numel(lines)
    if numel(tokens) >= maxSamples
        break;
    end
    parts = strsplit(strtrim(lines{k}), char(delimiter));
    for c = 1:numel(parts)
        token = strtrim(parts{c});
        if isempty(token)
            continue;
        end
        % a field that is not a bare number (a label, a date) says nothing
        % about the punctuation of the data
        if isempty(regexp(token, '^[+-]?[\d.,]+\s*[eE]?[+-]?\d*$', 'once'))
            continue;
        end
        tokens{end+1} = token; %#ok<AGROW>
        if numel(tokens) >= maxSamples
            break;
        end
    end
end

if isempty(tokens)
    return;
end

hasComma = false;
hasDot = false;
both = 0;
commaOnly = 0;
dotOnly = 0;
for k = 1:numel(tokens)
    token = tokens{k};
    c = contains(token, ',');
    d = contains(token, '.');
    hasComma = hasComma || c;
    hasDot = hasDot || d;
    if c && d
        both = both + 1;
    elseif c
        commaOnly = commaOnly + 1;
    elseif d
        dotOnly = dotOnly + 1;
    end
end

if both > 0
    % both separators appear: the last one in the cell is the decimal mark
    lastCommaWins = 0;
    for k = 1:numel(tokens)
        token = tokens{k};
        if ~contains(token, ',') || ~contains(token, '.')
            continue;
        end
        % Which of the two separators comes LAST decides which one is the
        % decimal mark. FIND takes an occurrence and a direction only for a
        % string array, not for a char array, so the four argument form is not
        % available on TOKEN. STRFIND hands the hits back from the left in
        % increasing order, so the last one is the final element.
        commas = strfind(token, ',');
        if ~isempty(commas), commas = commas(end); end
        dots = strfind(token, '.');
        if ~isempty(dots), dots = dots(end); end
        % A separator the token does not carry has to stay EMPTY rather than
        % become a position: the end of an empty is index 0, which is not a
        % legal subscript, and standing in a 0 for it would also make a comma
        % in the first column of "1,5" beat an absent dot and have the number
        % read as a grouped one.
        if commas > dots
            lastCommaWins = lastCommaWins + 1;
        end
    end
    if lastCommaWins * 2 >= both
        convention.needsRepair = true;
        convention.decimalSeparator = ',';
        convention.thousandsSep = '.';
        convention.reason = sprintf('%d cells hold both separators, the last one is a decimal comma', both);
    else
        convention.needsRepair = false;
        convention.decimalSeparator = '.';
        convention.thousandsSep = ',';
        convention.reason = sprintf('%d cells hold both separators, the last one is a decimal point', both);
    end
    return;
end

if hasComma && ~hasDot
    convention.needsRepair = true;
    convention.decimalSeparator = ',';
    convention.thousandsSep = '';
    convention.reason = sprintf('%d cells hold a decimal comma, all of them read as a single number', commaOnly);
    return;
end

if hasDot
    convention.needsRepair = false;
    convention.decimalSeparator = '.';
    convention.thousandsSep = '';
    convention.reason = sprintf('%d cells hold a decimal point, which MATLAB already reads', dotOnly);
end
end



