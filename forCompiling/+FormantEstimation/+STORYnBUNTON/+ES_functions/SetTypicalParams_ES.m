function p = SetTypicalParams_ES

p.WL = 0.05;
p.ovrlp = round(p.WL*1000)/2;
p.threshold = 0;
p.WT = 3; %Gaussian window 
p.TRK = 0; %1 means clean up formant tracking will be used
p.img = 1; %1 means that imagesc is used for sgram rather than surf
p.cmap = 'par'; %or could be set to 'gra' if gray scale is desired.
p.BW = 250;
p.maxF = 7000;
p.Nfmts = 4;
p.smthfactor = 1.12;
p.preemp = 1;
p.formantid = 1;
p.dynrange = [];

p.c = [0.000000006372549  -0.000006176470588 0.002789215686275  0.467647058823528];

