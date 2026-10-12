function sampleRate = askSampleRate(pkg, suggested, parent)
%ASKSAMPLERATE  Ask the sampling rate of a file that has no time vector.
%   SAMPLERATE is the rate the user confirmed, or [] if they cancelled.
%
%   The package has to ask for the rate the moment a recording has no time
%   vector to work from, so this dialog is not a courtesy: READTABULARFILE
%   calls it, and then either returns a recording with a time vector or raises
%   NO SAMPLERATE. PKG names the package the question comes from and is kept
%   in the signature so a caller can say so; the window is titled plainly,
%   because a title is not worth a name only the developer would recognise.
%
%   THE QUESTION WAITS, and that is the whole point of it. This call opens the
%   window and does not return until OK or Cancel closes it. It used to build
%   the window and then read the field straight back, which is empty on the
%   first line, so the dialog was on screen for about a thirtieth of a second
%   and then vanished - leaving READTABULARFILE to report that no rate had been
%   given, as though a question the user was never shown had been declined.
%   The modal style is what stops the import dialog being touched underneath
%   while this one is open.
%
%   Each preset rate is ONE click that fills the field and accepts it, because
%   picking a rate from a list is the normal way to answer this and typing a
%   number first is not. All eight presets used to be dead: each one only
%   turned the OK button ON, and OK was only ever ON once the field already
%   held a number. The field is empty in the only state this dialog is ever
%   opened in - there is no time vector to infer anything from - so not one of
%   them could ever be pressed.
%
%   OK is available only once the field holds a positive finite number, so
%   there is no way to confirm a blank or a nonsensical rate.
%
%   Closing the window with its X button counts as a CANCELLATION rather than
%   an acceptance, so a number typed but not confirmed cannot come back.
%
%   SUGGESTED pre-fills the field when the caller has something to offer.

if nargin < 2
    suggested = [];
end
if nargin < 3
    parent = [];
end

% A MODAL uifigure cannot be parented on this release. UIFIGURE answers
% "Figure parent must be the root" for [], for groot and for a real figure
% alike, so the window is always created at the root and PARENT is consulted
% only for where to put it - which is what PREVIEWDIALOG does with its parent.
position = [100 200 520 250];
% ISPROP is what makes this safe: GROOT and the other root objects answer true
% to ISGRAPHICS but have no POSITION at all, and asking for it there raises
% "Unrecognized method, property, or field 'Position'".
hasBox = ~isempty(parent) && isgraphics(parent) && isprop(parent, 'Position');
if hasBox && numel(parent.Position) == 4 && all(isfinite(parent.Position))
    position(1) = parent.Position(1) + (parent.Position(3) - position(3))/2;
    position(2) = parent.Position(2) + (parent.Position(4) - position(4))/2;
    position(3) = min(position(3), parent.Position(3));
    position(4) = min(position(4), parent.Position(4));
end
fig = uifigure('Name', 'Sampling rate', ...
    'Position', position, 'WindowStyle', 'modal', 'Visible', 'off');
movegui(fig,'center');
% Four rows, filled in order, with nothing placed by hand. Two earlier attempts
% at this window died in front of the user and are the reason for the note:
%   - 'Layout', [row col] on a child is not accepted on this release. It wants a
%     matlab.ui.layout.GridLayoutOptions object, and a plain [row col] pair
%     raises "Error setting property 'Layout' of class 'Label'".
%   - uiflowlayout cannot take a uibuttongroup as its parent here at all:
%     "Undefined function 'uiflowlayout' for input arguments of type
%     'matlab.ui.container.ButtonGroup'". So there is no button group, and the
%     presets are a plain row of buttons under a label.
grid = uigridlayout(fig, [4 1]);
grid.RowHeight = {26, 24, 30, '1x'};
grid.Padding = [5 5 5 5];
grid.RowSpacing = 6;

top = uigridlayout(grid, [1 3]);
top.ColumnWidth = {110, 80, '1x'};
top.Padding = [0 0 0 0];
uilabel(top, 'Text', 'Sampling rate');
field = uieditfield(top, 'text', 'Value', '', ...
    'ValueChangedFcn', @(~, ~) updateOk());
uilabel(top, 'Text', 'Hz', 'FontColor', [0.4 0.4 0.4]);

uilabel(grid, 'Text', 'Common rates:', 'FontColor', [0.35 0.35 0.35]);

% The rates a recording actually gets sampled at. Change this list to suit the
% instrument; a preset is one click that fills the field and accepts it.
labels = {'4 kHz', '8 kHz', '10 kHz', '16 kHz', ...
          '22 kHz', '48 kHz', '88 kHz', '96 kHz'};
rates  = [4000 8000 10000 16000 22050 48000 88200 96000];

presets = uigridlayout(grid, [1 numel(labels)]);
presets.ColumnWidth = repmat({'1x'}, 1, numel(labels));
presets.Padding = [0 0 0 0];
buttons = gobjects(1, numel(labels));
for k = 1:numel(labels)
    buttons(k) = uibutton(presets, 'Text', labels{k}, ...
        'ButtonPushedFcn', @(~, ~) pick(rates(k)));
end

% What came back, and whether it came back because someone said yes
s = struct('Value', [], 'Confirmed', false);

    function pick(rate)
    %PICK  A preset is a whole answer, not half of one: it fills the field and
    %   accepts in the same click. It has to fill the field first, because
    %   CONFIRM reads the field and not this - so a preset that only stored its
    %   own value would have been refused for leaving the box empty.
        field.Value = num2str(rate);
        confirm();
    end

    function confirm()
    %CONFIRM  Take the field, but only if it holds a positive finite number.
        value = str2double(strtrim(field.Value));
        if ~isfinite(value) || value <= 0
            return;
        end
        s.Value = value;
        s.Confirmed = true;
        closeDialog();
    end

    function cancel()
    %CANCEL  Declined, whether pressed or closed with the window button.
        s.Value = [];
        s.Confirmed = false;
        closeDialog();
    end

    function closeDialog()
        if isvalid(fig)
            delete(fig);
        end
    end

    function updateOk()
    %UPDATEOK  OK follows the field: greyed while it holds nothing usable.
        value = str2double(strtrim(field.Value));
        if isfinite(value) && value > 0
            okButton.Enable = 'on';
        else
            okButton.Enable = 'off';
        end
    end

bottom = uigridlayout(grid, [1 3]);
bottom.ColumnWidth = {'1x', 110, 110};
bottom.Padding = [0 0 0 0];
uilabel(bottom, 'Text', '');
okButton = uibutton(bottom, 'Text', 'OK', ...
    'ButtonPushedFcn', @(~, ~) confirm(), 'Enable', 'off');
uibutton(bottom, 'Text', 'Cancel', 'ButtonPushedFcn', @(~, ~) cancel());

if ~isempty(suggested)
    field.Value = char(suggested);
end
updateOk();
fig.CloseRequestFcn = @(~, ~) cancel();

% The wait. Everything above only BUILDS the question.
%
% The window is shown only here, once it is finished. UIFIGURE is visible from
% the moment it is created, so before this a half-built question was on screen
% with no presets on it yet - and a caller driving the dialog from a timer could
% click it away mid-construction, leaving this function writing properties to a
% figure that no longer existed. Showing it last also means nobody sees the
% window before there is something to do with it.
fig.Visible = 'on';
if isvalid(fig)
    waitfor(fig);
end

if s.Confirmed
    sampleRate = s.Value;
else
    sampleRate = [];
end
end
