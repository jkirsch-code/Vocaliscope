function refs = sources()
%SOURCES Returns bibliographic references for Vocal Attack Time (VAT)
%   REFS = SOURCES() returns a struct array with DOI and full metadata
%   for each key reference. Used to generate DOI links in the UI.

refs(1).doi = '10.1016/j.jvoice.2007.08.004';
refs(1).authors = 'Orlikoff, R.F., Deliyski, D.D., Baken, R.J., Watson, B.C.';
refs(1).year = 2009;
refs(1).title = 'Validation of a Glottographic Measure of Vocal Attack';
refs(1).journal = 'Journal of Voice';
refs(1).volume = 23;
refs(1).issue = 2;
refs(1).pages = '164-168';
refs(1).note = 'Primary validation of VAT with high-speed video';

refs(2).doi = '10.1016/j.jvoice.2010.10.012';
refs(2).authors = 'Roark, R.M., Watson, B.C., Baken, R.J.';
refs(2).year = 2012;
refs(2).title = 'A Figure of Merit for Vocal Attack Time Measurement';
refs(2).journal = 'Journal of Voice';
refs(2).volume = 26;
refs(2).issue = 1;
refs(2).pages = '8-11';
refs(2).note = 'Automated VAT algorithm with Figure of Merit (FOM)';

refs(3).doi = '10.1016/j.jvoice.2012.12.004';
refs(3).authors = 'Watson, B.C., Baken, R.J., Roark, R.M., Reid, S., Ribeiro, M., Tsai, W.';
refs(3).year = 2013;
refs(3).title = 'Effect of Fundamental Frequency at Voice Onset on Vocal Attack Time';
refs(3).journal = 'Journal of Voice';
refs(3).volume = 27;
refs(3).issue = 3;
refs(3).pages = '273-277';
refs(3).note = 'Effect of F0 on VAT in healthy adults';

refs(4).doi = '10.1016/j.jvoice.2014.12.004';
refs(4).authors = 'Watson, B.C., Baken, R.J., Roark, R.M.';
refs(4).year = 2016;
refs(4).title = 'Effect of Voice Onset Type on Vocal Attack Time';
refs(4).journal = 'Journal of Voice';
refs(4).volume = 30;
refs(4).issue = 1;
refs(4).pages = '11-14';
refs(4).note = 'Describes difference function algorithm ASP''(t) and AEGG''(t) with FOM > 0.75';

end
