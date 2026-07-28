function h = overaxes(hObject)

children = get(hObject,'Children');

h=0;
for i=1:length(children)
  if not(strcmp(get(children(i),'Type'),'axes'))
    continue
  else
    point = get(children(i),'CurrentPoint');
    xlim = get(children(i),'XLim');
    ylim = get(children(i),'YLim');
    if isoveraxes(point,xlim,ylim)
      h = children(i);
      return;
    end
  end
end

