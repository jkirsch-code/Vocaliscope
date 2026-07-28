function c = viewable(model, fig)

if nargin==1
  fig=0;
end

c.this = ref;
c.model = model;
c.fig = fig;

c = class(c,'viewable');

% set the data observer

m = deref(model);
attach(m,c.this);

if fig ~=0
  setappdata(fig,'this',c.this);
  set(fig,'CloseRequestFcn','destroy(deref(getappdata(gcf,''this'')))');
end
