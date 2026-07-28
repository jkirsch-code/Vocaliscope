function refs = sources()
%SOURCES References and license information for CWTf0 method
%   REFS = SOURCES() returns bibliography and license information.
%   The CWT-of-f0 approach is an original implementation; no external
%   algorithmic source is cited. Credits below are for the fCWT library.

    refs = struct();
    refs(1).name = 'fCWT';
    refs(1).license = 'Apache License 2.0';
    refs(1).citation = ['Arts, L.P.A. & van den Broek, E.L. (2022). ' ...
        'The fast continuous wavelet transformation (fCWT). ' ...
        'Journal of Open Source Software, 7(70), 3971.'];
    refs(1).url = 'https://github.com/fastlib/fcwt';
    refs(1).algorithms = {'Fast Morlet CWT', 'FFTW-based acceleration'};
    refs(1).originalLanguage = 'C++/MATLAB';
    refs(1).note = 'Used as computational backend for CWT of F0 contour.';

    refs(2).name = 'CWT Mathematical Foundation';
    refs(2).license = 'N/A (mathematical reference)';
    refs(2).citation = ['Grossmann, A. & Morlet, J. (1984). ' ...
        'Decomposition of Hardy functions into square integrable wavelets ' ...
        'of constant shape. SIAM Journal on Mathematical Analysis, 15(4), 723-736.'];
    refs(2).url = '';
    refs(2).algorithms = {'Continuous Wavelet Transform'};
    refs(2).originalLanguage = 'N/A';
    refs(2).note = 'Mathematical foundation for CWT. Not an algorithmic source for this implementation.';
end
