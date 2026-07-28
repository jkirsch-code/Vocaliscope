function refs = sources()
%SOURCES References and license information for VibratoScope
%   REFS = SOURCES() returns bibliography and license information.

    refs = struct();
    refs.name = 'VibratoScope';
    refs.license = 'MIT License';
    refs.citation = ['Cruz, T. L. B. (2025). VibratoScope: A Python Toolkit for ' ...
        'High-Resolution Vibrato Analysis in Singing Voice. Zenodo. ' ...
        'DOI: 10.5281/zenodo.15519845'];
    refs.url = 'https://github.com/tiagolbc/vibratoscope';
    refs.algorithms = {'Cycle-based vibrato detection', 'Jitter metrics', ...
        'Sample Entropy', 'Coefficient of Variation'};
    refs.originalLanguage = 'Python';
    refs.rewrittenFor = 'MATLAB';
end
