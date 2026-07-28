function event(c,type,ax)

%disp(['event ' num2str(get(c,'this')) ' ' type]);

selname = getappdata(ax,'selname');
if isempty(selname)
  return
end

selection = getappdata(ax,'sel');
btn_down = getappdata(ax,'btn_down');

curpt = get(ax,'CurrentPoint');
if isfield(selection,'left') && isfield(selection,'right')
  winsize = selection.right-selection.left;
else
  winsize = 0;
end

switch type
  case 'btn_down'
    setappdata(ax,'oldsel',selection); % save the old selection
    % begin dragging
    selection = struct('begin',curpt(1,1));
    selection = tidysel(selection);
    btn_down = true;
    setappdata(ax,'sel',selection);
    setappdata(ax,'btn_down',btn_down);
    showSel(c,ax);
  case 'btn_up'
    oldsel = getappdata(ax,'oldsel');
    oldlen = oldsel.right-oldsel.left;
    selection.end = curpt(1,1);
    if ~isfield(selection,'begin') || selection.begin==selection.end
      selection = setmiddle(selection,curpt,oldlen);
    end
    btn_down = false;
    setappdata(ax,'sel',selection);
    setappdata(ax,'btn_down',btn_down);
    showSel(c,ax);
    %set(deref(c.model),selname,selection);
    call('set',c.model,selname,selection);
  case 'motion'
    if btn_down
      selection.end = curpt(1,1);
      selection = tidysel(selection);
      setappdata(ax,'sel',selection);
      showSel(c,ax);
    end
  otherwise
end


function sel = tidysel(sel)

if isfield(sel,'begin') && isfield(sel,'end')
  if sel.begin>sel.end
    sel.left = sel.end;
    sel.right = sel.begin;
  else
    sel.left = sel.begin;
    sel.right = sel.end;
  end
  if sel.begin==sel.end
    sel = struct;
  end
end

function sel = setmiddle(sel,curpt,winsize)
middle = curpt(1,1);
sel.left = middle-winsize/2;
sel.right = middle+winsize/2;

