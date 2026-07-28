function c = detach(c,obshnd)

%for i = 1:length(c.observers)
%  if isa(c.observers{i},'ref') && c.observers{i} == obshnd
%    c.observers{i} = [];
%  end
%end

c.observers = {c.observers{find(c.observers ~= obshnd)}};


store(c); % save myself after modifying the object
