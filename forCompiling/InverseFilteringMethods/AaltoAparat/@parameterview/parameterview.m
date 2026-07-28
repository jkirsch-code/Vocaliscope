function c = parameterview(model,hObject)

c.model = model;
c.hObject = hObject;

c = class(c,'parameterview',viewable(model,hObject));

% store this object
store(c);

% update the view

update(c,'init');
