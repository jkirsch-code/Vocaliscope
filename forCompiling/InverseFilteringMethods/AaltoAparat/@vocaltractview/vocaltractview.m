function c = vocaltractview(model,axes)

c.model = model;
c.axes = axes;

c = class(c,'vocaltractview',viewable(model,get(c.axes,'Parent')));

% store this object
store(c);

% update the view

update(c,'init');
