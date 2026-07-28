function c = multiview(model,fig,parname)

c.model = model;
c.fig = fig;
c.data = {};
c.parname = parname;
c.param = [];

c = class(c,'multiview',viewable(model,fig));

% store this object
store(c);

% save a reference of the view object to the figure
setappdata(c.fig,'view',get(c,'this'));

% set the callback to the window
set(fig,'WindowButtonUpFcn', ...
        ['sigs(''multiview_WindowButtonUpFcn'',gcbo,[],guidata(gcbo))']);

% update the view

update(c,'init');
