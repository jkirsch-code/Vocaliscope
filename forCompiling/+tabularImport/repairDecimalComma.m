function [tempPath, tempName] = repairDecimalComma(filePath, delimiter, maxHeaderLines, rowLimit)
%REPAIRDECIMALCOMMA  Rewrite a comma-decimal file so MATLAB can read it.
%   Returns [TEMPPATH, TEMPNAME]. TEMPPATH is the path of a new file in the
%   temporary folder, TEMPNAME is its bare name.
%
%   Each cell is converted on its own:
%     "1.234,5"  the last separator is the decimal mark, so the other is a
%                thousands separator and the cell becomes 1234.5
%     "0,0000"   a lone comma is a decimal mark and the cell becomes 0.0000
%     "0.0000"   already fine and is left exactly as it was
%   The line structure and the field delimiter are preserved, so a repaired
%   file differs from the original only in its numbers.
%
%   MAXHEADERLINES leading rows are copied through without conversion, so a
%   metadata or label row is never mangled. It counts from the first line of
%   the file, so pass the layout's header row count. ROWLIMIT caps the data
%   rows written; the default is unlimited. Both are read as a cap the caller
%   asked for when it does not care, and the one that matters is
%   MAXHEADERLINES: its default is 0, meaning "no leading row is protected".
%   It must not be Inf, because a cap of Inf protects EVERY line and the
%   function then copies the file through unchanged and repairs nothing,
%   which is exactly what it did before this was noticed.
%
%   The file is streamed a line at a time rather than slurped, because a
%   Photron style export can hold several samples per line and hundreds of
%   megabytes.
%
%   See also DECIMALCONVENTION, READMATRIX.

arguments
    filePath (1,1) string
    delimiter (1,1) string
    maxHeaderLines (1,1) double = 0
    rowLimit (1,1) double = Inf
end

% TEMPNAME gives an absolute path and no extension, so the extension is simply
% appended to it.
%
% It used to go through FILESPARTS: [~, base, ext] = fileparts(tempPath). That
% second output is the NAME, not the path - the folder is the FIRST output - so
% "base" held nothing but "tpa9543358_ef84_4557_b748_b96db167284f", and
% appending '.csv' to it produced a bare filename. FOPEN resolved that against
% the current folder, which is how a repaired copy of a demo file kept turning
% up in the project root instead of the temp folder.
tempPath = [tempname() '.csv'];
tempName = char(java.io.File(char(tempPath)).getName());

inFile = fopen(filePath, 'r');
if inFile < 0
    error('tabularImport:cannotRepair', 'cannot read %s', filePath);
end
inCleanup = onCleanup(@() fclose(inFile));

outFile = fopen(tempPath, 'w');
if outFile < 0
    error('tabularImport:cannotRepair', 'cannot write %s', tempPath);
end
outCleanup = onCleanup(@() fclose(outFile));

lineNo = 0;
dataRows = 0;
while true
    line = fgetl(inFile);
    if ~ischar(line)
        break;
    end
    lineNo = lineNo + 1;
    if lineNo <= maxHeaderLines
        % header rows are labels, not numbers, and must survive untouched
        fprintf(outFile, '%s\n', line);
        continue;
    end
    if dataRows >= rowLimit
        break;
    end
    dataRows = dataRows + 1;
    fprintf(outFile, '%s\n', convertLine(line, delimiter));
end
end


function out = convertLine(line, delimiter)
%CONVERTLINE  Convert every field of LINE, preserving empties.
delimiter = char(delimiter);
if isempty(delimiter)
    out = line;
    return;
end

parts = strsplit(line, delimiter);
for k = 1:numel(parts)
    parts{k} = convertNumber(strtrim(parts{k}));
end
out = strjoin(parts, delimiter);
end


function out = convertNumber(token)
%CONVERTNUMBER  Turn one field into a form MATLAB's readmatrix accepts.
%   Anything that is not a bare number is returned untouched: a missing value
%   marker such as "NaN" or an empty cell must not become something else.
if isempty(token)
    out = token;
    return;
end
if isempty(regexp(token, '^[+-]?[\d.,]+$', 'once'))
    out = token;
    return;
end

% The LAST of each separator is what decides which one is the decimal mark.
% FIND takes an occurrence and a direction only for a string array, not for a
% char array, so the four argument form is not available on TOKEN and every
% call to it raised "Too many input arguments". STRFIND hands the hits back
% from the left in increasing order, so the last one is the final element.
commas = strfind(token, ',');
if ~isempty(commas), commas = commas(end); end
dots = strfind(token, '.');
if ~isempty(dots), dots = dots(end); end
% A separator the token does not carry stays EMPTY rather than becoming a
% position: the end of an empty is index 0, which is not a legal subscript.
lastComma = commas;
lastDot = dots;

if isempty(lastComma) && isempty(lastDot)
    % a bare integer, or a lone grouping separator
    out = strrep(token, ',', '');
    return;
end

if isempty(lastDot)
    % only commas: the last one is the decimal mark
    out = strrep(strrep(token, '.', ''), ',', '.');
    return;
end

if isempty(lastComma)
    out = strrep(token, ',', '');
    return;
end

if lastComma > lastDot
    % "1.234,5": dot groups, comma is the decimal mark
    out = strrep(strrep(token, '.', ''), ',', '.');
else
    % "1,234.5": comma groups, dot is the decimal mark
    out = strrep(token, ',', '');
end
end



