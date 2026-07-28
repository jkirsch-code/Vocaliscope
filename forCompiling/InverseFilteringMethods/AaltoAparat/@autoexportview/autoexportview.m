function c = autoexportview(model)

c.model = model;

c = class(c,'autoexportview',viewable(model));

% store this object
store(c);

% update the view

update(c,'init');
