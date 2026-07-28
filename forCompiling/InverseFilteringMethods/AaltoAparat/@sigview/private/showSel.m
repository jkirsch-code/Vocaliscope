function showSel(c,ax)

selection = getappdata(ax,'sel');
if isfield(selection,'left') && isfield(selection,'right') && ...
      (selection.right - selection.left > 0) 
  selh = findobj(ax,'Tag','selection');
    if selh ~= 0
      pos = get(selh,'Position');
      pos(1) = selection.left;
      pos(3) = selection.right-selection.left;
      set(selh,'Position',pos);
    else
      axes(ax);
      YLim=get(ax,'YLim');
      pos = [selection.left, YLim(1), selection.right-selection.left, YLim(2)- ...
	     YLim(1)];
      hr = rectangle('Position',pos,'FaceColor',[0, 0.4470, 0.7410],'LineStyle', ...
		'none','Tag','selection'); 

      %%% KIRSCH
        hr.FaceAlpha=0.2;
        hr.FaceColor=[0.1 0.1 0.1];
        uistack(hr,'bottom');
      %%%
      
    %reuna 'EdgeColor',[1 1 0.75],'Linewidth', 1,
%% does not quite work -- why?
%      line('XData',[selection.left selection.left], ...
%           'YData',[YLim(1) YLim(2)], ...
%           'Color','k','Tag','selection');
%      line('XData',[selection.right selection.right], ...
%           'YData',[YLim(1) YLim(2)], ...
%           'Color','k','Tag','selection');
      
      drawnow;
    end
else
  selh = findobj(ax,'Tag','selection');
  if selh ~= 0
    delete(selh);
  end
end
