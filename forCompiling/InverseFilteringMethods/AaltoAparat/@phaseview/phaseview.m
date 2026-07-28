function c = phaseview(model,axes1)
% create phaseview object

c.model = model;
c.axes1 = axes1;

c = class(c,'phaseview',viewable(model,get(c.axes1,'Parent')));

% store this object
store(c);

% update the view

update(c,'init');
