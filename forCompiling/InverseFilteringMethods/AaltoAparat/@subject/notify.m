function notify(c,event)

%disp(event);

for i=1:length(c.observers)
  obs = c.observers{i};
  call('update',obs,event);
end
