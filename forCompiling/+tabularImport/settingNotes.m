function notes = settingNotes(layout)
%SETTINGNOTES  The warnings that describe the current SETTINGS, not the file.
%   NOTES is a cellstr of one-sentence warnings, possibly empty.
%
%   Most of what DETECTLAYOUT reports describes the FILE and cannot be changed
%   from the import dialog: a Photron export is a Photron export. Three of its
%   entries are different in kind. They state which WORKSHEET is being read,
%   whether the numbers are being rewritten for a decimal comma, and WHICH WAY
%   THE SAMPLES RUN, and the dialog has a dropdown for each. So they are not
%   facts about the file at all - they are statements about a choice, and a
%   statement about a choice goes stale the moment the choice changes.
%
%   That is not a small thing. The import dialog showed
%       'this workbook has 2 sheets, only "Signal sheet" will be imported'
%   after the user had already chosen the other sheet, because the text had
%   been written once at detection time and then copied verbatim. This function
%   is what makes those notes live: DETECTLAYOUT calls it so a headless caller
%   still gets them, and PREVIEWDIALOG calls it again at display time from the
%   layout as it stands, which is what keeps them honest.
%
%   The orientation note is in the same family for the same reason. A file read
%   sideways is a startling thing to have happened to it, and the user has to be
%   told - but it is also a DIALOG CHOICE, so the sentence has to be built from
%   the layout as it stands rather than copied from the detection, or it would
%   keep claiming the samples run across the columns after the user had put them
%   back down the rows.
%
%   Callers that also hold a LAYOUT from DETECTLAYOUT should drop the entries
%   that SETTINGNOTES produced rather than adding these to them; DETECTLAYOUT
%   records where they went in LAYOUT.settingNoteIndex for exactly that.
%
%   See also DETECTLAYOUT, PREVIEWDIALOG, READTABULARFILE.
%   NOTES is a cellstr of one-sentence warnings, possibly empty.
%
%   Most of what DETECTLAYOUT reports describes the FILE and cannot be changed
%   from the import dialog: a Photron export is a Photron export. Two of its
%   entries are different in kind. They state which WORKSHEET is being read and
%   whether the numbers are being rewritten for a decimal comma, and the dialog
%   has a dropdown for each. So they are not facts about the file at all - they
%   are statements about a choice, and a statement about a choice goes stale
%   the moment the choice changes.
%
%   That is not a small thing. The import dialog showed
%       'this workbook has 2 sheets, only "Signal sheet" will be imported'
%   after the user had already chosen the other sheet, because the text had
%   been written once at detection time and then copied verbatim. This function
%   is what makes those notes live: DETECTLAYOUT calls it so a headless caller
%   still gets them, and PREVIEWDIALOG calls it again at display time from the
%   layout as it stands, which is what keeps them honest.
%
%   Callers that also hold a LAYOUT from DETECTLAYOUT should drop the entries
%   that SETTINGNOTES produced rather than adding these to them; DETECTLAYOUT
%   records where they went in LAYOUT.settingNoteIndex for exactly that.
%
%   See also DETECTLAYOUT, PREVIEWDIALOG, READTABULARFILE.

arguments
    layout (1,1) struct
end

notes = cell(1, 0);

% Only worth saying when there is a choice to be made. With one worksheet the
% import dialog shows no sheet dropdown at all, so the note would describe
% something the user cannot act on.
if isfield(layout, 'isSpreadsheet') && layout.isSpreadsheet && ...
        isfield(layout, 'sheetNames') && numel(layout.sheetNames) > 1
    notes{end+1} = sprintf('this workbook has %d sheets, only "%s" will be imported', ...
        numel(layout.sheetNames), char(layout.sheet));
end

if isfield(layout, 'orientation') && strcmp(layout.orientation, 'horizontal')
    notes{end+1} = sprintf( ...
        ['the samples run across the columns, so the channels were read from ' ...
         'the %d column(s) at the left and turned upright; %d row(s) above the ' ...
         'data were skipped'], ...
        columnCount(layout, 'nameColumns'), columnCount(layout, 'headerLines'));
end

if isfield(layout, 'convention') && layout.convention.needsRepair
    notes{end+1} = sprintf( ...
        ['the numbers use a decimal "%s" and the file is rewritten before it ' ...
         'is read, because %s'], layout.convention.decimalSeparator, ...
        layout.convention.reason);
end
end


function n = columnCount(layout, field)
%COLUMNCOUNT  A count off the layout, or zero when it has no such field.
%   Every layout built before these fields existed lacks both, and SETTINGNOTES
%   is called on whatever layout it is handed - including one a caller made up
%   in a test. Zero is right in every such case: skipping nothing is what an
%   absent field means.
n = 0;
if isfield(layout, field) && ~isempty(layout.(field))
    n = layout.(field);
end
end