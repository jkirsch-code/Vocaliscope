function varargout = call(method,varargin)

for i=1:length(varargin)
  if isa(varargin{i},'ref')
    h = varargin{i};
    break;
  end
end

if nargout>0
  varargout = {refvault(h,'call',method,i,varargin{:})};
else
  refvault(h,'call',method,i,varargin{:});
end
