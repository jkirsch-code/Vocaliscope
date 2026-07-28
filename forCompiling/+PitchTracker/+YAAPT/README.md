# YAAPT — Yet Another Algorithm for Pitch Tracking

Spectral/temporal pitch tracking for robust fundamental frequency estimation
in both high-quality and telephone speech.

## Reference

S. A. Zahorian and H. Hu, "A spectral/temporal method for robust fundamental
frequency tracking," *J. Acoust. Soc. Am.*, 123(6), 4559-4571, June 2008.

## Original Code

Authors: Hongbing Hu and Stephen A. Zahorian
Speech Communication Laboratory, SUNY Binghamton

- Official source: https://www.ws.binghamton.edu/zahorian/yaapt.htm
- Archived: https://web.archive.org/web/20250613152848/https://www.ws.binghamton.edu/zahorian/yaapt.htm

The program is distributed as free software by the Speech Communication
Laboratory at the State University of New York at Binghamton.

## Usage

```matlab
[f0, time_s, periodicity] = PitchTracker.YAAPT.yaapt(y, fs);

% With options
opts.f0_min = 60;
opts.f0_max = 400;
opts.frame_length = 25;    % ms
opts.frame_space = 10;     % ms
opts.fft_length = 8192;
opts.voiced_unvoiced = true;
opts.corrections = false;
[f0, time_s, periodicity] = PitchTracker.YAAPT.yaapt(y, fs, opts);
```

## Inputs

| Parameter | Description | Default |
|-----------|-------------|---------|
| `y` | Audio signal (column or row vector) | — |
| `fs` | Sampling rate (Hz) | — |
| `opts.f0_min` | Minimum F0 (Hz) | 60 |
| `opts.f0_max` | Maximum F0 (Hz) | 400 |
| `opts.frame_length` | Frame length (ms) | 25 |
| `opts.frame_space` | Frame spacing (ms) | 10 |
| `opts.fft_length` | FFT length | 8192 |
| `opts.voiced_unvoiced` | Enable V/UV decisions | true |
| `opts.corrections` | Apply ptch_fix corrections (all-voiced mode) | false |

## Outputs

| Output | Description |
|--------|-------------|
| `f0` | Pitch contour (1×N, Hz), NaN where unvoiced |
| `time_s` | Frame center times (1×N, seconds) |
| `periodicity` | Voicing decision (1×N), 1=voiced, 0=unvoiced |

## Algorithm

YAAPT combines spectral (SHC-based) and temporal (NCCF-based) pitch
tracking with dynamic programming for final path selection. The pipeline:

1. Nonlinear preprocessing (squaring + bandpass filtering)
2. NLFER-based voiced/unvoiced detection
3. Spectral pitch tracking via Spectral Harmonic Correlation (SHC)
4. Temporal pitch tracking via Normalized Cross-Correlation (NCCF)
5. Candidate refinement combining spectral and temporal estimates
6. Dynamic programming for optimal pitch path

## Dependencies

- Signal Processing Toolbox (`fir1`, `findpeaks`, `xcorr`)

## License

Distributed as free software by the Speech Communication Laboratory,
SUNY Binghamton. See [LICENSE](LICENSE).
