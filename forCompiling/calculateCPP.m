function [CPPout]=calculateCPP(s,t,doPlot,windowType,lowerQuefrencyFitLimit,upperQuefrencyFitLimit,maxInsideFitRegion,fitTypesToUse,robustMethodsToUse)
% [CPPlin,CPPparabolic,CPPexp]=deal([]);

if nargin<4 || isempty(doPlot)
    doPlot=0;
end

if nargin<5 || isempty(windowType)
    windowType='hann';
end

if nargin<6 || isempty(lowerQuefrencyFitLimit)
    lowerQuefrencyFitLimit=0.001;
end

if nargin<7 || isempty(upperQuefrencyFitLimit)
    upperQuefrencyFitLimit=inf;
end

if nargin<8 || isempty(maxInsideFitRegion)
    maxInsideFitRegion=1;
end

if nargin<9 || isempty(fitTypesToUse)
    fitTypes={'poly1'};
elseif strcmpi(fitTypesToUse,'all')
    fitTypes={'poly1','poly2','exp1'};
else
    fitTypes={fitTypesToUse};
end

if nargin<10 || isempty(robustMethodsToUse)
    methods={'bisquare'};
elseif strcmpi(robustMethodsToUse,'all')
    methods={'off','LAR','bisquare'};
else
    methods={robustMethodsToUse};
end

if isscalar(t) % if t was given as sampling frequency
    t=(0:numel(s)-1)/(1/t);
end

t=t(:); s=s(:);

switch windowType
    case 'hann'
        window=hann(numel(s));
    case 'hamming'
        window=hamming(numel(s));
    otherwise % no windowing
        window=ones(size(s));
end

s=s.*window;

CPS=20*log10(abs(fft(20*log10(abs(fft(s))))));

CPS(isinf(CPS))=0;

if all(s==0)
    CPS(:)=0;
end

% the cepstrum is symmetric, we need only half of it
t=t(1:ceil(end/2));
CPS=CPS(1:ceil(end/2));
%% fit of the quefrencies values

CPPout(1:numel(fitTypes))=struct('value',[],'method',[],'goodnessOfFit',[],'fitShape',[]);


for fitTypeNr=1:numel(fitTypes)

    %disp(['CPP: fitting method ' fitTypes{fitTypeNr}]);

    if doPlot
        figure;
        ax=gca;
        plot(ax,t,CPS,'k','DisplayName','dB Cepstrum');
    end

    fitX=t(t>lowerQuefrencyFitLimit & t<upperQuefrencyFitLimit);



    CPP=nan(size(methods));
    gofCell=cell(size(methods));
    for methodNr=1:numel(methods)

        try
            %disp(['CPP: robust method ' methods{methodNr}]);

            warning('off','curvefit:fit:iterationLimitReached');
            [fitObj,gof]=fit(fitX,CPS((t>lowerQuefrencyFitLimit & t<upperQuefrencyFitLimit)),fitTypes{fitTypeNr},'Robust',methods{methodNr});
            warning('on','curvefit:fit:iterationLimitReached');

            fitY=fitObj(fitX);

            if doPlot
                hold on;
                plot(ax,fitX,fitY,'DisplayName',sprintf('robust method %s, R^2: %.3f',methods{methodNr},gof.rsquare));
            end
            % get max
            if maxInsideFitRegion
                [maxVal,maxIdx]=max(CPS(t>lowerQuefrencyFitLimit & t<upperQuefrencyFitLimit));
                CPP(methodNr)=maxVal-fitY(maxIdx);
            else
                [maxVal,maxIdx]=max(CPS);
                fitY=fitObj(t(maxIdx));
                CPP(methodNr)=maxVal-fitY;
            end
            gofCell{methodNr}=gof;

        catch ME
            disp(ME.getReport());
            CPP(methodNr)=NaN;
            gofCell{methodNr}=NaN;
            continue;
        end


    end

    if doPlot

        if maxInsideFitRegion
            xline(ax,fitX(maxIdx),'--k','DisplayName','peak position');
        else
            xline(ax,t(maxIdx),'--k','DisplayName','peak position');
        end

        title(ax,sprintf('CPP with %s fit is %.2f, %.2f or %.2f dB',fitTypes{fitTypeNr},CPP));
        legend(ax,'Location','northeast');

        ylabel(ax,'Cesptrum (dB)')
        xlabel(ax,'Quefrency (s)')
    end

    % if strcmpi(fitTypes{fitTypeNr},'poly1')
    CPPout(fitTypeNr).value=CPP;
    CPPout(fitTypeNr).method=methods;
    CPPout(fitTypeNr).goodnessOfFit=gofCell;
    CPPout(fitTypeNr).fitShape=fitTypes{fitTypeNr};
    % elseif strcmpi(fitTypes{fitTypeNr},'poly2')
    %     CPPparabolic.value=CPP;
    %     CPPparabolic.method=methods;
    %     CPPparabolic.goodnessOfFit=gofCell;
    % else
    %     CPPexp.value=CPP;
    %     CPPexp.method=methods;
    %     CPPexp.goodnessOfFit=gofCell;
    % end

end
end
