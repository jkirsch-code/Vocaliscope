function y=parsename(filename)
% PARSENAME A sample filename parsing function

y.subj = filename((end-16):(end-13));
y.num = str2num(filename((end-11):(end-10)));
y.phon = filename((end-8):(end-6));
