YIN Pitch Tracker
==================

Implementation of the YIN fundamental frequency estimation algorithm for
the Vocaliscope project.

Algorithm
---------

The YIN method estimates F0 by analysing the cumulative mean normalized
difference function of a signal and applying an absolute threshold to
detect the first dip corresponding to the pitch period, followed by
parabolic interpolation for sub-sample accuracy.

Reference:

> de Cheveigné, A., & Kawahara, H. (2002). YIN, a fundamental frequency
> estimator for speech and music. *Journal of the Acoustical Society of
> America*, 111(6), 2734-2747. https://doi.org/10.1121/1.1458024

Origin
------

This MATLAB implementation was adapted from the **AaltoAparat** (Aalto
Voice Source Analysis and Parameterization Toolkit), originally written by
Matti Airas (2005) and later maintained by Hilla Pohjalainen et al.

- Original source file: `@signal/find_f0_yin.m` in AaltoAparat
- SVN revision: `$Id: find_f0_yin.m 84 2005-08-22 09:47:16Z mairas $`

The AaltoAparat code was refactored for Vocaliscope from its OOP `@signal`
class method into standalone functions (`find_f0_yin_core`, `yin`), with
the following additions:

- Configurable F0 search range (f0_min, f0_max)
- Adjustable absolute threshold for the difference function
- Frame-by-frame analysis with configurable frame length and hop size
- Parabolic interpolation for sub-sample F0 estimation
- Periodicity (voicing confidence) output

The VibratoAnalysis subpackage (`+VibratoAnalysis/extractPitch.m`) calls
this implementation when the `'YIN'` method is selected.

License
-------

The YIN code derived from AaltoAparat is licensed under the **GNU Lesser
General Public License v2.1** (LGPL-2.1), matching the original AaltoAparat
license. See the `LICENSE` file in this directory for the full license text.

AaltoAparat copyright: 2003-2008 Matti Airas and others;
                       2015 Hilla Pohjalainen and others.
