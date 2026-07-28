function a = set(a,varargin)
% SET Set SPECTRUM properties and return the updated object

% $Id: set.m 113 2006-06-14 12:40:22Z mairas $

property_argin = varargin;
while length(property_argin) >= 2,
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
    case 'frequency'
        a.frequency = val;
    case 's'
        a.s = val;
    otherwise
        error('invalid property for spectrum')
    end
end
