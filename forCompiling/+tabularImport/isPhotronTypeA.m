function isPhotron = isPhotronTypeA(filePath)
%ISPHOTRONTYPEA  True when FILEPATH looks like a Photron Graph Express export.
%   Photron writes a small header block above the data, and the giveaway is a
%   line whose FIRST field is exactly "type", naming the column that follows.
%   The same block normally starts with a "SamplingRate" line.
%
%   Only the first few lines are inspected. The check is deliberately
%   conservative: it has to reject a Photron file so the app can hand it to
%   its own dedicated importer, and a false positive would send an ordinary
%   file down the wrong path, so an ambiguous file is reported as not
%   Photron.
%
%   Splitting is done on both ',' and ';' because the Photron header is not
%   internally consistent about which one it uses.
%
%   See also DETECTLAYOUT, READTABULARFILE.

arguments
    filePath (1,1) string
end

isPhotron = false;

fid = fopen(filePath, 'r');
if fid < 0
    return;
end
cleanup = onCleanup(@() fclose(fid));

% a few hundred bytes is plenty: only the first few lines matter and they are
% short. The row size must be given explicitly or fread returns a column,
% and char() of a column is a char matrix that regexp refuses.
text = fread(fid, [1, 8 * 1024], '*char', 'native');
text = char(text(:).');

lines = regexp(text, '\r\n|\n|\r', 'split');
lines = lines(~cellfun(@isempty, strtrim(lines)));
lines = lines(1:min(5, numel(lines)));

for k = 1:numel(lines)
    line = strtrim(lines{k});
    fields = splitBoth(line);
    if isempty(fields)
        continue;
    end
    switch lower(fields{1})
        case 'type'
            isPhotron = true;
            return;
        case 'samplingrate'
            % the rate line alone is a strong hint, but only trust it when a
            % type line follows within the same block
            isPhotron = true;
            return;
    end
end
end


function fields = splitBoth(line)
%SPLITBOTH  Split LINE on a comma or a semicolon, whichever comes first.
%   A field is only taken as the first one if the line is not simply a long
%   run of numbers, which is what the data rows look like.
candidates = {',', ';'};
best = [];
for k = 1:numel(candidates)
    parts = strsplit(line, candidates{k});
    if any(strlength(strtrim(parts)) == 0)
        continue;
    end
    if isempty(best) || numel(parts) > numel(best)
        best = parts;
    end
end
if isempty(best)
    fields = {};
    return;
end
fields = cellfun(@strtrim, best, 'UniformOutput', false);
end
