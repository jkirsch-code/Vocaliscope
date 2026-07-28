function refs = sources()
%SOURCES Returns bibliographic references for Vocal Rise Time (VRT)
%   REFS = SOURCES() returns a struct array with DOI and full metadata
%   for each key reference. Used to generate clickable DOI links in the UI.

refs(1).doi = '10.1016/j.jvoice.2024.10.009';
refs(1).authors = 'Bi, M., Nguyen, D.D., Arias-Vergara, T., Dollinger, M., Holik, J., Madill, C.J.';
refs(1).year = 2024;
refs(1).title = 'Effects of Instructed Laryngeal Manipulation on Vocal Rise Time';
refs(1).journal = 'Journal of Voice';
refs(1).note = 'VRT validation across phonation types in healthy adults';

refs(2).doi = '10.1044/jshd.5104.299';
refs(2).authors = 'Peters, H.F.M., Boves, L., van Dielen, I.C.H.';
refs(2).year = 1986;
refs(2).title = 'Perceptual Judgment of Abruptness of Voice Onset in Vowels as a Function of the Amplitude Envelope';
refs(2).journal = 'Journal of Speech and Hearing Disorders';
refs(2).volume = 51;
refs(2).issue = 4;
refs(2).pages = '299-308';
refs(2).note = 'Original paper establishing 10%-90% amplitude envelope rise time for voice onset';

end
