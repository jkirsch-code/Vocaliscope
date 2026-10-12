function [lines, truncated] = fileHead(filePath, maxLines)
%FILEHEAD  First MAXLINES lines of FILEPATH, as read, without editing.
%   LINES is a cell array of char, one row per line, with the line endings
%   removed and every other character left exactly as it is in the file. The
%   point is that the import dialog can show the user the same text the
%   importer split, so a wrong delimiter, a stray quote, a wrong decimal mark
%   or an unexpected header row is visible without opening the file in an
%   editor.
%
%   TRUNCATED is true when the file holds more lines than MAXLINES.
%
%   Only whole lines are returned: a line is never shown half finished, so the
%   field count reported for it is the number the importer would see.
%
%   See also READTABULARFILE, DETECTLAYOUT, PREVIEWDIALOG.

arguments
    filePath (1,1) string
    maxLines (1,1) double {mustBeInteger, mustBePositive} = 20
end

lines = {};
truncated = false;

fid = fopen(filePath, 'r');
if fid < 0
    return;
end
cleanup = onCleanup(@() fclose(fid));

% a generous block, a few hundred bytes per line, is enough for the widest
% tabular line in practice and still avoids reading a whole export
budget = max(4096, 512 * maxLines);
text = fread(fid, [1, budget], '*char', 'native');
text = char(text(:).');

% cut back to the last complete line so a partial line is never reported
cuts = [strfind(text, [char(13) newline]), strfind(text, newline), ...
        strfind(text, char(13))];
if isempty(cuts)
    if ~isempty(text)
        lines = {text};
    end
    return;
end

lastBreak = max(cuts);
if lastBreak < numel(text)
    % the line after the last break was cut in half, so there is more to read
    truncated = true;
end

parts = regexp(text(1:lastBreak), '\r\n|\n|\r', 'split');
parts = parts(~cellfun(@isempty, parts));
if numel(parts) > maxLines
    parts = parts(1:maxLines);
    truncated = true;
end
lines = parts(:);
end
