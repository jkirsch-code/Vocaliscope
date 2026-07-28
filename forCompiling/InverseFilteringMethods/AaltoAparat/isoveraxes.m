function y = isoveraxes(point,XLim,YLim)

if point(1,1)>XLim(1) && point(1,1)<XLim(2) && ...
      point(1,2)>YLim(1) && point(1,2)<YLim(2)
  y = true;
else
  y = false;
end