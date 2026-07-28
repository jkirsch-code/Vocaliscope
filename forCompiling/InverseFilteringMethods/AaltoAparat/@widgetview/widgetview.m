function c = widgetview(model,hObject)

c.model = model;
c.hObject = hObject;

c = class(c,'widgetview',viewable(model));

% store this object
store(c);

% update the view

update(c,'init');
