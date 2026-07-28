function c = sigview(model,hObject)

c.model = model;
c.hObject = hObject;
c.signalAxes = findobj(hObject, 'Tag', 'signalAxes');
c.flowAxes = findobj(hObject, 'Tag', 'flowAxes');
c.dflowAxes = findobj(hObject, 'Tag', 'dflowAxes');

setappdata(c.signalAxes,'btndown',false);
setappdata(c.signalAxes,'sel',struct);
setappdata(c.signalAxes,'selname','sppres_selection');
%setappdata(c.flowAxes,'btndown',false);
%setappdata(c.flowAxes,'sel',struct);
%setappdata(c.flowAxes,'selname','glottal_selection');
%setappdata(c.dflowAxes,'btndown',false);
%setappdata(c.dflowAxes,'sel',struct);
%setappdata(c.dflowAxes,'selname','glottal_selection');

c = class(c,'sigview',viewable(model,c.hObject));

% store a ref of me in axes appdata
setappdata(c.signalAxes,'viewobj',get(c,'this'));
setappdata(c.flowAxes,'viewobj',get(c,'this'));
setappdata(c.dflowAxes,'viewobj',get(c,'this'));

% store this object
store(c);

% update the view

update(c,'init');
