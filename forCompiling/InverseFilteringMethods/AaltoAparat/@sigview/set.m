function a = set(a,varargin)

while length(varargin) >= 2
  prop = varargin{1};
  val = varargin{2};
  varargin = varargin(3:end);
  switch prop
   otherwise
    set(a.viewable,prop,val);
  end
end
