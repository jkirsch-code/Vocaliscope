function c = optwidgetview(model,hObject)

c.model = model;
c.hObject = hObject;

c = class(c,'optwidgetview',viewable(model,hObject));

% store this object
store(c);

% update the view

update(c,'init');
