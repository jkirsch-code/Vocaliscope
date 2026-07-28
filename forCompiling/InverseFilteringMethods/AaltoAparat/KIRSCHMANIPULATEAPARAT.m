clear;
close all hidden force;


settingsfig=aparat;

fs=20000;
t=1:1/fs:4;
y=sin(2*pi*100*t);

audiowrite('example1.wav',y,fs,'BitsPerSample',64);

listfilesObj=settingsfig.Children(7);

figWithCB=findall(0,'type','figure','HandleVisibility','callback');
set(figWithCB,'HandleVisibility','on');

aparat('listFiles_Callback',listfilesObj,[],guidata(listfilesObj));

set(figWithCB,'HandleVisibility','callback');

% 6 is "files" text, 7 the box to choose the file. we set only visibility
% instead of deletion
set(settingsfig.Children(6:7),'Visible','off');

settingsfig.Children(3).Position([1 3])=settingsfig.Children(9).Position([1 3]);