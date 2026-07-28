function a = set(a,varargin)
% SET Set FREQUENCY properties and return the updated object

% $Id: set.m 85 2005-08-31 12:36:23Z mairas $

property_argin = varargin;
while length(property_argin) >= 2,
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
    case 'begin'
        a.begin = val;
    case 'num'
        a.num = val;
    case 'fs'
        a.fs = val;
    otherwise
        error('invalid property for frequency')
    end
end
