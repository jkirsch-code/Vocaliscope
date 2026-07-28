function a = set(a,varargin)
% SET Set signal properties and return the updated object
%
%    A=SET(A,prop1,val1,prop2,val2,...) sets properties to their
%    respective values. Allowed properties are:
%
%      time
%      s
%      fs
%      valid

% $Id: set.m 53 2005-01-05 11:17:56Z mairas $

property_argin = varargin;
while length(property_argin) >= 2,
  prop = property_argin{1};
  val = property_argin{2};
  property_argin = property_argin(3:end);
  switch prop
   case 'time'
    a.time = val;
   case 's'
    a.s = val;
   case 'fs'
    a.time = set(a.time,'fs',val);
   case 'valid'
    a.valid = val;
   case 'begin'
    a.time = set(a.time,'begin',val);        
   otherwise
    error(['invalid property: ' prop])
  end
end
