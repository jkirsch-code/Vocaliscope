function fig=pianoGUI()
% PIANOGUI - Interactive Virtual Piano in MATLAB
%
%   pianoGUI launches an interactive virtual piano with the following features:
%
%   Features:
%     • Five octaves of piano keys (white and black).
%     • Adjustable reference tuning for A4 (430–450 Hz, default 440 Hz).
%     • Click on a key to play a piano-like synthesized tone.
%     • Frequency tooltips and dynamic Hz labels below each key.
%     • Black keys provide temporary gray highlight on press.
%     • Scrollable panel if the keyboard width exceeds the figure size.
%
%   Piano sound model:
%     • Custom additive synthesis with harmonics and slight detuning.
%     • Short attack and exponential decay envelopes to simulate piano strikes.
%     • Added "hammer noise" for realism.
%     • Smooth fade-out at the end of each tone to avoid clicks.
%
%   Usage:
%     >> pianoGUI
%
%   After running, select the tuning for A4 using the slider at the top.
%   Click a key to generate the corresponding tone; the Hz is shown below
%   the key and in a tooltip.
%
%   Author: Jonas Kirsch / LMU Munich
%   Date: August 2025
%
%   See also: SOUND, UIFIGURE, UISLIDER, UIBUTTON, UILABEL

    % ========= SETTINGS =========
    SampleRate     = 44100;  % Sampling rate [Hz]
    NoteDuration   = 0.5;    % Duration of each piano tone [s]
    startOctave    = 2;      % First octave to display (e.g., 2 or 3)
    numOctaves     = 5;      % Number of octaves
    whiteKeyHeight = 150;    % Height of white keys in pixels
    % ============================

    % --- Main window with Grid Layout ---
    fig = uifigure('Name','Piano (evenly tempered)','Position',[100 100 1200 250],'Visible','off');
    gl = uigridlayout(fig,[2,1],...
        'RowSpacing',0,'Padding',[0 0 0 0]);
    gl.RowHeight = {50,whiteKeyHeight+50};  
    gl.ColumnWidth = {'1x'};

    % --- Slider + Label (Top row) ---
    glTop = uigridlayout(gl,[1,3],...
        'RowSpacing',0,'ColumnSpacing',5,'Padding',[5 5 5 5]);
    glTop.ColumnWidth = {'fit','fit',200};
    uilabel(glTop,'Text','Reference Frequency A4:','FontWeight','bold');
    freqLabel = uilabel(glTop,'Text','440 Hz','FontWeight','bold','HorizontalAlignment','center');
    refSlider = uislider(glTop,...
        'Limits',[430 450], ...
        'Value',440, ...
        'Step',1, ...
        'ValueChangedFcn',@(src,evt) updateAll(src.Value), ...
        'ValueChangingFcn',@(src,evt) updateLabelAndAll(evt.Value),...
        'MinorTicks',430:450,'MajorTicks',430:5:450);

    % Arrays to keep Button and Frequency-Label handles
    allButtons  = matlab.ui.control.Button.empty;
    allHzLabels = matlab.ui.control.Label.empty;

    % --- Scrollable Piano Panel (Bottom row) ---
    keyPanel = uipanel(gl,'Scrollable','on','BorderType','none');

    % Notes and semitone offsets relative to A4=440Hz
    [noteNames,semitoneOffsets] = generateNoteOffsets(startOctave,numOctaves);
    whiteSequence = {'C','D','E','F','G','A','B'};
    blackInfo = { 'C#', 1; 'D#', 2; 'F#', 4; 'G#', 5; 'A#', 6};

    whiteKeyWidth = 40;  
    blackKeyWidth = 25;  
    blackKeyHeight = 90;
    offsetX = 20; offsetY = 50;

    xPos = offsetX;
    whitePositions = containers.Map;

    % ----- Create White Keys -----
    for o = startOctave:(startOctave+numOctaves-1)
        for wi = 1:numel(whiteSequence)
            noteName = sprintf('%s%d',whiteSequence{wi},o);
            idx = find(strcmp(noteNames,noteName));

            % White key button
            wb = uibutton(keyPanel,'Text',noteName,...
                'BackgroundColor',[1 1 1],'FontSize',12,...
                'Position',[xPos offsetY whiteKeyWidth whiteKeyHeight]);
            wb.UserData = semitoneOffsets(idx);
            wb.ButtonPushedFcn = @(src,evt) playNoteWithRef(src);
            allButtons(end+1) = wb;
            whitePositions(noteName) = wb.Position;

            

            % Frequency label below the key
            lbl = uilabel(keyPanel,'Text','',...
                'HorizontalAlignment','center','FontSize',12,...
                'Position',[xPos offsetY-15 whiteKeyWidth 15]);
            lbl.UserData = semitoneOffsets(idx);
            allHzLabels(end+1) = lbl;

            if strcmp(noteName,'A4')
                lbl.BackgroundColor = [245, 132, 45]/255;  % hellblau
            end

            xPos = xPos + whiteKeyWidth;
        end
    end

    % ----- Create Black Keys -----
    for o = startOctave:(startOctave+numOctaves-1)
        for bi = 1:size(blackInfo,1)
            blackName = blackInfo{bi,1};
            precedingWhiteIndex = blackInfo{bi,2};
            precedingWhiteName = sprintf('%s%d',whiteSequence{precedingWhiteIndex},o);
            if isKey(whitePositions,precedingWhiteName)
                wbPos = whitePositions(precedingWhiteName);
                bx = wbPos(1) + whiteKeyWidth - blackKeyWidth/2;
                by = wbPos(2) + (whiteKeyHeight - blackKeyHeight);
                noteName = sprintf('%s%d',blackName,o);
                idx = find(strcmp(noteNames,noteName));

                % Black key button
                bb = uibutton(keyPanel,'Text',noteName,...
                    'BackgroundColor',[0 0 0],'FontColor',[1 1 1],...
                    'FontSize',10,...
                    'Position',[bx by blackKeyWidth blackKeyHeight]);
                bb.UserData = semitoneOffsets(idx);
                bb.ButtonPushedFcn = @(src,evt) playNoteWithRef(src);
                allButtons(end+1) = bb;

                % Frequency label below black key
                lbl = uilabel(keyPanel,'Text','',...
                    'HorizontalAlignment','center','FontSize',9,...
                    'FontColor',[0.2 0.2 0.2],...
                    'BackgroundColor',[1 1 1],... % white background
                    'Position',[bx by-15 blackKeyWidth 15]);
                lbl.UserData = semitoneOffsets(idx);
                allHzLabels(end+1) = lbl;
            end
        end
    end

    % Initialize frequency labels & tooltips
    updateAll(refSlider.Value);

    movegui(fig,'center');

    drawnow;

    fig.Visible='on';

    % ======= CALLBACKS =======
    function updateLabelAndAll(val)
        freqLabel.Text = sprintf('%.0f Hz',val);
        updateAll(val);
    end
    function updateAll(currentRef)
        % Update tooltips on keys and Hz labels below
        for i = 1:numel(allButtons)
            btn = allButtons(i);
            semiOffset = btn.UserData;
            freq = currentRef * 2^(semiOffset/12);
            btn.Tooltip = sprintf('%.2f Hz', freq);
        end
        for i = 1:numel(allHzLabels)
            lbl = allHzLabels(i);
            semiOffset = lbl.UserData;
            freq = currentRef * 2^(semiOffset/12);
            lbl.Text = sprintf('%.1f', freq);
        end
    end
    function playNoteWithRef(btn)
        % Temporary color feedback for black keys
        if isequal(btn.BackgroundColor,[0 0 0])
            btn.BackgroundColor = [0.3 0.3 0.3];
        end

        refA4 = refSlider.Value;
        freq = refA4 * 2^(btn.UserData/12);

        y = makePianoTone(freq,SampleRate,NoteDuration);   % Generate piano-like tone
        sound(y,SampleRate);

        if isequal(btn.BackgroundColor,[0.3 0.3 0.3])
            pause(0.1);
            btn.BackgroundColor = [0 0 0];
        end
    end
end

% ==== Helper functions ====
function [names,semitones] = generateNoteOffsets(startOctave,numOctaves)
    % Returns note names and semitone offsets relative to A4=440Hz
    octaveNotes = {'C','C#','D','D#','E','F','F#','G','G#','A','A#','B'};
    names = {}; semitones = [];
    for o = startOctave:(startOctave+numOctaves-1)
        for k = 1:numel(octaveNotes)
            noteName = sprintf('%s%d',octaveNotes{k},o);
            names{end+1} = noteName; %#ok<AGROW>
            semitones(end+1) = (o - 4)*12 + (k - 10); % offset relative to A4
        end
    end
end

function y = makePianoTone(freq,Fs,Dur)
    % Generate a piano-like tone with harmonics, detuning, noise, and envelope
    
    t = (0:1/Fs:Dur);
    
    % === Amplitude Envelopes ===
    att = round(0.005*Fs); % 5 ms attack
    env1 = [linspace(0,1,att), exp(-2*(t(att+1:end)))]; % slow decay
    env2 = [linspace(0,1,att), exp(-5*(t(att+1:end)))]; % faster decay
    env1 = env1(1:numel(t));
    env2 = env2(1:numel(t));
    
    % === Inharmonic Partials ===
    beta = 1.001;
    y = ...
        0.7*sin(2*pi*freq*t)           .* env1 + ...
        0.3*sin(2*pi*(2*freq*beta)*t)  .* env2 + ...
        0.2*sin(2*pi*(3*freq*beta^2)*t).* env2 + ...
        0.1*sin(2*pi*(4*freq*beta^3)*t).* env2;
    
    % === Detuned Strings (±5 cents) ===
    detuneUp   = 2^(+5/1200);
    detuneDown = 2^(-5/1200);
    y = y ...
      + 0.15*sin(2*pi*freq*detuneUp*t)   .* env1 ...
      + 0.15*sin(2*pi*freq*detuneDown*t) .* env1;
    
    % === Hammer Noise (short burst of noise) ===
    noise = 0.001*randn(size(t)) .* exp(-80*t);
    y = y + noise;
    
    % === Fade-out at the end to avoid clicking ===
    fadeLen = round(0.1*Fs);
    fadeWin = linspace(1,0,fadeLen);
    y(end-fadeLen+1:end) = y(end-fadeLen+1:end).*fadeWin;

     % === Fade-out at the start to avoid clicking ===
    fadeLen = round(0.001*Fs);
    fadeWin = linspace(0,1,fadeLen);
    y(1:fadeLen) = y(1:fadeLen).*fadeWin;
    
    % Normalize
    y = y ./ max(abs(y)+eps);
end
