function update(c,event)

switch event
 case {'init','glottal_flow'}
   plotvocaltract(c);
 case 'destroy'
  try
    fig = get(c.axes,'Parent');
    delete(fig);
  catch
  end
 otherwise
end


function plotvocaltract(c)

% get filter
hvt = get(deref(c.model),'hvt');

% compute area function
A = atoarea(hvt);

% convert areas to diameters
d = sqrt(A);

try 
  axes(c.axes);
  hold off
  bar(d/2);
  hold on
  bar(-d/2);
  
catch
  destroy(c);
end
