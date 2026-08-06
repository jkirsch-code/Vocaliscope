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
- **VRT** — Voice Reaction Time, energy VAD based (original implementation)
- **POT-Mergell** — Perceptual Onset Time (original implementation)
- **POT-Petermann** — Perceptual Onset Time (original implementation)
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

Vocaliscope computes approximately **65 active voice parameters** across multiple categories, organized in a tree structure. Parameters are computed from user-defined segments and exported to `.xlsx`.

<details>
<summary><b>Fundamental Frequency Measures</b></summary>

- Fundamental Frequency (Hz)
- Cycle Duration (ms)
- Maximum Harmonic (Hz)
- Minimum Subharmonic (Hz)
</details>

<details>
<summary><b>Amplitude Perturbation Measures</b></summary>

- Mean Shimmer (dB)
- Shimmer (%)
- Amplitude Perturbation Quotient (APQ)
- Amplitude Perturbation Factor (APF)
- Amplitude Variability Index (AVI)
</details>

<details>
<summary><b>Period Perturbation Measures</b></summary>

- Mean Jitter (ms)
- Jitter (%)
- Jitter Ratio
- Jitter Factor
- Period Perturbation Quotient (PPQ)
- Period Perturbation Factor (PPF)
- Relative Average Perturbation V1 (RAP)
- Relative Average Perturbation V2 (RAP)
- Period Variability Index (PVI)
</details>

<details>
<summary><b>Energy Perturbation Measures</b></summary>

- Energy Perturbation Quotient (EPQ)
- Energy Perturbation Factor (EPF)
</details>

<details>
<summary><b>Noise Measures</b></summary>

- Spectral Flatness
- Glottal-to-Noise Excitation Ratio (GNE) v1
- Cepstral Peak Prominence I (CPP)
</details>

<details>
<summary><b>Glottal Area Measures</b></summary>

- Open Quotient (OQ)
- Closing Quotient (ClQ)
- Speed Quotient (SQ)
- Speed Index (SI)
- Rate Quotient
- Asymmetry Quotient
- Glottis Gap Index (GGI)
- Plateau Quotient
- Glottal Area Index (GAI)
</details>

<details>
<summary><b>Glottal Area Periodicity Measures</b></summary>

- Amplitude-Periodicity
- Time-Periodicity
</details>

<details>
<summary><b>Glottal Area Derivative Measures</b></summary>

- Maximum Area Declination Rate (MADR)
- Amplitude Quotient
</details>

<details>
<summary><b>Basic Measurements</b></summary>

- Sum
- Mean (arithmetic, harmonic, geometric)
- Standard Deviation (STD)
- Median
- Inter-Quartile Range (IQR)
- Minimum / Maximum
- Root Mean Square (RMS)
- Mode
- Quantiles (5%–95% in 5% steps)
- Skewness
- Kurtosis
- Sum of Square Values
</details>

<details>
<summary><b>Additional Spectral Descriptors</b></summary>

- Spectral Crest
- Spectral Flux
- Spectral Spread
- Spectral Skewness (Spectral Tilt)
- Spectral Kurtosis
- Spectral Centroid
- Spectral Entropy
- Spectral Slope
- Spectral Decrease
- Spectral Rolloff Point
- Harmonic Ratio
- Harmonic-to-Noise Ratio (HNR) via cross-correlation
- Signal-to-Noise Ratio (SNR, dB carrier)
</details>

<details>
<summary><b>Psychoacoustic Measures</b></summary>

- Acoustic Loudness (Zwicker, ISO 532-1)
- Acoustic Fluctuation
- Acoustic Sharpness
- Acoustic Roughness
</details>

<details>
<summary><b>Others</b></summary>

- Zero Crossing Rate
- Sample Entropy (time domain)
- Cycle-based Spectral Sample Entropy
- Sound Pressure Level (SPL: dB(A), dB(C), dB(Z))
- RAP for cycle energy
- RAP for cycle range
- Energy Variability Index (EVI)
- Glottal-to-Noise Excitation Ratio (GNE) v2
- Cepstral Peak Prominence Smoothed v3 (CPP(s))
</details>

<details>
<summary><b>Planned Parameters</b> (not yet available)</summary>

The following parameter categories are implemented in the code but currently hidden or planned for future release:

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

---

## Citation

If you use Vocaliscope in your research, please cite:

```bibtex
@software{kirsch2026vocaliscope,
  author       = {Kirsch, Jonas},
  title        = {Vocaliscope: An open-source app for multi-channel voice research},
  year         = {2026},
  version      = {5.0},
  url          = {https://github.com/jkirsch-code/Vocaliscope},
  license      = {GPL-3.0-or-later}
}
```

See [`CITATION.cff`](CITATION.cff) for machine-readable citation metadata.

### Studies using Vocaliscope

- Kirsch, J., Köberlein, M., Döllinger, M., and Echternach, M. (2026). Influence of Execution Speed of an Ascending Glissando on Vocal Stability of Vocally Untrained and Professionally Trained Subjects. *Journal of Voice.* https://doi.org/10.1016/j.jvoice.2026.04.019

- Hoppermann, R., Kirsch, J., Pilsl, T., Köberlein, M., Döllinger, M., and Echternach, M. (2026). Influence of a Whisper Loading Test on the Vibration Mechanism of the Vocal Folds in the Context of Organic Dysphonia. *JCM*, 15(5), 1735. https://doi.org/10.3390/jcm15051735

- Kainz, M.-A., Hoppermann, R., Pilsl, T., Köberlein, M., Kirsch, J., Döllinger, M., and Echternach, M. (2026). Effects of Bubbles During Water Resistance Therapy on the Vibration Characteristics of Vocal Folds During the Phonation of Different Vowels. *JCM*, 15(2). https://doi.org/10.3390/jcm15020669

---

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE) **or any later version** (GPL-3.0-or-later).

---

## Contact

**Jonas Kirsch** — jonas.kirsch@med.uni-muenchen.de

Division of Phoniatrics and Pediatric Audiology, Department of Otorhinolaryngology, LMU University Hospital, LMU Munich, Germany
