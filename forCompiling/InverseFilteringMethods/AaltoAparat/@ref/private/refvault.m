function varargout = refvault(h,cmd,varargin)

persistent reftable;

switch cmd
 case 'get'
  varargout{1} = reftable{h.hnd};
 case 'set'
  reftable{h.hnd} = varargin{1};
 case 'next'
  varargout{1} = length(reftable)+1;
 case 'free'
  reftable{h.hnd} = [];
 case 'call'
  method = varargin{1};
  i = varargin{2};
  varargin{i+2} = reftable{h.hnd};
  if nargout>0
    varargout = {feval(method,varargin{3:end})};
  else
    feval(method,varargin{3:end});
  end
end
