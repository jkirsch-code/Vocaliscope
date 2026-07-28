function refs = sources()
%SOURCES Returns bibliographic references for VibratoToolbox
%   REFS = SOURCES() returns a struct array with DOI and full metadata
%   for each key reference. Used to generate clickable DOI links in the UI.

refs(1).doi = '10.17743/jaes.2017.0010';
refs(1).authors = 'Zhang, M., Lu, H., Ren, G., Smith, S., Beauchamp, J., & Bocko, M. F.';
refs(1).year = 2017;
refs(1).title = 'A Matlab-Based Signal Processing Toolbox for the Characterization and Analysis of Musical Vibrato';
refs(1).journal = 'Journal of the Audio Engineering Society';
refs(1).volume = 65;
refs(1).issue = 5;
refs(1).pages = '408-422';
refs(1).note = 'Primary algorithmic foundation (CC-BY 4.0)';

refs(2).doi = '10.1121/1.4915868';
refs(2).authors = 'Zhang, M., Bocko, M. F., & Beauchamp, J.';
refs(2).year = 2015;
refs(2).title = 'Measurement and analysis of musical vibrato parameters';
refs(2).journal = 'The Journal of the Acoustical Society of America';
refs(2).volume = 137;
refs(2).issue = 4;
refs(2).pages = '2286-2286';
refs(2).note = 'Foundational work on vibrato parameterization';

refs(3).doi = '10.1121/1.3560973';
refs(3).authors = 'Beauchamp, J. W.';
refs(3).year = 2007;
refs(3).title = 'Analysis and synthesis of musical vibrato';
refs(3).journal = 'Journal of the Acoustical Society of America';
refs(3).volume = 121;
refs(3).issue = 5;
refs(3).pages = 'EL174-EL180';
refs(3).note = 'Hilbert transform application for vibrato analysis';

end
