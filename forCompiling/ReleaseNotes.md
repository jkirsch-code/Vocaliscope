<details>
<summary>Future plans (click to expand)</summary>

- more pitch tracking
- more formant estimation, also maybe add this to implicit calculation which is done for each channel
- parameters like H1F1 etc.
- Free (text) file import support
- advanced GAW/PVG import (right/left support)
- some parameters still missing like PVG related measures and GAW two sided
- Expand filter toolbox by more time domain filtering, possibility to choose the sequence of filtering in time and frequency
- make parameter description to all parameters available
- enable Closed and Open moment method selection. currently it is pure thresholding for GAW and Howard for for everything else.
- add musical analysis
- plugin/extension system for user-defined analysis methods
- automatic left/right vocal fold detection in PVG image import
- recording via DAQ and/or sound card
- import of DAQ Data from Phantom High Speed Cameras (.cine)
- adding differentiation to channel operations (diff, gradient, via filter, etc)

</details>

---

## V 5.1 (2026-10-12)

<details open>
<summary>New features (click to expand)</summary>

1. added an Import GUI for generic text and spreadsheet files (.txt, .csv, .xlsx, .xls, .xlsb, .xlsm)
</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. fixed a bug in the calculation of the Opening Quotient (OpQ) for EGG signals: the index of the glottal opening instant (3/7 threshold crossing) was mistakenly divided by the cycle length instead of the opening-phase duration. OpQ was consequently wrong for EGG channels, which also corrupted the derived quotients Speed Quotient (SQ), Speed Index (SI), Rate Quotient (RQ) and Asymmetry Quotient (AQ). The opening phase is now correctly measured from the glottal opening instant to the maximum glottal opening (cycle minimum), consistent with the Glottal Area Waveform (GAW) calculation and the literature (Howard 1995; Henrich et al. 2004). The relation OQ = ClQ + OpQ now holds for both GAW and EGG signals.
2. fixed a copy-paste error in the export of the median cycle energy per window: the result field CycleYDataEnergy_median was assigned the mean of the per-cycle energies instead of the median. CycleYDataEnergy_median is now computed with median() and the two result fields CycleYDataEnergy_mean and CycleYDataEnergy_median now correctly differ.
3. fixed a bug in the calculation of the Plateau Quotient (PQ): the plateau phase was counted in raw samples but never normalized by the open phase duration, so the value depended on the sampling rate and the cycle length instead of being a dimensionless ratio. PQ is now calculated as plateau phase duration / open phase duration, in line with the GAT definition (Mehta et al. 2011). The plateau is now also measured per signal type following the GAT convention: for GAW signals the plateau is the time the glottis is near its maximum opening (top of the cycle), for EGG signals it is measured near the minimum (since the EGG signal is inverted relative to the glottal area, the open plateau corresponds to the bottom of the cycle). PQ is consequently only calculated for GAW and EGG channels, consistent with the other quotient parameters.
4. fixed a dependency bug in the perturbation measures that could crash the app: "Jitter (%)" read the "Mean Jitter (s)" result and "Jitter Ratio" read the "Jitter (%)" result, so deselecting the upstream parameter caused an "Unrecognized field name" error. The dependent parameters are now computed as soon as any parameter of the chain is selected.
5. corrected the displayed units of "Cycle Duration" and "Mean Jitter" from (ms) to (s); the stored values were already in seconds (SI).
6. fixed a crash in the interactive filtering: when the comb filter was active and "filter forward and backward" was unchecked, applying the filter raised "Not enough input arguments" because the comb filter (a dsp.SOSFilter System object) cannot be passed to MATLAB's filter(). The comb filter is now applied by calling the System object directly.
7. fixed the design-method logic in the interactive filtering: the "Chebyshev Type II" option was compared against its display text instead of its internal value, so the intended branch never ran. The "match exactly" default is now set per the designfilt convention (Chebyshev Type I → passband, Chebyshev Type II → stopband, Elliptic → both).
8. fixed a bug in the analysis settings: the windowed-analysis check box was compared to 1 without reading its Value property, so the condition was always false and the pitch-analysis time-window limits were always set for the non-windowed case. The limits are now set correctly when windowed analysis is enabled.
9. fixed a bug in the plot layout: when the plotting panel was resized, only the time axes were relaid out, while the spectral axes kept their old size. The debounced resize callback now resets both the time and the spectral axes to fill the panel.
10. fixed two crashes in the time-dependent maximum fo (upper fo prediction): selecting SWIPE' as the prediction algorithm raised "Unrecognized function or variable 'fs'" because the search-range lower bound was computed from an undefined variable instead of the sample rate, and the SHR option was listed in the settings dialog but never handled, so selecting it crashed the calculation. SWIPE' now uses the same Nyquist-based search range as the other pitch algorithms, and the SHR option has been removed from the settings dialog.
11. fixed a bug in which overwrote the spectral value of the third subharmonic (S3) with the values of S4
12. added missing units to the spectral components H1...H4 and S1...S4
</details>

<details>
<summary>Notes (click to expand)</summary>

1. reduced import duration due to improved spectral computation sequence (before all channels' CWT was (re)calculated when importing new channels although not needed)
2. when importing new channels while not all channels are selected, now the selection is extended by the newly added channels (before, always all channels were selected when importing new data, discarding the old selection)
3. the dropdown in which the maximum number of shown channels visible without scrolling is now updated when loading/deleting channels: the maxmium available number will be 8 or the number of available channels (the smaller of the two)
</details>

## V 5.0 (2026-07-28)

<details open>
<summary>New features (click to expand)</summary>

1. customizable channel colors via View → "Channel Colors..." (color picker per source type, instant preview, reset to default, persist via `lastCustomChannelColors.mat`)
2. added a pitch algorithm based on subharmonic called SHR by Xuejing Sun
3. added a pitch algorithm based on the deep neuronal network CREPE (only for right click menu yet)
4. added pitch algorithms by using Praat (filtered/unfiltered cross correlation and auto correlation, shs and SPINET).  Right click menu only so far
5. additional pitch trackers available in parameter calculation and right-click menu: YIN, Bayesian F0 estimation (BF0NLS), YAAPT
6. added the parameter's unit to the results table and the excel sheet
7. added PVG to GAW import from png, jpeg, bmp
8. the channels' sample rate is now also written down in the "General" sheet of the results xlsx file

9. added inverse filtering (with several methods) in the right click menu:
   - Aalto Aparat (QCP and IAIF methods)
   - GFM-IAIF, IOP-IAIF, MCLP (with OLAF variants)
   - Configurable vocal tract order, glottal source order, window length, overlap, leaky integration coefficient

10. added Vibrato Analysis GUI accessible via right-click menu with four methods:
   - VAT (Hilbert AM/FM via VibratoToolbox)
   - AVA (FDM-based Auditory Vibrato Analysis)
   - VibratoScope (cycle-based)
   - CWTf0 (Continuous Wavelet Transform of f0 contour)
   - Features: pitch contour + vibrato markers preview, speed/extent plots, method descriptions with references, CSV export, persistent settings

11. added Onset Analysis GUI accessible via right-click menu with four methods:
   - VRT (Voice Reaction Time, energy VAD based)
   - POT-Mergell (Perceptual Onset Time)
   - POT-Petermann (Perceptual Onset Time)
   - VAT (Voice Analysis Tool, dEGG-based with EGG+audio)
   - Features: waveform + onset marker preview, intermediate results display, multi-channel comparison, CSV export, persistent settings

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. (time) axes now have a single zoom tool in the toolbar (use right click to zoom out) and an export button to export an axis to vector or pixel graphics
2. corrected the copy buttons' text in the lag estimator utility. They had all the same text, but did different things.
3. renamed some parameters which contained the unit of the parameter. the units are now listed separately. Some parameters were also changed to make the search easier since sometimes parameters are only known by their abbreviation, e.g. APQ or CPP. Abbreviations can be used multiple times, e.g. AQ for Asymmetry Quotient and Amplitude Quotient

   | Old Name | New Name |
   |----------|----------|
   | meanShimmerDB | meanShimmer |
   | shimmerInPercent | shimmer |
   | APQXinPercent | AmplitudePerturbationQuotientAPQ |
   | APFinPercent | AmplitudePerturbationFactorAPF |
   | MaximumAreaDeclinationRate | MaximumAreaDeclinationRateMADR |
   | AmplitudeQuotient | AmplitudeQuotientAQ |
   | PlateauQuotient | PlateauQuotientPQ |
   | GlottalGapIndex | GlottalGapIndexGGI |
   | AsymmetryQuotient | AsymmetryQuotientAQ |
   | RateQuotient | RateQuotientRQ |
   | SpeedIndex | SpeedIndexSI |
   | SpeedQuotient | SpeedQuotientSQ |
   | OpeningQuotient | OpeningQuotientOpQ |
   | ClosingQuotient | ClosingQuotientClQ |
   | OpenQuotient | OpenQuotientOQ |
   | AVI | AmplitudeVariabilityIndexAVI |
   | ... | ... |

4. spectral flatness now uses the same window type as specified in the fft settings. before, it was using always a rectangular window
5. SNRindBcarrier now uses the harmonic settings defined in the fo/fft settings. before that it always uses 6 harmonics (including the fundamental)
6. spectral view has now logarithmic amplitude to improve visibility
7. SPL channel creation tool revamped: now offers four output metrics (time-weighted sound level, equivalent-continuous sound level LEQ, peak sound level, maximum time-weighted sound level), configurable reference pressure, report interval, and a live SPL curve preview
8. CPPs settings now automatically clamp parameter limits and synchronize values when any related field (resampling frequency, window length, hop size, time smoothing, quefrency smoothing) changes
9. spectral view now shows peak information (peak value, peak frequency, peak time) as a text overlay when a time region is selected
10. new spectrum recalculation settings dialog with configurable frequency range, values per octave, time/spectral precision trade-off slider, and optional frequency upsampling for reduced calculation time
11. settings file loading now validates that the selected .mat file contains app state before loading, and shows an error dialog if not
12. inverse filtering split into two sub-menus: Aalto Aparat (QCP + IAIF pipeline) and Others (GFM-IAIF, IOP-IAIF, MCLP with configurable parameters)

</details>

<details>
<summary>Notes (click to expand)</summary>

1. V 5.0 requires MATLAB 2026a (up from 2025a in V 4.9)
2. compile script now exports mlapp source to mlapp\_source/ and copies praat scripts + InverseFilteringMethods to standalone build

</details>

---

## Compatibility: MATLAB 2026a+

## V 4.9 (2026-04-16)

<details open>
<summary>New features (click to expand)</summary>

1. added harmonic descriptors like H1H2, H2H4, residual H1 etc.
2. added subharmonic description using the letter S, like S1S2 etc.

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. added some fixes to the new functionality of V 4.8 to avoid some bugs, e.g. when enabling the "use windows" button via right click and then clicking the button with left click, the fields of window length and overlap are visually enabled, but those enabled edit field are not overwritten for the batch mode, only when it is enabled by the right click functionality.

</details>

## V 4.8 (2026-03-30)

<details open>
<summary>New features (click to expand)</summary>

1. the batch recalculation feature now allows to set also other parameters like window length and overlap. for that, right click the element you want to change in the parameter selection screen and enable it. then you can set a new value there and it will be used in all recalculations, replacing the individual mat settings file values.

</details>

## V 4.7 (2026-03-30)

<details open>
<summary>New features (click to expand)</summary>

1. added psychoacoustic loudness, sharpness, roughness and fluctuation
2. wav files are now also exported in cut format when an area is marked
3. CPPs can now be calculated via Parameter Selection for each channel during Parameter calculation (CPP(s) v3)

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. the CPP value which existed until now has now the name CPPv1 (CPPv2 like in GAT not implemented yet)
2. removed a bug in the time variant upper cycle frequency which originated from a typo
3. removed a bug which prevented full parameter table display when text was already entered in the filter text edit field before parameter recalculation

</details>

<details>
<summary>Notes (click to expand)</summary>

1. when importing wav files, channels are now initially auto assigned, meaning channel 1->1, 2->2, etc.
2. In CPP calculation: the upper limit of the lower fit border is now at least 1/foMax to make the fit range at least cover the first Rhamonic (corresponding to fo) in the cepstrum
3. CPP Robust fitting and fitting shape method: only one method can be chosen now, not "all" anymore

</details>

## V 4.6 (2026-03-19)

<details open>
<summary>New features (click to expand)</summary>

1. now it is possible to use a regexp in the batch processing filter text edit field
2. added formant estimation method TVQCP and by Story&Bunton (2016) (for children). Available via right click menu
3. added a comb filter to the filter toolbox
4. the filter text in the batch recalculation mode now accepts * as wildcard
5. the filter text in the parameter calculation parameter selection screen now accepts the wildcard "*" for searching.

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. removed a bug in pitch calculation which occurred when a channel's sample rate was smaller than double the upper frequency search range

</details>

<details>
<summary>Notes (click to expand)</summary>

1. in the parameter calculation screen: now also the main nodes are hidden if they do not match the filter expression 
2. added a select all button in the recalculation batch mode plus some minor gui changes

</details>

## V 4.5 (2026-03-13)

<details open>
<summary>New features (click to expand)</summary>

1. now it is possible to calibrate a signal by comparison to another one: two signals are loaded (e.g. "Papapa" calibrated pressure and uncalibrated accelerometer data). signal 1 is the signal that shall be recalibrated by comparison to signal 2. Regions can be marked in which e.g. the RMS or mean can be calculated (possible per region but also single values). the regions values of signal 1 are used as x coordinates and the region values of signal 2 are used as y coordinate for a scatter plot. that scatter plot is then fit using e.g. a constant line, exponential etc. One forced coordinate can be set (e,g. Origin with (0,0)). The fitted function is then used as calibration function for signal 1.
2. added a batch mode to recalculate parameters (e.g. if you forgot one or if there are new parameters added in a later version). You feed in the mat files from Vocaliscope (*_fullSessionData.mat), choose the parameters which shall be calculated. When the data files are loaded, then the corresponding settings file is applied, the new parameters to be calculated are overwritten. At the moment, files without corresponding settings files are skipped.
   The batch mode for recalculation can be found in the top toolbar under "Extras".

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. removed a bug in the zero prepaid context menu
2. removed a bug in the audioFeatureExtractor which ignored window size settings

</details>

<details>
<summary>Notes (click to expand)</summary>

1. parameters in the result xlsx file are now sorted alphabetically

</details>

## V 4.4 (2026-02-26)

<details>
<summary>Bug fixes (click to expand)</summary>

1. removed a bug that lead to unreliable filtering of the displayed results table
2. removed a bug that lead to an error when using SWIPE' as upper cycle frequency, connected to the interpolation used after the SWIPE' algorithm
3. made the SWIPE' pitch algorithm more robust, before it more often failed when choosing a narrow pitch prediction interval
4. removed a bug in the envelope tool output: when generating an envelope, the upper and lower names were switched
5. removed a bug which prevented the update of the applied lag text when removing the lag via undo all or in the shift toolbox

</details>

<details>
<summary>Notes (click to expand)</summary>

1. removed an annoying warning using parallel looping regarding the variables resampledY and resampledTime
2. small ui changes in the calculate fo interface
3. the quick calculation values in time domain have now white background
4. contains a preview for calibration by comparison feature

</details>

## V 4.3 (2026-02-25)

<details open>
<summary>New features (click to expand)</summary>

1. added an envelope calculation tool using methods like moving max/min, peaks, hilbert analytical, rms, etc...
2. added unit conversion from dB to Magnitude and vice versa

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. removed a bug during csv import when the file name had certain keywords in it
2. removed a display bug in the context menu in the channel source: there, the checkmark was always at the entry of the channel type of the first channel. check marks are now disabled

</details>

## V 4.2 (2026-02-24)

<details open>
<summary>New features (click to expand)</summary>

1. The currently applied lag is now shown in the top left of each axis
2. Added Pitch Tracker SWIPE prime (SWIPE')

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. removed a bug which occurred when shifting a signal using shift toolbox when it was already shifted
2. fixed a bug which did not draw the marked area when e.g. adding a new channel

</details>

## V 4.1 (2026-02-12)

<details open>
<summary>New features (click to expand)</summary>

1. added the parameters: jitter factor
   - RAP for cycle energy and range
   - Energy Variability index
   - Glottal Area Index
   - Amplitude Periodicity
   - Cycle Duration Periodicity
   - Maximum Area Declination Rate
   - Amplitude Quotient
2. added the possibility to use a time dependent upper fo border by using a pitch prediction algorithm and a margin
3. new basic editing operation: pre and/or post padding the signals to earliest or latest signal start is now possible. this is since it is by default
     not possible to select signal areas in which at least signal does not have data. padding those channels will now easily enable to select also those areas

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. removed a bug in the calculation of the perturbation quotient (APQ and EPQ and PPQ)
2. in the calculation Settings the checkbox for choosing parameters are finally functional now
3. changes the names of some parameters
4. jitter factor and jitter ratio were confused in earlier versions
5. when saving to mat, the mat suffix was changed from '_channelNameTypeHistoryAndSelectedArea.mat' to '_fullSessionData.mat'
6. removed some unfunctional leftovers from the change of SPL calibration from V 4.0 (choosing SPL speed did not have effect anymore but was still available to choose)
7. fixed a bug in parameter selection when pressing the "check all" button when the nodes were filtered
8. fixed a bug in parameter selection when pressing the "uncheck all" button when the nodes were filtered
9. fixed a bug which turned the vertical auto zoom off when a signal was appended

</details>

<details>
<summary>Notes (click to expand)</summary>

1. the vertices y sizes from the marked area, detected cycle borders, oq areas are now kept at maximum size to minimize renderer load
2. in the cycle preview: cycle border frequency has now legends and is plotted with logarithmic frequency axis

</details>

## V 4.0 (2026-01-27)

<details>
<summary>Bug fixes (click to expand)</summary>

1. finished the new resampling features mentioned into V3.9. I forgot to finish the programming
2. nasalance calculation: added some pre and post padding (1s constant values) to avoid filter edge effects
3. removed a bug that occurred when using the manual (mouse based) signal shift functionality, which overread some internal values, which in turn could lead to annoying errors and their corresponding sounds
4. the calibration method uses now the Matlab function calibrateMicrophone instead of manual mean SPL dB(X) calculation. Before, the resulting SPL values could be inaccurate when e.g. calculating the SPL channel

</details>

## V 3.9 (2026-01-22)

<details open>
<summary>New features (click to expand)</summary>

1. More options for the resampling (accessed by right click menu): you can now choose to resample all channels at once, only selected channels or channels above a certain sampling frequency

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. SPL in the automatic parameter calculation is now not anymore calculated just for the selected area, but for the complete channel data and cut afterwards. SPL calculation has always some kind of ramp on at the beginning, since no history data is available before. by calculating the complete SPL and cutting afterwards, that ramp on is not an issue anymore (except for the case, that the beginning of the channel data is selected)

</details>

## V 3.7 (2026-01-08)

<details open>
<summary>New features (click to expand)</summary>

1. added a confirmation dialog when trying to close the app

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. removed a bug that occurred when a new channel was added via right click menu when not all channels were visible

</details>

## V 3.6 (2025-12-01)

<details open>
<summary>New features (click to expand)</summary>

1. there is now an additional tab available which shows the spectral content of each signal, the signal can be marked and moved as usually in the time region.

</details>

<details>
<summary>Notes (click to expand)</summary>

1. the wavelet feature introduced in V 3.4 has been removed again

</details>

## V 3.5 (2025-11-26)

<details open>
<summary>New features (click to expand)</summary>

1. signals can now be resampled via the right click menu. there it is also possible to just set the time stamps to a new sample rate without spectral filtering (e.g. when loading a GAW which was saved with an incorrect sample rate by mistake)

</details>

## V 3.4 (2025-11-26)

<details open>
<summary>New features (click to expand)</summary>

1. now you can calculate the continuous wavelet transform of any channel to view it (via right click menu). Probably useful to see changes between i-a-u-i e.g. This is probably a temporary feature

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. fixed a bug during writing to excel: if there were NaN values in one of the windows, the median/mean/std values were not written. this results displayed in the app itself were not affected by that bug
2. fixed a display bug regarding the playback time indicator

</details>

## V 3.3 (2025-11-24)

<details open>
<summary>New features (click to expand)</summary>

1. when playing a selection via audio, a horizontal line indicates the current position in time
2. the calculation results table can now be filtered using text search (does not affect saved values)
3. parameters in the calculation settings screen (General tab) can now be filtered using and text edit field. You also have options regarding searched columns and case sensitivity

</details>

<details>
<summary>Notes (click to expand)</summary>

1. added an indicator when saving the parameters to excel when the target excel file is already open.
2. added some robustness to parameter calculation (spectral flatness, spectral crest etc)

</details>

## V 3.2 (2025-11-19)

<details>
<summary>Bug fixes (click to expand)</summary>

1. fixed a bug which made prevented loading new data after already having any data loaded.

</details>

<details>
<summary>Notes (click to expand)</summary>

1. in the results table, it is now possible to copy or plot the selected row using keyboard. e.g. use Ctrl+P to plot the window data, Ctrl-C to copy the selected cell, etc...
2. added some more error handling to CPP and sample entropy calculation (the integrated, not the explicit one via right click menu) calculation to avoid too many error messages in the windows terminal

</details>

## V 3.1 (2025-11-17)

<details>
<summary>Notes (click to expand)</summary>

1. small change of principle: when using a mask for windowed analysis, also 1 regions are analyzed that are only partly inside the selected area. before, only 1 regions were used for calculations, which were completely inside the selected area

</details>

## V 3.0 (2025-11-17)

<details>
<summary>Bug fixes (click to expand)</summary>

1. fixed a bug related to channel deletion and subsequent adding of new channel data
2. fixed a bug related to renaming channels: those values were not saved internally and as consequence were not saved to mat files

</details>

## V 2.9 (2025-11-14)

<details>
<summary>Bug fixes (click to expand)</summary>

1. quick fix: a bug lead to an error when saving the excel data

</details>

## V 2.8 (2025-11-11)

<details open>
<summary>New features (click to expand)</summary>

1. there is now a tool available to estimate lag between two signals. it can be accessed using the top bar under "Extras" or in the shift toolbox ()

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. removed a bug which showed wrong calculation in the channel wise quick calculation line if the signal did not have lag=0
2. removed a bug which lead to an error when the signals are shifted so much that the marked area is completely outside of one of the signals
3. removed a bug which did not show calculation progress when choosing preview

</details>

## V 2.7 (2025-11-10)

<details open>
<summary>New features (click to expand)</summary>

1. new parameters: RAPv1, RAPv2, spectralCrest, spectralFlux, spectralSpread, spectralSkewness, spectralKurtosis, spectralCentroid, spectralEntropy, spectralSlope, spectralDecrease, spectralRolloffPoint, harmonicRatio, zeroCrossingRate, Signal-to-noise ratio, Harmonic-to-noise ratio (cross correlation based)
2. you can now estimate the probability of voice activity via right click menu
3. lags applied by the shift toolbox are now also saved to the channels history and can be undone using the right click menu like all other operations
4. the last used calculation settings (usually file lastVocaliscopesettings.mat) is now copied to the destination where the results are saved to. how to load, see next
5. calculation settings can now be loaded in the settings screen using the new top right button

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. fixed a bug which set the fo analysis window size and its overlap wrong when loading last valid calculation settings from mat file
2. fixed bugs in cycle period related parameters. cycle length was always calculated from global cycle lengths, not based on the windows' cycles' length
3. fixed a bug which did not save the channels' lag to the mat file generated when saving the calculation results
4. fixed a bug when saving to e.g. a one drive folder. Now the excel file is written locally and then moved to the target direction

</details>

## V 2.6 (2025-10-29)

<details open>
<summary>New features (click to expand)</summary>

1. now we can import data from the vocaliscope mat files

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. removed a bug which saved the channels history not in the same sequence as the channels were exported to wav

</details>

## V 2.5 (2025-10-28)

<details open>
<summary>New features (click to expand)</summary>

1. when saving the channels names and types to file (which is automatically done when exporting to wav), now the currently chosen marked area is also saved

</details>

<details>
<summary>Notes (click to expand)</summary>

1. SPL is now calculated for non Raw channel type only (i.e. no SPL data calculation for Raw data), dBA, dBC and DBZ with slow and fast time constant with ref to 20mu or 1 are available

</details>

## V 2.4 (2025-10-27)

<details open>
<summary>New features (click to expand)</summary>

1. the mask creator app now stores the last used values in  a local file, which is restored when creating a new mask

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. removed a bug which lead to an cycle calculation abortion when using a mask and no cycle borders were found
2. removed a bug concerning selected area calculation quick view

</details>

## V 2.3 (2025-10-27)

<details open>
<summary>New features (click to expand)</summary>

1. in each axes for the selected area there are some basic parameters calculated and displayed in the top right of each of the axes.

</details>

<details>
<summary>Notes (click to expand)</summary>

1. which parameters are shown or not can be set by the View Menu in the top bar

</details>

## V 2.2 (2025-10-25)

<details open>
<summary>New features (click to expand)</summary>

1. SPL can now be generated as additional channel using the right click menu
2. fo can now be generated as additional channel using the right click menu
3. signal parts can now be deleted outside the selected region using the right click menu -> basic editing
4. it is now possible to convert cm H2O to Pa and vice versa using right click menu -> Unit conversion

</details>

<details>
<summary>Notes (click to expand)</summary>

1. SPL are now calculates as parameters, regardless of channel type

</details>

## V 2.1 (2025-10-21)

<details open>
<summary>New features (click to expand)</summary>

1. when photron csv are imported with NaN values, it is now possible to replace those values with various methods during import

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. removed a bug which did not align the signals in time when adding new single channels (e.g. by duplication or Sample Entropy calculation)
2. removed a bug: newly single added channels did not zoom horizontally only as normal behavior

</details>

## V 2.0 (2025-10-09)

<details open>
<summary>New features (click to expand)</summary>

1. the filtering toolbox can also now use moving mean filters and similar. those "filters" are applied before the spectral filtering

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. removed a bug in the version management of each channel
2. removed a feature: in earlier version only the selected area was saved to wav when saving to wav. t avoid data loss, this functionality was disabled

</details>

## V 1.9 (2025-10-08)

<details open>
<summary>New features (click to expand)</summary>

1. now a mask can be created for analysis of valleys or peak regions. can be found by the right click menu -> add new channel. the mask's channel can be chosen in the calculation settings, near the check box for the windowed analysis. If no channels are available containing a mask (i.e. only 0 and 1 values), the checkbox cannot be selected

</details>

## V 1.8 (2025-10-06)

<details open>
<summary>New features (click to expand)</summary>

1. right click menu can now be used to duplicate a channel

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. fixed a bug that when appending signals, the appended signal is not part of the channels version history, i.e. when undoing changes, the version jumped back to pre appended version

</details>

## V 1.7 (2025-09-29)

<details>
<summary>Notes (click to expand)</summary>

1. when channels are exported to multi channel wav, they are now not anymore upsampled to the highest occuring sampling rate, but instead, multiple (multi channel) wav signals are generated. In addition, there is also generated a mat file for the current state of channels. I.e. to reload, reload all wav files and then import the mat file.
2. WAV files are now padded with 0 if the signals to not have the same number of samples or if they do not start in the same moment in time. When reloading those wav, you can remove those leading zeros trough the right click context menu

</details>

## V 1.6 (2025-09-25)

<details open>
<summary>New features (click to expand)</summary>

1. Font size can now be changed for the app via main window toolbar in the top. also possible by simply pressing + or -

</details>

<details>
<summary>Bug fixes (click to expand)</summary>

1. fixed a bug which made the pitch extraction return only constant values

</details>

<details>
<summary>Notes (click to expand)</summary>

1. toolbar in the top can now be accessed using keyboard ALT key, e.g., ALT+F+I will open the import dialog

</details>

## V 1.5 (2025-09-24)

<details>
<summary>Notes (click to expand)</summary>

1. Nasality can now be calculated using the right click context menu of the axes. Values are cut to the range [0;1]
2. adding new channels like Samp En and Nasality is now faster
3. added a button to delete non selected channels
4. channel names (titles) can now be edited by clicking on it, it is also now updated in shortened version in the top right table

</details>

## V 1.4 (2025-09-22)

<details>
<summary>Bug fixes (click to expand)</summary>

1. fixed a bug which set all channel source types to the same value when changed using the table on the top right

</details>

<details>
<summary>Notes (click to expand)</summary>

1. now the sample entropy can be generated as additional signal by right clicking the plot area of a channel

</details>

## V 1.3 (2025-08-11)

<details>
<summary>Notes (click to expand)</summary>

1. fixed several bugs, including the one mentioned in V1.2
2. Results table is now sorted by parameter names (but can still be resorted arbitrarily as ususal)
3. on the top right of each axis there are now zoom and unzoom tools available

</details>

## V 1.2 (2025-08-07)

<details>
<summary>Notes (click to expand)</summary>

1. imported data can now be appended to existing channels
2. hiding and showing already loaded channels is now much faster (loading channels unfortunately not yet)
3. Notice: sometimes there is a bug after loading channels that the axes appear small on the bottom left: to fix that for that moment, just resize the app window a bit

</details>

## V 1.1 (2025-07-29)

<details>
<summary>Notes (click to expand)</summary>

1. The apps should now be more performant due to architecture change matlab appdesigner in Matlab 2025a
2. In the results table, the cells can now directly be marked with right click, no need to left click before right click to mark the correct cell/row
3. The audio wav import is now more flexible: for each channel the channel source type can be chosen, that profile can also be saved and loaded from a simple text file

</details>

---

## Compatibility: MATLAB 2025a+

## V 1.0 (2025-07-24)

<details>
<summary>Notes (click to expand)</summary>

1. Finally: we got the Sample Entropy code from Selamtzis. it has its own cycle detection and is calculated for the whole signal and then windowed (if requested in the general settings)
2. now we can plot the windowed results data by left clicking a cell in the results table and then right clicking and using plot
3. in the same right click menu, single data entries or the whole windowed data series can now be copied

</details>

## V 0.5 (2025-06-16)

<details>
<summary>Notes (click to expand)</summary>

1. Data can now be exported into 32 or 64 bit wav. either multi channel or single channel files.
2. There are now several basic editing option available for channel editing via right click menu. also it it possible to calibrate the signals using either SPL, summation or start vs end of marked area
3. SampEn has now been implemented using a fast algorithm, speeding up the overall calculation time
4. Channel names can now be edited by double clicking the channels' title in the plot pane

</details>

## V 0.4 (2025-05-14)

<details>
<summary>Notes (click to expand)</summary>

1. Each channel can now be filtered individually via right click context menu. The filtering can also be undone
2. cycle detection is now max based, not min based anymore. It seems to be more robust against noise, since the peaks (e.g. in EGG) is more pronounced and not as error prone to noise
3. Parameter results can now be previewed after calculation and the results can be saved to excel files.

</details>

## V 0.3 (2025-04-10)

<details>
<summary>Notes (click to expand)</summary>

1. The app now fully features an integrated filter toolbox, which can be used to filter channel data individually. It is accessible via the right click menu inside the axes
2. The selected area is now limited by the data traces: it cannot be selected an area in which any of the data traces does not have data available (e.g. due to shifting)

</details>

## V 0.2 (2025-04-08)

<details>
<summary>Notes (click to expand)</summary>

1. Now there are three edit fields which show the current marked area start, end and duration. those fields can also be used to set the selected area 
2. each axis has now a context menu (right click) to set the data source type. before, the source type could only be changed via the channel table in the top right corner (which is still possible)

</details>
