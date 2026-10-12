function labels = columnLetters(width)
%COLUMNLETTERS  Spreadsheet column letters for a width of columns: A, B ... Z,
%   AA, AB and so on.
%   LABELS is a 1 x WIDTH cell of char.
%
%   Used in two places that have to agree: READMATRIX needs the last letter to
%   close a range, and the import dialog labels the columns of its preview so
%   they line up with the sheet the user has open in Excel. Guessing the
%   letters in each of those places is how they come to disagree.
%
%   WIDTH is clamped to a non-negative integer, so a caller whose count came
%   from a probe that failed gets an empty result rather than an error.
%
%   See also READMATRIX, PREVIEWDIALOG.

arguments
    width (1,1) double
end

if ~isfinite(width) || width < 1
    labels = cell(1, 0);
    return;
end
width = round(width);

labels = cell(1, width);
for c = 1:width
    % Counted from one, the way a spreadsheet counts, so column 1 is A rather
    % than the empty string that a plain base-26 of zero would give. DIVMOD is
    % a Python function and not a MATLAB one, so the quotient and the digit
    % are taken apart by hand.
    %
    % Collected as characters and assembled once at the end: prepending to a
    % char array as the digits come is both a resize on every iteration and,
    % with the accumulator starting empty, arithmetic on a 1x1 against a 1x0 -
    % which returns empty and made every letter blank.
    n = c;
    parts = cell(1, 7);          % seven covers any sheet Excel itself allows
    k = numel(parts);
    while n > 0
        digit = mod(n - 1, 26);
        n = floor((n - 1) / 26);
        parts{k} = char('A' + digit);
        k = k - 1;
    end
    % Filled from the right, because the digits arrive least significant first
    % and FLIPUD does not reorder a cell array the way it reorders a numeric
    % one - which left 52 reading ZA instead of AZ.
    %
    % Reshaped to a row afterwards because CHAR of a cell array STACKS its
    % contents vertically: AA came back as a 2x1 char, which every %s printed
    % happily as AA while STRCMP rejected it for the wrong shape. Anything
    % building a range from these letters wants a 1 x k char.
    labels{c} = reshape(char(parts(k+1:end)), 1, []);
end
end