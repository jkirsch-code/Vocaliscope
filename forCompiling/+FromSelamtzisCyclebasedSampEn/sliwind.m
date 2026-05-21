function [sl,time,N,Llastwin,indecesofcurrentwindow]=sliwind(y,winsize,n,over)
%A function to make a sliding window
%Usage [wind,timeind,howmany,lastwinlength]=sliwind(Signal,WindowSize,WindowNumber,Overlap)
%n takes values between length(y)

L=length(y);

Nnover=length(1:winsize:L);

N=length(1:(winsize-over):L);

time=1:(winsize-over):L;

time=time(1:end)+floor(winsize/2);

time=time(time<=L);

Llastwin=length(y((N-1)*winsize+1-(N-1)*over:end));

% if mod(Llastwin,2)==0
%     time(end+1)=length(y)-floor(Llastwin/2)+1;
% else
%     time(end+1)=length(y)-floor(Llastwin/2);
% end

if n==1
    sl=y(1:winsize);
    indecesofcurrentwindow=1:winsize;

elseif n>1 & (n-1)*winsize+winsize-(n-1)*over<=L

    sl=y( (n-1)*winsize+1-(n-1)*over : (n-1)*winsize+winsize-(n-1)*over );
    indecesofcurrentwindow=(n-1)*winsize+1-(n-1)*over : (n-1)*winsize+winsize-(n-1)*over;
    
elseif (n-1 )*winsize+winsize-(n-1)*over>L & (n-1)*winsize+1-(n-1)*over<L

    sl=y((n-1)*winsize+1-(n-1)*over:end);
    indecesofcurrentwindow=(n-1)*winsize+1-(n-1)*over:L;

else
    
    disp(['Warning: only ' num2str(N-1) ' full windows of this size fit to the signal and a last window of ' num2str(Llastwin) ' points.'])
    sl=[];

end
