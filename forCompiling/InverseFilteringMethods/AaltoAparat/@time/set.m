function a = set(a,varargin)
% SET Set TIME properties and return the updated object

% $Id: set.m 47 2004-09-09 08:01:57Z mairas $

property_argin = varargin;
while length(property_argin) >= 2,
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
    case 'begin'
        a.beg = val;
    case 'num'
        a.num = val;
    case 'fs'
        a.fs = val;
    otherwise
        error('invalid property for time')
    end
end
