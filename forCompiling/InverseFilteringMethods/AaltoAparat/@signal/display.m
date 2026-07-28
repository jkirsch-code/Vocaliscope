function display(X)
% DISPLAY  Display a signal object

% length (samples)
% duration (seconds)
% fs
% time begin
% validity

% $Id: display.m 53 2005-01-05 11:17:56Z mairas $

if length(X)>1
  disp(' ');
  disp([inputname(1),' = '])
  disp(' ');
  disp(['   ' num2str(size(X,1)) 'x' num2str(size(X,2)) ...
	' array of signal objects.']);
else
  if X.valid==-1
    val = 'undefined';
  elseif X.valid==1
    val = 'all';
  else
    val = ['after ' num2str(X.valid-1) ' samples'];
  end

  disp(' ');
  disp([inputname(1),' = '])
  disp(' ');
  
  s = sprintf( ...
      [ '   signal object:\n' ...
	'      length: %d\n' ...
	'      duration: %f s\n' ...
	'      sampling frequency: %d Hz\n' ...
	'      beginning time: %f s\n' ...
	'      validity: %s' ], ...
      len(X), len(X)/X.time.fs, X.time.fs, X.time(1), val );
  
  disp(s);
end
