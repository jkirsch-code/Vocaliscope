# Vocaliscope

**An open-source MATLAB App Designer application for integrated analysis of multi-channel voice recordings.**

[![License: GPL v3 or later](https://img.shields.io/badge/License-GPL--3.0--or--later-blue.svg)](LICENSE)
[![MATLAB 2026a+](https://img.shields.io/badge/MATLAB-2026a%2B-orange.svg)](https://www.mathworks.com)

---

## Overview

Vocaliscope is a unified environment for loading, synchronizing, processing, and analyzing multi-modal voice data. It supports heterogeneous data sources — acoustic signals, electroglottographic (EGG) measurements, and high-speed video-derived signals such as glottal area waveforms (GAW) and Phonovibrograms (PVG) — within a single, interactive interface.

The software consolidates functionality typically distributed across multiple tools, enabling reproducible multi-channel voice analysis without programming expertise.

## Features

### Data Import & Export

- **Audio formats:** `.wav`, `.mp3`, `.flac`, `.ogg`, `.opus`, `.m4a`, `.mp4`, `.aifc`, `.aiff`, `.aif`, `.au`
- **Text/spreadsheet formats:** `.txt`, `.csv`, `.xlsx`, `.xls`, `.xlsm`, `.xlsb`
- **Glottal area waveforms:** `.gaw` (Glottis Analysis Tools format [25])
- **Phonovibrogram images:** `.png`, `.bmp`, `.jpg`, `.jpeg`, `.jp2`
- **Photron high-speed camera:** `.wvd`, `.csv` (Type-A) [13]
- **Session files:** `.mat` (Vocaliscope format for resuming analysis)
- **Export:** `.xlsx` (results + settings), `.wav` (multi-channel, 32/64-bit), `.mat` (full session data)

### Signal Processing

- **Change source type:** Switch channel type (Audio, EGG, Pressure, Flow, GAW, etc.) via right-click menu
- **Unit conversion:** Pa ↔ cmH₂O (temperature-dependent), dB ↔ Magnitude
- **Basic editing:** Set to constant values (zero, min/max/mean/median), add or subtract values, delete and concatenate, overwrite with linear ramp, differential operations (set extrema to zero), delete inverse selection, convert leading zeros to lag, padding (pre/post/both). Applies to single channel, all displayed channels, or all available channels
- **Calibration:** By absolute difference of start/end of marked region, by summed values inside marked region, by SPL inside marked region, or by comparison of two channels

### Visualization

- **Synchronized multi-channel display** in time domain
- **Time-frequency view** via fast Continuous Wavelet Transform (fCWT [5])
- **Interactive region selection** with playback (diotic, selected channels only)
- **Customizable channel colors** (per source type, with color picker)
- **Spectral view** with logarithmic amplitude and peak information overlay

### Channel Processing & Analysis Tools

All tools below are accessible via the right-click context menu on any channel axis.

<details>
<summary><b>Filter Toolbox</b></summary>

Interactive GUI with live preview in time and spectrum domains, plus filter response visualization (magnitude, phase delay, group delay) and audio preview (listen to filtered or original signal).

**Non-spectral smoothing:**
- Moving mean, Moving median
- Configurable window length
- Option to leave non-outliers untouched

**IIR spectral filtering:**
- Response types: lowpass, highpass, bandpass, bandstop, comb
- Design methods: Butterworth, Chebyshev Type I, Chebyshev Type II, Elliptic
- Full frequency specifications (passband/stopband frequencies)
- Full magnitude specifications (passband/stopband attenuation in dB)
- Forward and backward filtering option
- Configurable padding method
- Preserve zero values and clip below option
</details>

<details>
<summary><b>Resampling</b></summary>

Interactive GUI with before/after preview.

- Anti-aliasing resampling to a new sample rate, or time-vector-only mode (corrects wrong sample rate metadata without resampling the data — useful when e.g. a GAW file was saved at 100 kHz but the actual data is 20 kHz)
- Interpolation methods: Linear, Shape-preserving piecewise cubic, Spline
- Scope: single channel, all channels, or all channels above a specified sample rate threshold
</details>

<details>
<summary><b>Praat Playground</b></summary>

Comprehensive Praat analysis window via praatMEX [21] with full parameter control and live preview. Eight analysis categories:

- **Pitch:** Filtered/unfiltered cross-correlation, autocorrelation, SHS, SPINET — with voicing thresholds, octave costs, very accurate mode, fill-missing interpolation
- **Formant:** Burg, Keep all, Willems, Robust methods — with formant tracking, max formants, pre-emphasis
- **Intensity:** Min pitch, window length, subtract mean
- **Harmonicity/HNR/GNE:** Time step, pitch floor, silence threshold, periods per window (HNR); min/max frequency, bandwidth (GNE)
- **Jitter:** Absolute, local, local absolute, relative, RAP, PPQ5, ddp — with configurable period limits and window settings
- **Shimmer:** Absolute, local, local absolute, relative, APQ5, apq11, dda — with configurable amplitude factor and window settings
- **CPP/CPPS:** Pre-emphasis, trend removal, quefrency smoothing, peak interpolation (parabolic, cubic, sinc), robust fitting
- **PointProcess:** Periodic CC, periodic peaks, extrema, periodic direct methods

Creates one or more new channels per analysis type.
</details>

<details>
<summary><b>SPL Channel Creation</b></summary>

Creates a new Sound Pressure Level channel from an audio signal using MATLAB's `splMeter`.

- **Weighting:** dB(A), dB(C), dB(Z)
- **Time constant:** Fast (125 ms) or Slow (1 s)
- **Reference pressure:** User-configurable (default: 20 µPa)
- **Output metrics:** Time-weighted sound level, Equivalent-continuous sound level (LEQ), Peak sound level, Maximum time-weighted sound level
- **Report interval:** Configurable integration interval for LEQ/max metrics
- Live preview of the SPL curve
</details>

<details>
<summary><b>Fundamental Frequency Channel</b></summary>

Creates a new f₀ contour channel with selectable pitch estimation algorithm. 17+ methods available:

- **MATLAB built-in:** NCF, PEF, CEP, LHS, SRH
- **Third-party:** SWIPE' [8], SHR [6], YIN [7], Bayesian F0 (BF0NLS) [9], YAAPT [10]
- **Deep learning:** CREPE [27] (DNN capacity: tiny/small/medium/large/full)
- **Praat-based:** Filtered AC, raw AC, raw CC, filtered CC, SHS, SPINET — each with full Praat parameter control (voicing threshold, octave costs, very accurate mode, etc.)

Configurable min/max f₀, window length, overlap, and missing-data interpolation method.
</details>

<details>
<summary><b>Formant Estimation</b></summary>

Creates one or more new formant channels with CWT scalogram background and overlaid formant tracks.

- **TVQCP** [11]: Time-Varying Quasi Closed Phase linear prediction — with L2-norm weighted or unweighted LP
- **Story & Bunton** [12]: Formant estimation adapted for pediatric voice analysis

Configurable number of formants (1–5), f₀ range, window length, and overlap.
</details>

<details>
<summary><b>Sample Entropy (Fourier Descriptors)</b></summary>

Interactive standalone app for computing per-cycle Sample Entropy from EGG signals based on Fourier Descriptors [23].

- Glottal cycle detection via Hilbert phase analysis combined with dEGG peak detection
- Configurable f₀ range, dEGG and Hilbert detection thresholds, phase/magnitude thresholds
- Adjustable number of cycles per SampEn calculation
- Option to export instantaneous cycle frequency as an additional channel
</details>

<details>
<summary><b>Nasalance</b></summary>

Computes nasalance (ratio of nasal to total airflow) from two flow-signal channels.

- Select nasal and oral flow channels from existing data
- Processing methods: Butterworth lowpass filtering or dB(Z)-weighted Moving RMS
- Configurable passband/stopband frequencies and stopband attenuation
- Live 6-panel preview (raw and processed nasal, oral, and nasalance)
</details>

<details>
<summary><b>Mask Creation</b></summary>

Creates a binary mask channel (0/1) from a signal based on amplitude extrema detection.

- Amplitude range slider (0–100%) to define active regions between detected valleys and peaks
- Configurable maximum frequency and minimum extrema prominence
- Persistent settings across sessions
</details>

<details>
<summary><b>Voice Activity Probability</b></summary>

Creates a voice activity probability channel (0–1) using MATLAB's `voiceActivityDetector`.

- Frame window types: Flat-top, Hamming, Hann, Kaiser, Chebyshev, Rectangular
- Configurable frame length, overlap, speech-to-silence and silence-to-speech transition probabilities
- Live preview plot
</details>

<details>
<summary><b>Envelope</b></summary>

Creates amplitude envelope channels (upper, lower, or both) from any signal. 13 methods available:

- **Analytic** (Hilbert transform), **Peak**-based
- **Moving statistics:** RMS, min/max, abs. max, mean, median, STD — each with variants for values above/below a reference
- Configurable center reference method (moving/global mean/median), window length, and window direction (centered/forward/backward)
- Creates one or two new channels depending on envelope selection
</details>

<details>
<summary><b>Vibrato Analysis</b></summary>

Four methods available:
- **VAT** — Hilbert AM/FM via Vibrato Toolbox [20]
- **AVA** — FDM-based Auditory Vibrato Analysis [18]
- **VibratoScope** — Cycle-based analysis [19]
- **CWTf₀** — Continuous Wavelet Transform of f₀ contour (custom implementation using fCWT)

Features: pitch contour + vibrato markers preview, speed/extent plots, method descriptions with references, CSV export, persistent settings.
</details>

<details>
<summary><b>Onset Analysis</b></summary>

Four methods available:
- **VRT** — Vocal Rise Time, energy VAD based (original implementation)
- **POT-Mergell** — Phonation Onset Time (original implementation)
- **POT-Petermann** — Phonation Onset Time (original implementation)
- **VAT** — Voice Attack Time, dEGG-based with EGG+audio (original implementation)

Features: waveform + onset marker preview, intermediate results display, multi-channel comparison, CSV export, persistent settings.
</details>

<details>
<summary><b>Inverse Filtering</b></summary>

- **Aalto Aparat** — QCP and IAIF methods [14]
- **GFM-IAIF** [16], **IOP-IAIF** [17], **MCLP** [33] (with OLAF variants [16], [17])
- Configurable vocal tract order, glottal source order, window length, overlap, leaky integration coefficient
</details>

---

## Voice Parameters

Vocaliscope computes approximately **65 active voice parameters** across multiple categories, organized in a tree structure. Parameters are computed from user-defined segments and exported to `.xlsx`. The parameter set largely follows the Glottis Analysis Tool (GAT) [25]; the source of each formula is cited in the corresponding category below.

<details>
<summary><b>Fundamental Frequency Measures</b></summary>

- Fundamental Frequency (Hz)
- Cycle Duration (s)
- Maximum Harmonic (Hz)
- Minimum Subharmonic (Hz)
</details>

<details>
<summary><b>Amplitude Perturbation Measures</b></summary>

- Mean Shimmer (dB) [36] [37] [42]
- Shimmer (%) [37] [38]
- Amplitude Perturbation Quotient (APQ) [39] [40] [41]
- Amplitude Perturbation Factor (APF) [39] [40] [41]
- Amplitude Variability Index (AVI) [46]
</details>

<details>
<summary><b>Period Perturbation Measures</b></summary>

- Mean Jitter (s) [36] [40]
- Jitter (%) [36] [43]
- Jitter Ratio [43]
- Jitter Factor [44]
- Period Perturbation Quotient (PPQ) [37] [38] [39] [40] [41]
- Period Perturbation Factor (PPF) [39] [40] [41]
- Relative Average Perturbation V1 (RAP) [40] [41] [45]
- Relative Average Perturbation V2 (RAP) [40] [41] [45]
- Period Variability Index (PVI) [38] [40]
</details>

<details>
<summary><b>Energy Perturbation Measures</b></summary>

- Energy Perturbation Quotient (EPQ) [39] [40] [41]
- Energy Perturbation Factor (EPF) [39] [40] [41]
</details>

<details>
<summary><b>Noise Measures</b></summary>

- Spectral Flatness [47] [61]
- Cepstral Peak Prominence I (CPP)
</details>

<details>
<summary><b>Glottal Area Measures</b></summary>

- Open Quotient (OQ) [36] [49]
- Closing Quotient (ClQ) [50]
- Speed Quotient (SQ) [36]
- Speed Index (SI) [36]
- Rate Quotient [36]
- Asymmetry Quotient [51]
- Glottis Gap Index (GGI) [52] [53]
- Plateau Quotient [54]
- Glottal Area Index (GAI) [55]
</details>

<details>
<summary><b>Glottal Area Periodicity Measures</b></summary>

- Amplitude-Periodicity [56]
- Time-Periodicity [56]
</details>

<details>
<summary><b>Glottal Area Derivative Measures</b></summary>

- Maximum Area Declination Rate (MADR) [50] [57] [58] [59]
- Amplitude Quotient [57] [59]
</details>

<details>
<summary><b>Basic Measurements</b></summary>

- Sum [69]
- Mean (arithmetic, harmonic, geometric) [69]
- Standard Deviation (STD) [69]
- Median [69]
- Inter-Quartile Range (IQR) [69]
- Minimum / Maximum [69]
- Root Mean Square (RMS) [69]
- Mode [69]
- Quantiles (5%–95% in 5% steps) [69]
- Skewness [68]
- Kurtosis [68]
- Sum of Square Values [69]
</details>

<details>
<summary><b>Additional Spectral Descriptors</b></summary>

- Spectral Crest [60]
- Spectral Flux [60]
- Spectral Spread [60]
- Spectral Skewness (Spectral Tilt) [60]
- Spectral Kurtosis [60]
- Spectral Centroid [60]
- Spectral Entropy [60]
- Spectral Slope [60]
- Spectral Decrease [60]
- Spectral Rolloff Point [60]
- Harmonic Ratio [60]
- Harmonic-to-Noise Ratio (HNR) via cross-correlation [48]
- Signal-to-Noise Ratio (SNR, dB carrier) [62]
</details>

<details>
<summary><b>Psychoacoustic Measures</b></summary>

- Acoustic Loudness (ISO 532-1 stationary loudness) [64]
- Acoustic Fluctuation [66]
- Acoustic Sharpness (DIN 45692) [65]
- Acoustic Roughness [67]
</details>

<details>
<summary><b>Others</b></summary>

- Zero Crossing Rate [60]
- Sample Entropy (time domain) [23]
- Cycle-based Spectral Sample Entropy [23]
- Sound Pressure Level (SPL: dB(A), dB(C), dB(Z)) [63]
- RAP for cycle energy [40] [41] [45]
- RAP for cycle range [40] [41] [45]
- Energy Variability Index (EVI) [46]
- Glottal-to-Noise Excitation Ratio (GNE) v2 [22]
- Cepstral Peak Prominence Smoothed v3 (CPP(s))
</details>

<details>
<summary><b>Planned Parameters</b> (not yet available)</summary>

The following parameters are planned for a future release and are not yet available:

**Mechanical Measures:**
- Stiffness (1/s)
- Peak Closing Velocity (px/s)
- Peak Acceleration (px/s²)
- Amplitude-to-Length Ratio

**Glottal Area Symmetry Measures:**
- Phase Asymmetry Index
- Spatial Symmetry Index
- Dynamic Range Symmetry Index
- Amplitude Symmetry Index
- Waveform Symmetry Index
- Phase Asymmetry
- Spatial Symmetry
- Dynamic Range Symmetry
- Amplitude Symmetry

**Additional Noise Measures:**
- Glottal-to-Noise Excitation Ratio (GNE) v1
- Harmonics Intensity
- Harmonics-to-Noise Ratio (dB) (original implementation)
- Normalized Noise Energy (NNE)
- Waveform Matching Coefficient (WMC)
- Mean Waveform Matching Coefficient
- Signal-to-Noise Ratio V1 (dB)
- Signal-to-Noise Ratio V2 (dB)
- Cepstral Peak Prominence II (dB)
</details>

---

## Pitch (Tracking) Algorithms

Vocaliscope includes multiple pitch (tracking) algorithms available in parameter calculation and/or via right-click menu:

| Algorithm | Parameter Calculation | Right-Click Menu | Reference |
|-----------|:--------------------:|:----------------:|-----------|
| NCF — Normalized Correlation Function (default) | ✓ | ✓ | [28] · [MATLAB docs](https://www.mathworks.com/help/audio/ref/pitch.html) |
| PEF — Pitch Estimation Filter | ✓ | ✓ | [29] · [MATLAB docs](https://www.mathworks.com/help/audio/ref/pitch.html) |
| CEP — Cepstrum Pitch Determination | ✓ | ✓ | [30] · [MATLAB docs](https://www.mathworks.com/help/audio/ref/pitch.html) |
| LHS — Log-Harmonic Summation | ✓ | ✓ | [31] · [MATLAB docs](https://www.mathworks.com/help/audio/ref/pitch.html) |
| SRH — Summation of Residual Harmonics | ✓ | ✓ | [32] · [MATLAB docs](https://www.mathworks.com/help/audio/ref/pitch.html) |
| SHR (Subharmonic) | ✓ | ✓ | [6] |
| YIN | — | ✓ | [7] |
| SWIPE' | ✓ | ✓ | [8] |
| Bayesian F0 (BF0NLS) | — | ✓ | [9] |
| YAAPT | — | ✓ | [10] |
| CREPE (deep neural network) | — | ✓ | [27] |
| Praat: filtered cross-correlation | — | ✓ | [1] |
| Praat: unfiltered cross-correlation | — | ✓ | [1] |
| Praat: autocorrelation | — | ✓ | [1] |
| Praat: SHS | — | ✓ | [1] |
| Praat: SPINET | — | ✓ | [1] |

The NCF, PEF, CEP, LHS, and SRH methods are implemented via MATLAB's built-in `pitch()` function (Audio Toolbox). The CREPE method is implemented via MATLAB's `pitchnn()` function (Audio Toolbox + Deep Learning Toolbox); the pretrained network `.mat` files are downloaded automatically on first use (see [27]). Praat-based methods are implemented via **praatMEX** [21] — a C++ MEX function that links the Praat core as a static library.

---

## Installation

### Option A: Compiled executable (no MATLAB license required)

1. Download the `.exe` file and all folders **except** `forCompiling/`
2. Install [MATLAB Runtime](https://www.mathworks.com/products/compiler/matlab-runtime.html) version **2026a**
3. Run `Vocaliscope_V5_0.exe`

> **Note:** The compiled executable includes all dependencies (fCWT, praatMEX, inverse filtering methods, etc.).

### Option B: MATLAB App (requires MATLAB license)

1. Download only the `forCompiling/` folder
2. Open in **MATLAB R2026a** or later
3. Open `Vocaliscope.mlapp` from the Current Folder

> **Note:** The `.mlapp` version is generally more performant and allows direct code inspection.

### Additional Requirements

- **MATLAB toolboxes** (for `.mlapp` usage): Signal Processing Toolbox, Audio Toolbox (for some features)

---

## Dependencies & Acknowledgements

Vocaliscope builds upon and includes code from the following open-source tools and libraries:

### Pitch Tracking

| # | Dependency | Description | Repository / Source |
|---|-----------|-------------|---------------------|
| [6] | **SHR** | Subharmonic pitch determination algorithm | [MathWorks File Exchange](https://de.mathworks.com/matlabcentral/fileexchange/1230) |
| [7] | **YIN** | YIN pitch estimator (derived from AaltoAparat) | [mhamilt/yin](https://github.com/mhamilt/yin) |
| [8] | **SWIPE'** | Sawtooth waveform inspired pitch estimation | [kylebgorman/swipe](https://github.com/kylebgorman/swipe) |
| [9] | **Bayesian F0** | Bayesian pitch tracking using harmonic model | [LimingShi/Bayesian-Pitch-Tracking](https://github.com/LimingShi/Bayesian-Pitch-Tracking-Using-Harmonic-model) |
| [10] | **YAAPT** | Yet Another Algorithm for Pitch Tracking | [Binghamton YAAPT page](https://web.archive.org/web/20250613152848/https://www.ws.binghamton.edu/zahorian/yaapt.htm) · Zahorian & Hu, *JASA*, 123(6), 4559–4571 (2008). DOI: [10.1121/1.2916590](https://doi.org/10.1121/1.2916590) |
| [27] | **CREPE** | Deep neural network pitch estimation (via MATLAB `pitchnn`) | [MATLAB `pitchnn` docs](https://www.mathworks.com/help/audio/ref/pitchnn.html) · [CREPE model (.mat)](https://ssd.mathworks.com/supportfiles/audio/crepe.zip) |

### Formant Estimation

| # | Dependency | Description | Repository / Source |
|---|-----------|-------------|---------------------|
| [11] | **ftrack / TVQCP** | Time-varying linear prediction formant estimation | [njaygowda/ftrack](https://github.com/njaygowda/ftrack) |
| [12] | **Story & Bunton** | Formant estimation for children | [TrackChildFmts.m](https://sites.arizona.edu/sapl/research/formant-tracking-in-childrens-speech/) (Arizona SAPL) |
| [26] | **GLOAT / SEDREAMS** | GCI detection (used by TVQCP) | [covarep/covarep](https://github.com/covarep/covarep) (hosts `gci_sedreams.m`) |

### Inverse Filtering

| # | Dependency | Description | Repository / Source |
|---|-----------|-------------|---------------------|
| [14] | **Aalto Aparat** | Inverse filtering toolkit (QCP, IAIF) | [Aalto University](http://research.spa.aalto.fi/projects/aparat/) |
| [15] | **GFM-IAIF** | Glottal source estimation | [operrotin/GFM-IAIF](https://github.com/operrotin/GFM-IAIF) |
| [16] | **GFM-IAIF (OLAF variant)** | Extended glottal source estimation | [SpeechSalleBcn/inverse-filtering-evaluation](https://github.com/SpeechSalleBcn/inverse-filtering-evaluation) |
| [17] | **IOP-IAIF (OLAF variant)** | Glottal source estimation | [SpeechSalleBcn/inverse-filtering-evaluation](https://github.com/SpeechSalleBcn/inverse-filtering-evaluation) |
| [33] | **MCLP** | Maximum Correntropy Linear Prediction | [Izalazar/MCLP](https://github.com/Izalazar/MCLP) |

### Vibrato Analysis

| # | Dependency | Description | Repository / Source |
|---|-----------|-------------|---------------------|
| [18] | **AVA** | Automatic Vibrato Analysis (FDM-based) | [skx300/ava](https://github.com/skx300/ava) |
| [19] | **VibratoScope** | Cycle-based vibrato analysis | [tiagolbc/vibratoscope](https://github.com/tiagolbc/vibratoscope) |
| [20] | **Vibrato Toolbox** | Hilbert AM/FM vibrato analysis | [sourceforge.net/projects/vibrato](https://sourceforge.net/projects/vibrato/) · Zhang et al., *J. Audio Eng. Soc.*, 65(5), 408–422 (2017). DOI: [10.17743/jaes.2017.0010](https://doi.org/10.17743/jaes.2017.0010) |

### Noise & Nonlinear Analysis

| # | Dependency | Description | Repository / Source |
|---|-----------|-------------|---------------------|
| [22] | **GNE / TKEO** | Glottal-to-Noise Excitation Ratio | Thanasis Tsanas, [Voice Analysis Toolbox](https://github.com/ThanasisTsanas/VoiceAnalysisToolbox) |
| [23] | **fastSampEn** | Fast Sample Entropy algorithm | [File Exchange #48574](https://de.mathworks.com/matlabcentral/fileexchange/48574-fast-sample-entropy-saenkd-dim-r-sig) |

### Signal Processing & Visualization

| # | Dependency | Description | Repository / Source |
|---|-----------|-------------|---------------------|
| [5] | **fCWT** | Fast Continuous Wavelet Transform | [fastlib/fCWT](https://github.com/fastlib/fCWT) |

### Praat Integration

| # | Dependency | Description | Repository / Source |
|---|-----------|-------------|---------------------|
| [1] | **Praat** | Phonetics by computer — speech analysis and synthesis | [praat/praat](https://github.com/praat/praat.github.io) |
| [21] | **praatMEX** | In-process Praat C++ API via MEX | [jkirsch-code/praat-mex](https://github.com/jkirsch-code/praat-mex) |

### Other

| # | Dependency | Description | Repository / Source |
|---|-----------|-------------|---------------------|
| [13] | **Photron FASTCAM Viewer (PFV)** | High-speed camera data format | [Photron Limited](https://photron.com/pfv/) |
| [25] | **Glottis Analysis Tool (GAT)** | GCI and glottal analysis (C#/.NET) | Kist et al., *J. Speech Lang. Hear. Res.* (2021). DOI: [10.1044/2021_JSLHR-20-00498](https://doi.org/10.1044/2021_JSLHR-20-00498) · [GAT software](https://www.hno-klinik.uk-erlangen.de/phoniatrie/forschung/computational-medicine/gat-software/) (on request) |
| [34] | **SUBDIR** | Recursive directory listing utility | [File Exchange #15859](https://www.mathworks.com/matlabcentral/fileexchange/15859-subdir-a-recursive-file-search) · [kakearney/subdir-pkg](https://github.com/kakearney/subdir-pkg) |

### Related Tools (referenced but no code included)

The following tools are related to Vocaliscope's domain but their code is not included in this repository: Praat [1], VoiceSauce [2], Sopran [3], VoiceLab [4], Audacity [24], COVAREP [35] (referenced in inverse filtering method attributions).

## References

| # | Reference | URL / DOI |
|---|-----------|-----------|
| [1] | Boersma, P. & Weenink, D. — Praat: doing phonetics by computer | [praat.org](https://www.fon.hum.uva.nl/praat/) · Boersma & van Heuven, *Glot International*, 5(9/10), 1–7 (2001) |
| [2] | Shue, Y.-L., Keating, P., Vicenik, C. & Yu, K. — VoiceSauce | [phonetics.ucla.edu](https://www.phonetics.ucla.edu/voicesauce/) · Shue et al., *Proc. ICPhS XVII*, 1846–1849 (2011) |
| [3] | Granqvist, S. — Sopran: a collection of soprano voice ranges | [tolvan.com](https://www.tolvan.com/index.php?page=/sopran/sopran.php) |
| [4] | Feinberg, D., Cook, O. & Yassine, E.K. — VoiceLab: Automated reproducible acoustic analysis | [Voice-Lab/VoiceLab](https://github.com/Voice-Lab/VoiceLab) · Feinberg & Cook, *PsyArXiv* (2020). DOI: [10.31234/osf.io/v5uxf](https://doi.org/10.31234/osf.io/v5uxf) |
| [5] | Arts, L.P.A. & van den Broek, E.L. — fCWT: Fast Continuous Wavelet Transform | [fastlib/fCWT](https://github.com/fastlib/fCWT) · Arts & van den Broek, *Nature Computational Science*, 2, 47–58 (2022). DOI: [10.1038/s43588-021-00183-z](https://doi.org/10.1038/s43588-021-00183-z) |
| [6] | Sun, X. — Subharmonic pitch determination algorithm | [File Exchange #1230](https://de.mathworks.com/matlabcentral/fileexchange/1230-pitch-determination-algorithm) · *ICSLP 2000*, Beijing |
| [7] | de Cheveigné, A. & Kawahara, H. — YIN, a fundamental frequency estimator | [mhamilt/yin](https://github.com/mhamilt/yin) · de Cheveigné & Kawahara, *JASA*, 111(4), 1917–1930 (2002). DOI: [10.1121/1.1458024](https://doi.org/10.1121/1.1458024) |
| [8] | Camacho, A. & Harris, J.G. — SWIPE': A sawtooth waveform inspired pitch estimator | [kylebgorman/swipe](https://github.com/kylebgorman/swipe) · Camacho & Harris, *JASA*, 124(3), 1638–1652 (2008). DOI: [10.1121/1.2951592](https://doi.org/10.1121/1.2951592) |
| [9] | Shi, L., Wu, D. & Birkholz, P. — Bayesian pitch tracking using harmonic model | [LimingShi/Bayesian-Pitch-Tracking](https://github.com/LimingShi/Bayesian-Pitch-Tracking-Using-Harmonic-model) · Shi et al., *IEEE/ACM TASLP*, 27(11), 1737–1751 (2019). DOI: [10.1109/TASLP.2019.2930917](https://doi.org/10.1109/TASLP.2019.2930917) |
| [10] | Zahorian, S.A. & Hu, H. — YAAPT: An algorithm for pitch tracking | [Binghamton YAAPT page](https://web.archive.org/web/20250613152848/https://www.ws.binghamton.edu/zahorian/yaapt.htm) · *JASA* 123(6), 4559–4571 (2008). DOI: [10.1121/1.2916590](https://doi.org/10.1121/1.2916590) |
| [11] | Gowda, D., Kadiri, S.R., Story, B. & Alku, P. — ftrack / TVQCP: Time-varying quasi-closed-phase formant estimation | [njaygowda/ftrack](https://github.com/njaygowda/ftrack) · *IEEE/ACM TASLP*, 28, 1901–1914 (2020). DOI: [10.1109/TASLP.2020.3000037](https://doi.org/10.1109/TASLP.2020.3000037) |
| [12] | Story, B.H. & Bunton, K. — Formant estimation based on spectral filtering | *Speech Communication*, 76, 93–111 (2016). DOI: [10.1016/j.specom.2015.11.001](https://doi.org/10.1016/j.specom.2015.11.001) · Code: [TrackChildFmts.m](https://sites.arizona.edu/sapl/research/formant-tracking-in-childrens-speech/) (Arizona SAPL) |
| [13] | Photron Limited — FASTCAM Viewer (PFV) | [photron.com/pfv](https://photron.com/pfv/) |
| [14] | Alku, P., Pohjalainen, H. & Airaksinen, M. — Aalto Aparat: Inverse filtering toolkit | [research.spa.aalto.fi](http://research.spa.aalto.fi/projects/aparat/) · Alku, Pohjalainen & Airaksinen, *Subsidia: Tools and Resources for Speech Sciences*, 21, p. 23 (2017) |
| [15] | Perrotin, O. & McLoughlin, I.V. — GFM-IAIF glottal source estimation | [operrotin/GFM-IAIF](https://github.com/operrotin/GFM-IAIF) · Perrotin & McLoughlin, *Proc. ICASSP*, 7160–7164 (2019). DOI: [10.1109/ICASSP.2019.8682625](https://doi.org/10.1109/ICASSP.2019.8682625) |
| [16] | Freixes, M. et al. — GFM-IAIF (OLAF variant) glottal source estimation | [SpeechSalleBcn/inverse-filtering-evaluation](https://github.com/SpeechSalleBcn/inverse-filtering-evaluation) · *Applied Sciences* 13(15), 8775 (2023). DOI: [10.3390/app13158775](https://doi.org/10.3390/app13158775) |
| [17] | Freixes, M. et al. — IOP-IAIF (OLAF variant) glottal source estimation | [SpeechSalleBcn/inverse-filtering-evaluation](https://github.com/SpeechSalleBcn/inverse-filtering-evaluation) · *Applied Sciences* 13(15), 8775 (2023). DOI: [10.3390/app13158775](https://doi.org/10.3390/app13158775) |
| [18] | Yang, L., Rajab, K.Z. & Chew, E. — AVA: Automatic Vibrato Analysis | [skx300/ava](https://github.com/skx300/ava) · [ISMIR 2016 PDF](https://wp.nyu.edu/ismir2016/wp-content/uploads/sites/2294/2016/07/314_Paper.pdf) |
| [19] | Cruz, T.L.B. — VibratoScope: Cycle-based vibrato analysis | [tiagolbc/vibratoscope](https://github.com/tiagolbc/vibratoscope) · *Zenodo* (2025). DOI: [10.5281/zenodo.15519845](https://doi.org/10.5281/zenodo.15519845) |
| [20] | Zhang, M. et al. — Vibrato Toolbox: Hilbert AM/FM analysis | [sourceforge.net/projects/vibrato](https://sourceforge.net/projects/vibrato/) · Zhang et al., *J. Audio Eng. Soc.*, 65(5), 408–422 (2017). DOI: [10.17743/jaes.2017.0010](https://doi.org/10.17743/jaes.2017.0010) |
| [21] | Kirsch, J. — praatMEX: In-process Praat C++ API via MEX | [jkirsch-code/praat-mex](https://github.com/jkirsch-code/praat-mex) |
| [22] | Tsanas, A. — GNE / TKEO (Voice Analysis Toolbox) | [ThanasisTsanas/VoiceAnalysisToolbox](https://github.com/ThanasisTsanas/VoiceAnalysisToolbox) · Tsanas, *Proc. MAVEBA*, 37–40 (2013) |
| [23] | Paa, F. — fastSampEn: Fast Sample Entropy algorithm | [File Exchange #48574](https://de.mathworks.com/matlabcentral/fileexchange/48574-fast-sample-entropy-saenkd-dim-r-sig) · Richman & Moorman, *Am. J. Physiol. Heart Circ. Physiol.*, 278(6), H2039–H2049 (2000). DOI: [10.1152/ajpheart.2000.278.6.H2039](https://doi.org/10.1152/ajpheart.2000.278.6.H2039) |
| [24] | Audacity Team — Audacity audio editor | [audacityteam.org](https://www.audacityteam.org/) |
| [25] | Kist, A.M. et al. — Glottis Analysis Tool (GAT) | DOI: [10.1044/2021_JSLHR-20-00498](https://doi.org/10.1044/2021_JSLHR-20-00498) · Code: [GAT software](https://www.hno-klinik.uk-erlangen.de/phoniatrie/forschung/computational-medicine/gat-software/) (on request) |
| [26] | Drugman, T. — GLOAT / SEDREAMS: Glottal closure instant detection | [covarep/covarep](https://github.com/covarep/covarep) (hosts `gci_sedreams.m`) · Drugman et al., *IEEE/ACM TASLP*, 20(3), 994–1006 (2012). DOI: [10.1109/TASL.2011.2170835](https://doi.org/10.1109/TASL.2011.2170835) |
| [27] | Kim, J.W., Salamon, J., Li, P. & Bello, J.P. — CREPE: A convolutional representation for pitch estimation | [MATLAB `pitchnn` docs](https://www.mathworks.com/help/audio/ref/pitchnn.html) · [CREPE model (.mat)](https://ssd.mathworks.com/supportfiles/audio/crepe.zip) · Kim et al., *Proc. ICASSP*, 161–165 (2018). DOI: [10.1109/ICASSP.2018.8461329](https://doi.org/10.1109/ICASSP.2018.8461329) |
| [28] | Atal, B.S. — Automatic speaker recognition based on pitch contours | *J. Acoust. Soc. Am.*, 52(6B), 1687–1697 (1972). DOI: [10.1121/1.1913303](https://doi.org/10.1121/1.1913303) · [MATLAB docs](https://www.mathworks.com/help/audio/ref/pitch.html) |
| [29] | Gonzalez, S. & Brookes, M. — A pitch estimation filter robust to high levels of noise (PEFAC) | [EUSIPCO 2011 PDF](https://www.eurasip.org/Proceedings/Eusipco/Eusipco2011/papers/1569423085.pdf) · *IEEE/ACM TASLP*, 22(2), 518–530 (2014). DOI: [10.1109/TASLP.2013.2295918](https://doi.org/10.1109/TASLP.2013.2295918) · [MATLAB docs](https://www.mathworks.com/help/audio/ref/pitch.html) |
| [30] | Noll, A.M. — Cepstrum pitch determination | *J. Acoust. Soc. Am.*, 41(2), 293–309 (1967). DOI: [10.1121/1.1910339](https://doi.org/10.1121/1.1910339) · [MATLAB docs](https://www.mathworks.com/help/audio/ref/pitch.html) |
| [31] | Hermes, D.J. — Measurement of pitch by subharmonic summation | *J. Acoust. Soc. Am.*, 83(1), 257–264 (1988). DOI: [10.1121/1.396427](https://doi.org/10.1121/1.396427) · [MATLAB docs](https://www.mathworks.com/help/audio/ref/pitch.html) |
| [32] | Drugman, T. & Alwan, A. — Joint robust voicing detection and pitch estimation based on residual harmonics | *Proc. INTERSPEECH*, 1973–1976 (2011). DOI: [10.21437/Interspeech.2011-519](https://doi.org/10.21437/Interspeech.2011-519) · [MATLAB docs](https://www.mathworks.com/help/audio/ref/pitch.html) |
| [33] | Zalazar, A.L. et al. — MCLP: Maximum Correntropy Linear Prediction | [Izalazar/MCLP](https://github.com/Izalazar/MCLP) · *IEEE/ACM TASLP*, 33, 152–162 (2025). DOI: [10.1109/TASLP.2024.3512187](https://doi.org/10.1109/TASLP.2024.3512187) |
| [34] | Kearney, K. — subdir: Recursive directory listing utility | [File Exchange #15859](https://www.mathworks.com/matlabcentral/fileexchange/15859-subdir-a-recursive-file-search) · [kakearney/subdir-pkg](https://github.com/kakearney/subdir-pkg) |
| [35] | Degottex, G., Kane, J., Drugman, T., Raitio, T. & Scherer, S. — COVAREP: A collaborative voice analysis repository for speech technologies | [covarep/covarep](https://github.com/covarep/covarep) · *Proc. ICASSP*, 960–964 (2014). DOI: [10.1109/ICASSP.2014.6853739](https://doi.org/10.1109/ICASSP.2014.6853739) |
| [36] | Baken, R.J. & Orlikoff, R.F. — Clinical Measurement of Speech and Voice (2nd ed.) | [Open Library](https://openlibrary.org/books/OL16972708M/Clinical_measurement_of_speech_and_voice) (ISBN 978-1-56593-869-4) · Baken & Orlikoff, Cengage Learning (1999) |
| [37] | Bielamowicz, S., Kreiman, J., Gerratt, B.R., Dauer, M.K. & Berke, G.S. — Comparison of voice analysis systems for perturbation measurement | Bielamowicz et al., *J. Speech Lang. Hear. Res.*, 39(1), 126–134 (1996). DOI: [10.1044/jshr.3901.126](https://doi.org/10.1044/jshr.3901.126) |
| [38] | Titze, I.R., Horii, Y. & Scherer, S.R. — Some technical considerations in voice perturbation measurements | Titze, Horii & Scherer, *J. Speech Lang. Hear. Res.*, 30(2), 252–260 (1987). DOI: [10.1044/jshr.3002.252](https://doi.org/10.1044/jshr.3002.252) |
| [39] | Kasuya, H., Endo, Y. & Saliu, S. — Novel acoustic measurements of jitter and shimmer characteristics from pathological voice | Kasuya, Endo & Saliu, *Proc. EUROSPEECH'93*, 1973–1976 (1993). DOI: [10.21437/eurospeech.1993-446](https://doi.org/10.21437/eurospeech.1993-446) |
| [40] | Lessing, J. — Entwicklung einer Klassifikationsmethode zur akustischen Analyse fortlaufender Sprache unterschiedlicher Stimmgüte mittels Neuronaler Netze und deren Anwendung [PhD thesis] | Lessing, PhD thesis, Georg-August-Universität Göttingen (2007). DOI: [10.53846/goediss-2873](https://doi.org/10.53846/goediss-2873) |
| [41] | Michaelis, D. — Das Göttinger Heiserheits-Diagramm: Entwicklung und Prüfung eines akustischen Verfahrens zur objektiven Stimmgütebeurteilung pathologischer Stimmen [PhD thesis] | Michaelis, PhD thesis, Georg-August-Universität Göttingen (2000). DOI: [10.53846/goediss-4239](https://doi.org/10.53846/goediss-4239) |
| [42] | Horii, Y. — Vocal shimmer in sustained phonation | Horii, *J. Speech Lang. Hear. Res.*, 23(1), 202–209 (1980). DOI: [10.1044/jshr.2301.202](https://doi.org/10.1044/jshr.2301.202) |
| [43] | Horii, Y. — Fundamental frequency perturbation observed in sustained phonation | Horii, *J. Speech Lang. Hear. Res.*, 22(1), 5–19 (1979). DOI: [10.1044/jshr.2201.05](https://doi.org/10.1044/jshr.2201.05) |
| [44] | Hollien, H., Michel, J. & Doherty, E.T. — A method for analyzing vocal jitter in sustained phonation | Hollien, Michel & Doherty, *J. Phonetics*, 1(1), 85–91 (1973). DOI: [10.1016/S0095-4470(19)31377-4](https://doi.org/10.1016/S0095-4470(19)31377-4) |
| [45] | Koike, Y. — Application of some acoustic measures for the evaluation of laryngeal dysfunction | Koike, *Studia Phonologica*, 7, 17–23 (1973) |
| [46] | Deal, R.E. & Emanuel, F.W. — Some waveform and spectral features of vowel roughness | Deal & Emanuel, *J. Speech Hear. Res.*, 21(2), 250–264 (1978). DOI: [10.1044/jshr.2102.250](https://doi.org/10.1044/jshr.2102.250) |
| [47] | Johnston, J.D. — Transform coding of audio signals using perceptual noise criteria | Johnston, *IEEE J. Select. Areas Commun.*, 6(2), 314–323 (1988). DOI: [10.1109/49.608](https://doi.org/10.1109/49.608) |
| [48] | Yumoto, E., Gould, W.J. & Baer, T. — Harmonics-to-noise ratio as an index of the degree of hoarseness | Yumoto, Gould & Baer, *J. Acoust. Soc. Am.*, 71(6), 1544–1550 (1982). DOI: [10.1121/1.387808](https://doi.org/10.1121/1.387808) |
| [49] | Timcke, R., von Leden, H. & Moore, P. — Laryngeal vibrations: Measurements of the glottic wave. Part I. The normal vibratory cycle | Timcke, von Leden & Moore, *Arch. Otolaryngol.*, 68(1), 1–19 (1958). DOI: [10.1001/archotol.1958.00730020005001](https://doi.org/10.1001/archotol.1958.00730020005001) |
| [50] | Holmberg, E.B., Hillman, R.E. & Perkell, J.S. — Glottal airflow and transglottal air pressure measurements for male and female speakers in soft, normal, and loud voice | Holmberg, Hillman & Perkell, *J. Acoust. Soc. Am.*, 84(2), 511–529 (1988). DOI: [10.1121/1.396829](https://doi.org/10.1121/1.396829) |
| [51] | Henrich, N., Sundin, G., Ambroise, D., d'Alessandro, C., Castellengo, M. & Doval, B. — Just noticeable differences of open quotient and asymmetry coefficient in singing voice | Henrich et al., *J. Voice*, 17(4), 481–494 (2003). DOI: [10.1067/S0892-1997(03)00005-5](https://doi.org/10.1067/S0892-1997(03)00005-5) |
| [52] | Patel, R., Dubrovskiy, D. & Döllinger, M. — Characterizing vibratory kinematics in children and adults with high-speed digital imaging | Patel, Dubrovskiy & Döllinger, *J. Speech Lang. Hear. Res.*, 57(2) (2014). DOI: [10.1044/2014_JSLHR-S-12-0278](https://doi.org/10.1044/2014_JSLHR-S-12-0278) |
| [53] | Kunduk, M., Döllinger, M., McWhorter, A.J. & Lohscheller, J. — Assessment of the variability of vocal fold dynamics within and between recordings with high-speed imaging and by phonovibrogram | Kunduk et al., *Laryngoscope*, 120(5), 981–987 (2010). DOI: [10.1002/lary.20832](https://doi.org/10.1002/lary.20832) |
| [54] | Mehta, D.D., Zañartu, M., Quatieri, T.F., Deliyski, D.D. & Hillman, R.E. — Investigating acoustic correlates of human vocal fold vibratory phase asymmetry through modeling and laryngeal high-speed videoendoscopy | Mehta et al., *J. Acoust. Soc. Am.*, 130(6), 3999–4009 (2011). DOI: [10.1121/1.3658441](https://doi.org/10.1121/1.3658441) |
| [55] | Chen, G., Kreiman, J., Gerratt, B.R., Neubauer, R.T., Shue, H. & Alwan, A. — Development of a glottal area index that integrates glottal gap size and open quotient | Chen et al., *J. Acoust. Soc. Am.*, 133(3), 1656–1666 (2013). DOI: [10.1121/1.4789931](https://doi.org/10.1121/1.4789931) |
| [56] | Qiu, Q., Schutte, H.K., Gu, L. & Yu, Q. — An automatic method to quantify the vibration properties of human vocal folds via videokymography | Qiu et al., *Folia Phoniatr. Logop.*, 55(3), 128–136 (2003). DOI: [10.1159/000070724](https://doi.org/10.1159/000070724) |
| [57] | Alku, P., Airas, M., Björkner, E. & Sundberg, J. — An amplitude quotient based method to analyze changes in the shape of the glottal pulse in the regulation of vocal intensity | Alku et al., *J. Acoust. Soc. Am.*, 120(2), 1052–1062 (2006). DOI: [10.1121/1.2211589](https://doi.org/10.1121/1.2211589) |
| [58] | Titze, I.R. — Theoretical analysis of maximum flow declination rate versus maximum area declination rate in phonation | Titze, *J. Speech Lang. Hear. Res.*, 49(2), 439–447 (2006). DOI: [10.1044/1092-4388(2006/034)](https://doi.org/10.1044/1092-4388(2006/034)) |
| [59] | Patel, R., Dubrovskiy, D. & Döllinger, M. — Measurement of glottal cycle characteristics between children and adults: Physiological variations | Patel, Dubrovskiy & Döllinger, *J. Voice*, 28(4), 476–486 (2014). DOI: [10.1016/j.jvoice.2013.12.010](https://doi.org/10.1016/j.jvoice.2013.12.010) |
| [60] | MathWorks — `audioFeatureExtractor`: Audio feature extraction | [MATLAB docs](https://www.mathworks.com/help/audio/ref/audiofeatureextractor.html) (Audio Toolbox) |
| [61] | MathWorks — `spectralFlatness`: Spectral flatness for signals and spectrograms | [MATLAB docs](https://www.mathworks.com/help/signal/ref/spectralflatness.html) (Signal Processing Toolbox) |
| [62] | MathWorks — `snr`: Signal-to-noise ratio | [MATLAB docs](https://www.mathworks.com/help/signal/ref/snr.html) (Signal Processing Toolbox) |
| [63] | MathWorks — `splMeter`: Sound pressure level meter | [MATLAB docs](https://www.mathworks.com/help/audio/ref/splmeter.html) (Audio Toolbox) |
| [64] | MathWorks — `acousticLoudness`: Permanent and short-term loudness | [MATLAB docs](https://www.mathworks.com/help/audio/ref/acousticloudness.html) (Audio Toolbox; ISO 532-1 stationary loudness) |
| [65] | MathWorks — `acousticSharpness`: Sharpness sensation of a sound | [MATLAB docs](https://www.mathworks.com/help/audio/ref/acousticsharpness.html) (Audio Toolbox; DIN 45692, Aures and von Bismarck models) |
| [66] | MathWorks — `acousticFluctuation`: Fluctuation strength | [MATLAB docs](https://www.mathworks.com/help/audio/ref/acousticfluctuation.html) (Audio Toolbox) |
| [67] | MathWorks — `acousticRoughness`: Roughness sensation of a sound | [MATLAB docs](https://www.mathworks.com/help/audio/ref/acousticroughness.html) (Audio Toolbox) |
| [68] | MathWorks — `skewness` and `kurtosis`: Sample skewness and kurtosis | [skewness](https://www.mathworks.com/help/stats/ref/skewness.html) · [kurtosis](https://www.mathworks.com/help/stats/ref/kurtosis.html) (Statistics and Machine Learning Toolbox) |
| [69] | MathWorks — Descriptive statistics: sum, mean, median, std, var, min, max, mode, rms, iqr, quantile | [mean](https://www.mathworks.com/help/matlab/ref/mean.html) · [std](https://www.mathworks.com/help/matlab/ref/std.html) · [mode](https://www.mathworks.com/help/matlab/ref/mode.html) · [quantile](https://www.mathworks.com/help/matlab/ref/quantile.html) (MATLAB) |

---

## Citation

If you use Vocaliscope in your research, please cite:

```bibtex
@software{kirsch2026vocaliscope,
  author       = {Kirsch, Jonas},
  title        = {Vocaliscope: An open-source app for multi-channel voice research},
  year         = {2026},
  version      = {5.1},
  url          = {https://github.com/jkirsch-code/Vocaliscope},
  license      = {GPL-3.0-or-later}
}
```

See [`CITATION.cff`](CITATION.cff) for machine-readable citation metadata.

### Studies using Vocaliscope

- Hoppermann, R., Kirsch, J., Pilsl, T., Köberlein, M., Döllinger, M., Echternach, M., 2026. Influence of a Whisper Loading Test on the Vibration Mechanism of the Vocal Folds in the Context of Organic Dysphonia. JCM 15, 1735. https://doi.org/10.3390/jcm15051735
- Kainz, M.-A., Hoppermann, R., Pilsl, T., Köberlein, M., Kirsch, J., Döllinger, M., Echternach, M., 2026. Effects of Bubbles During Water Resistance Therapy on the Vibration Characteristics of Vocal Folds During the Phonation of Different Vowels. JCM 15, 669. https://doi.org/10.3390/jcm15020669
- Kirsch, J., Köberlein, M., Döllinger, M., Echternach, M., 2026. Influence of Execution Speed of an Ascending Glissando on Vocal Stability of Vocally Untrained and Professionally Trained Subjects. Journal of Voice S089219972600189X. https://doi.org/10.1016/j.jvoice.2026.04.019
- Köberlein, M., Pilsl, T., Thiele, J., Gantner, I., Gellrich, D., Gantner, S., Kirsch, J., Echternach, M., 2026. Does Water Resistance Therapy Influence Vocal Vibrato In Classically Trained Singers? Journal of Voice. https://doi.org/10.1016/j.jvoice.2026.08.024


---

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE) **or any later version** (GPL-3.0-or-later).

---

## Contact

**Jonas Kirsch** — jonas.kirsch@med.uni-muenchen.de

Division of Phoniatrics and Pediatric Audiology, Department of Otorhinolaryngology, LMU University Hospital, LMU Munich, Germany


<script>
  // Automatically expand all collapsible boxes when the page loads or before printing
  function expandAllBoxes() {
    // 1. Expand native HTML <details>
    document.querySelectorAll('details').forEach(el => el.setAttribute('open', ''));
    
    // 2. Expand Bootstrap/theme collapsible containers if present
    document.querySelectorAll('.collapse, .collapsible, [data-toggle="collapse"]').forEach(el => {
      el.classList.add('show', 'in');
      el.style.display = 'block';
    });
  }

  window.addEventListener('DOMContentLoaded', expandAllBoxes);
  window.addEventListener('beforeprint', expandAllBoxes);
  // Run immediately in case DOM is already parsed
  expandAllBoxes();
</script>

<style>
  /* Force expanded view on screen and in print */
  details[open] > *:not(summary),
  details > *:not(summary) {
    display: block !important;
  }

  /* Force all scrollable containers and code to unclip */
  pre, code, .hljs, div[class*="content"], div[class*="box"], div[class*="card"] {
    max-height: none !important;
    height: auto !important;
    overflow: visible !important;
  }

  @media print {
    details {
      display: block !important;
    }
  }
</style>