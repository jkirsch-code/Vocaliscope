function [cpps, times, cep_smooth, fitObjsSmooth, cepstrogram, cpp, fitObjs] = compute_CPPs(signal, fs, ResampleFs, UsePreemph, windowType,WindowLength, TimeStep, TimeAvgWin, QuefrAvgWin, F0min, F0max, FitType, Robust,lowerQuefrencyLimit,upperQuefrencyLimit,useParfor)
% Compute smoothed Cepstral Peak Prominence (CPPS) and raw CPP per frame
% 
%
% Syntax:
%   [cpps, times, cep_smooth, fitObjsSmooth, cepstrogram]               = compute_CPPs(audio, fs, options)
%
%   When called with cpp output, also cpp and fitObjs are calculated,
%   which takes longer due to fitting
%
%   [cpps, times, cep_smooth, fitObjsSmooth, cepstrogram, cpp, fitObjs] = compute_CPPs(audio, fs, options)
%
% Required Inputs:
%   signal - input signal (Nx1 or 1xN double)
%   fs     - Sample rate (Hz)
%
% Outputs:
%   cpps          - CPPS values per frame (1xN dB)     [always]
%   times         - Frame center times (1xN seconds)   [always]
%   cep_smooth    - smoothed cesptrogram               [always]
%   fitObjsSmooth - fit object for each frame of the smoothed cepstrum [always]
%   cepstrogram   - non-smoothed cepstrogram          [always]
%   cpp           - CPP values per frame (1xN dB)      [nargout>5 only]
%   fitObjs       - CPP fit object for each frame of the original cesptrum [nargout>5 only]
%
% Name-Value Parameters (Praat PowerCepstrogram defaults):
%   ResampleFs          = 22050 Hz   - Analysis sample rate
%   UsePreemph          = true       - 50 Hz highpass preemphasis
%   WindowLength        = 0.04644 s  - Analysis window length. this equals 1024 samples at 22050 Hz resampling rate
%   TimeStep            = 0.002 s    - Frame shift
%   TimeAvgWin          = 0.01 s     - Time domain smoothing (CPPS only)
%   QuefrAvgWin         = 0.001 s    - Quefrency smoothing (CPPS only)
%   F0min               = 50 Hz      - Minimum F0 for peak search
%   F0max               = 500 Hz     - Maximum F0 for peak search
%   FitType             = 'linear'   - Baseline fit: 'linear', 'poly2', 'exponential'
%   Robust              = 'bisquare' - Robust regression: 'off', 'LAR', 'bisquare'
%   lowerQuefrencyLimit = 0.001 s - Fit area of quefrency. this should not be larger than the first Rhamonic (1/fo) and 2 to 3 more Rhamonics
%   upperQuefrencyLimit = inf
%   useParfor           = true       - useful if this function is used in an outer parfor, then inner parfor can be disabled
%
% Algorithm:
%   CPP:  Raw cepstrum → peak prominence (F0 range)
%   CPPS: Time smoothed → quefrency smoothed → peak prominence
%
% Example:
%   [cpps, t, cpp] = compute_cpps(y, 44100);
%   rms(cpps)  % Matches Praat "Get CPPS (auto)"
%
% Requires: Curve Fitting Toolbox (fit()), Signal Processing Toolbox

    arguments
        signal (:,1) double {mustBeReal, mustBeFinite(signal)}
        fs (1,1) double {mustBePositive, mustBeInteger}
        ResampleFs (1,1) double {mustBePositive} = 22050
        UsePreemph logical = true
        windowType string {mustBeMember(windowType, ["rectwin", "hann", "hamming", "barthannwin", "bartlett", "blackman", "blackmanharris", "bohmanwin", "chebwin", "flattopwin", "gausswin", "nuttallwin", "parzenwin", "triang"])} = "hamming"
        WindowLength (1,1) double {mustBePositive} = 0.04644
        TimeStep (1,1) double {mustBePositive} = 0.002
        TimeAvgWin (1,1) double {mustBePositive} = 0.01
        QuefrAvgWin (1,1) double {mustBePositive} = 0.001
        F0min (1,1) double {mustBePositive} = 50
        F0max (1,1) double {mustBePositive} = 500
        FitType string {mustBeMember(FitType, ["poly1", "exp1", "poly2"])} = "poly1"
        Robust string {mustBeMember(Robust, ["off", "LAR", "bisquare"])} = "bisquare"
        lowerQuefrencyLimit (1,1) double {mustBePositive} = 0.001
        upperQuefrencyLimit (1,1) double {mustBePositive} = inf
        useParfor logical = true
    end

    

    % Performance optimization
    compute_cpp = nargout > 5;

    % Resample to analysis rate
    if fs ~= ResampleFs
        signal = resample(signal, ResampleFs, fs);
        fs = ResampleFs;
    end

    % Preemphasis with filtfilt padding
    orig_len = length(signal);
    if UsePreemph
        [b, a] = butter(1, 50/(fs/2), 'high');
        pad_len = 3 * max(length(a), length(b));
        audio_pad = [zeros(pad_len,1); signal; zeros(pad_len,1)];
        audio_pad = filtfilt(b, a, audio_pad);
        signal = audio_pad(pad_len+1 : pad_len+orig_len);
    end

    % Frame parameters
    Nwin = round(WindowLength * fs);
    hop = round(TimeStep * fs);
    nframes = floor((length(signal) - Nwin) / hop) + 1;
    times = ((0:nframes-1)' * TimeStep + WindowLength/2);

    switch windowType
        case "hamming"
            win = hamming(Nwin);
        case {"hann","hanning"}
            win=hann(Nwin);
        case "rectwin"
            win=ones(Nwin,1);
        case "barthannwin"
            win=barthannwin(Nwin);
        case "bartlett"
            win=bartlett(Nwin);
        case "blackman"
            win=blackman(Nwin);
        case "blackmanharris"
            win=blackmanharris(Nwin);
        case "bohmanwin"
            win=bohmanwin(Nwin);
        case "chebwin"
            win=chebwin(Nwin);
        case "flattopwin"
            win=flattopwin(Nwin);
        case "gausswin"
            win=gausswin(Nwin);
        case "nuttallwin"
            win=nuttallwin(Nwin);
        case "parzenwin"
            win=parzenwin(Nwin);
        case "triang"
            win=triang(Nwin);
        otherwise
            win=ones(Nwin,1);
    end


    fftlen = 2^nextpow2(Nwin);

    quefr_len = floor(Nwin / 2);
    cepstrogram = zeros(quefr_len,nframes);

    for i = 1:nframes
        frame = signal((i-1)*hop+(1:Nwin)) .* win;
        
        if all(frame==0)
            cepstrogram(:,i)=0;
        else
            %ps = abs(fft(frame, fftlen)).^2; 
            %ps = ps(1:fftlen/2+1);
            %cep_full = real(ifft(10*log10(ps), fftlen));
            cep_full = abs(fft(10*log10(abs(fft(frame,fftlen)).^2))).^2;
            cep_full = cep_full(1:fftlen/2+1);
            cep_full(cep_full==0)=0;
            cepstrogram(:,i) = cep_full(2:quefr_len+1);  % Positive quefrency, skipping the dc component
        end
    end


    % CPP: raw cepstrogram (per frame)
    if compute_cpp
        cpp = zeros(nframes,1);
        fitObjs = cell(nframes,1);
        if ~useParfor
            for i = 1:nframes % could also use parfor
                [cpp(i),fitObjs{i}] = single_cpp(cepstrogram(:,i), F0min, F0max, fs, FitType, Robust,lowerQuefrencyLimit,upperQuefrencyLimit);
            end
        else
            parfor i = 1:nframes % could also use parfor
                [cpp(i),fitObjs{i}] = single_cpp(cepstrogram(:,i), F0min, F0max, fs, FitType, Robust,lowerQuefrencyLimit,upperQuefrencyLimit);
            end
        end
    end

    time_win = round(TimeAvgWin/TimeStep);
    quefr_win = round(QuefrAvgWin*fs);
    
    cep_smooth_time = movmean(cepstrogram, time_win, 2, 'omitnan');  % Time dim
    cep_smooth = movmean(cep_smooth_time, quefr_win, 1, 'omitnan');  % Quefr dim
    
    % CPPS per smoothed frame
    cpps = zeros(nframes,1);
    fitObjsSmooth = cell(nframes,1);
    if ~useParfor
        for i = 1:nframes
            [cpps(i),fitObjsSmooth{i}] = single_cpp(cep_smooth(:,i), F0min, F0max, fs, FitType, Robust,lowerQuefrencyLimit,upperQuefrencyLimit);
        end
    else
        parfor i = 1:nframes
            [cpps(i),fitObjsSmooth{i}] = single_cpp(cep_smooth(:,i), F0min, F0max, fs, FitType, Robust,lowerQuefrencyLimit,upperQuefrencyLimit);
        end
    end

end

function [cpp_val, fitobj] = single_cpp(cep, F0min, F0max, fs, FitType, Robust,lowerQuefrencyLimit,upperQuefrencyLimit)
    

    

    if all(cep==0)
        cpp_val=NaN;
        fitobj=[];
        return;
    end

    cep=10*log10(cep); % to dB

    q = (1:length(cep))' / fs;  % Q STARTS AT 1/fs (no DC!)
    
    % PEAK SEARCH: F0 range only
    q_peak_range = (1/F0max <= q) & (q <= 1/F0min);
    [peakval, peakidx] = max(cep(q_peak_range));
    if isempty(peakidx), cpp_val = NaN; return; end
    
    peak_idx = find(q_peak_range, 1) + peakidx - 1;
    
    % BASELINE FIT: FIXED Praat/Hillenbrand: 0.001–0.05s
    q_fit_range = (lowerQuefrencyLimit <= q) & (q <= upperQuefrencyLimit);
    qvec = find(q_fit_range);
    if length(qvec) < 5
        cpp_val = NaN;
        return;
    end
    
    x = q(qvec); y = cep(qvec);

    x=x(:); y=y(:);

    notNaN=~isnan(x) & ~isnan(y);

    x=x(notNaN); y=y(notNaN);

    if numel(x)<4
        cpp_val=NaN;
        fitobj=[];
        return;
    end
    

    warning("off",'curvefit:fit:iterationLimitReached');
        fitobj = fit(x, y, FitType, 'Robust', Robust);
    warning("on",'curvefit:fit:iterationLimitReached');

    baseline = feval(fitobj, q(peak_idx));
    
    % SAFE CPP: max(0, peak-baseline)
    %prominence = max(peakval - baseline, 0);
    %cpp_val = 20 * log10(prominence + eps);
    cpp_val = peakval-baseline;
end
