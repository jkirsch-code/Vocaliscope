# BayesianPitchTracker — BF0NLS

Bayesian fundamental frequency estimation using the harmonic model with
Hidden Markov Model smoothing (BF0NLS algorithm).

## Reference

L. Shi, J. K. Nielsen, J. R. Jensen, M. A. Little, and M. G. Christensen,
"Robust Bayesian Pitch Tracking Based on the Harmonic Model,"
*IEEE/ACM Trans. Audio, Speech, and Lang. Process.*, vol. 27, no. 11,
pp. 1737–1751, Nov. 2019.

- [Published](https://ieeexplore.ieee.org/abstract/document/8771212)
- [Preprint](https://www.researchgate.net/publication/334660108)

## Original Code

BF0NLS MATLAB implementation by Liming Shi, Aalborg University.
Repository: https://github.com/MalcomX/2DBarcodeDetection (BF0NLS_MATLAB folder)
Contact: ls@create.aau.dk

## Dependencies

- Signal Processing Toolbox (`levinson`, `resample`, `filter`)
- Statistics and Machine Learning Toolbox (`normpdf`)

## Usage

```matlab
[f0, time_s, periodicity] = PitchTracker.BayesianPitchTracker.bf0nls(y, fs);

% With options
opts.f0_min = 70;
opts.f0_max = 400;
opts.frameLength_s = 0.03;
opts.hopLength_s = 0.01;
opts.voicingThresh = 0.5;
opts.prewhitening = false;
opts.maxHarmonics = 10;
[f0, time_s, periodicity] = PitchTracker.BayesianPitchTracker.bf0nls(y, fs, opts);

% Full result struct
[f0, time_s, periodicity, result] = PitchTracker.BayesianPitchTracker.bf0nls(y, fs);
```

## Inputs

| Parameter | Description | Default |
|-----------|-------------|---------|
| `y` | Audio signal (column or row vector) | — |
| `fs` | Sampling rate (Hz) | — |
| `opts.f0_min` | Minimum F0 (Hz) | 70 |
| `opts.f0_max` | Maximum F0 (Hz) | 400 |
| `opts.frameLength_s` | Frame length (s) | 0.03 |
| `opts.hopLength_s` | Hop length (s) | 0.01 |
| `opts.voicingThresh` | Voicing probability threshold | 0.5 |
| `opts.prewhitening` | Enable prewhitening | false |
| `opts.maxHarmonics` | Maximum harmonic order | 10 |

## Outputs

| Output | Description |
|--------|-------------|
| `f0` | Pitch contour (1×N, Hz), NaN where unvoiced |
| `time_s` | Frame center times (1×N, seconds) |
| `periodicity` | Voicing probability (1×N, 0–1) |
| `result` | Struct with `tt`, `ff`, `oo`, `vv`, `best_ff`, `best_order` |

## Algorithm Notes

- Signal is resampled to 16 kHz internally (algorithm is tuned for this rate)
- Uses a Bayesian harmonic model with HMM smoothing across frames
- Prewhitening is available for colored noise environments (increases `maxHarmonics` to 30)
- The `std_pitch` parameter scales automatically with hop size

## License

GNU General Public License v2. See [LICENSE](LICENSE).
