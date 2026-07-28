function refs = sources()
%SOURCES Returns bibliographic references for AVA (FDM method)
%   REFS = SOURCES() returns a struct array with DOI and full metadata.

refs(1).doi = '10.1080/17459737.2016.1217340';
refs(1).authors = 'Yang, Y., Rajab, K., & Chew, E.';
refs(1).year = 2016;
refs(1).title = 'An interactive tool for the analysis of vibrato and portamento in monophonic audio recordings';
refs(1).journal = 'Proceedings of the 17th International Society for Music Information Retrieval Conference (ISMIR)';
refs(1).note = 'AVA system presentation (Apache 2.0)';

refs(2).doi = '10.1080/17459737.2017.1306551';
refs(2).authors = 'Yang, Y., Rajab, K., & Chew, E.';
refs(2).year = 2017;
refs(2).title = 'Filter diagonalisation method for vibrato rate and amplitude estimation';
refs(2).journal = 'Journal of Mathematics and Music';
refs(2).volume = 11;
refs(2).issue = 1;
refs(2).pages = '1-20';
refs(2).note = 'FDM algorithm details';

end
