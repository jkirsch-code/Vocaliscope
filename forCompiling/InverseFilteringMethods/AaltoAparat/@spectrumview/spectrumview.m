function c = spectrumview(model,hObject,hAxes)
% create spectrumview object

c.model = model;
c.hObject = hObject;
c.hAxes = hAxes;

c = class(c,'spectrumview',viewable(model,get(hAxes,'Parent')));

% store this object
store(c);
% update the view
update(c,'init');
