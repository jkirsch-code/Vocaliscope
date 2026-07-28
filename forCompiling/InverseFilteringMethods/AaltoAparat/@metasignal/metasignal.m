function m = metasignal(varargin)
%function m = metasignal(vargin)
%Construct a Meta-Signal object
%   Should accept at least the following input:
%       - 'filename.wav' (TIMIT file)

%       - signal data (output of opentimit())

if nargin >= 1
    if isa(varargin{1}, 'char')
        [s, data] = opentimit(varargin{1});
        f = fieldnames(data);
        m = struct();
        for k=1:length(f)
            switch(f{k})
                case 's',
                    m.s = signal(s, data.sample_rate);
                otherwise,
                    m.(f{k}) = getfield(data, f{k});
            end            
        end
    end
end

m = class(m,'metasignal');
