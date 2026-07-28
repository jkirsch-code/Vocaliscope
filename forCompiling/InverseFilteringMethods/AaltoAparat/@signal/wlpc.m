function [a, e, g] = wlpc(x,m,varargin)
% function [a, e] = wlpc(x,m,varargin)
% WLPC(X,M) is the M'th order Weighted Linear Predictive Coding model of
%        the input signal
% WLPC(X,M,'STE') uses Short Time Energy weighting (default)
% WLPC(X,M,'Teager',P) uses the Teager-Kaiser energy weighting with P'th
%        order derivative estimates
% WLPC(X,M,...,'mean',N) apply mean windowing to weighting function of
%        length N (default, N=2*M)
% WLPC(X,M,...,'lowpass',N,F) use lowpass filtering on weight with filter
%        order N and cut-off frequency F (radians)
% WLPC(X,M,...;'weightdelay',N) delay the weights by N (default, N=0)
%
% Outputs: a  model parameters
%          e  residual energy
%          g  gain
%
% References:
% Y. Kamp, C. Ma and L. F. Willems. "Robust signal selection for linear
% prediction analysis of voiced speech". Speech Communication, 12(1):69-81,
% March 1982.

% Tom Bäckström, Dec. 2005

% check inputs
numin = nargin-2;
if numin == 1 && iscell(varargin{1})
    varargin = {varargin{1}{:}};
    numin = length(varargin);
end
weightfn = 'ste';
filterfn = 'mean';
wdelay = 0;
n = 2*m;
while numin > 0
    fn = upper(varargin{1});
    varargin = {varargin{2:end}};
    numin = numin-1;
    switch fn
        case 'STE'
            weightfn = 'ste';
        case 'TEAGER'
            weightfn = 'teager';
            p = varargin{1}; 
            varargin = {varargin{2:end}};
            numin = numin-1;
        case 'MEAN'
            filterfn = 'mean';
            n = varargin{1}; 
            varargin = {varargin{2:end}};
            numin = numin-1;
        case 'LOWPASS'
            filterfn = 'lowpass';
            n = varargin{1}; 
            s = varargin{2};
            varargin = {varargin{3:end}};
            numin = numin-2;
        case 'WEIGHTDELAY'
            wdelay = varargin{1};
            numin = numin-1;
        otherwise
            error(['Unknown keyword ' fn]);
    end
end
if exist('m') && n+3 < m
    error('Model order must be larger than filter order by 3');
end

% calculate weights
switch weightfn
    case 'ste'
        w = x.^2;
    case 'teager'
        w = teager(x,p);
    otherwise
        error(['Unknown weighting function ' weightfn]);
end

% filter weights
switch filterfn
    case 'mean'
        fw = conv(signal(ones(1,n),w.time.fs),w);
    case 'lowpass'
        fw = conv(signal(fir1(n,s),w.time.fs),w);
    otherwise
        error(['Unknown filtering function ' filterfn]);
end
% compensate for filter delay
fw = shift(fw,-n/(2*x.time.fs));

% weight delay
fw = shift(fw,-wdelay/x.time.fs);

% signal matrix
x = trim(x,fw); % trim to same length as weight function
X = convmtx(x.s, m+1)';

% trim weight fn to correct length
fw = signal(fw.s(floor((length(fw.s)-length(x.s)-m)/2)+(1:length(x.s)+m)),fw.time.fs);
% modified autocorrelation matrix
R = X'*diag(fw.s)*X;

% calculate model
a = [1 zeros(1,m)]*inv(R);
e = a(1);
a = a/e; % normalise
g = sqrt(e);