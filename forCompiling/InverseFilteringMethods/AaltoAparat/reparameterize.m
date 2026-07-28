function reparameterize(n)
%
% REPARAMETERIZE Loop through all Aparat MAT-files and reparameterize them.
%
%

% $Id$

if nargin==0
  n=1;
end

m = model([],struct);

% open the current directory
m = set(m,'directory',pwd);

l = length(get(m,'filelist'));
for j=n:l
  % open the file in the model
  m = set(m,'curfile',j);
  cfn = get(m,'curfilename');
  disp(sprintf('%d/%d: %s',j,l,get(m,'curfilename')));
  
  % reparameterize
  % not needed - done when the file is opened
  
  % fit the lf-model
  m = makelffit(m);
  
  % save the results
  save(m);
  
end
