function bathy = analyzeSingleBathyRunUAV(fullStackName)
%
%  bathy = analyzeSingleBathyRun(fullStackName)
%
%  simple run of analyzeBathyCollect for a single stackName.  Useful for
%  debugging

SueEllenDefault         % set up params
load(fullStackName);
bathy.epoch = num2str(matlab2Epoch(stack.dn(1))); 
bathy.sName = fullStackName; bathy.params = params;
xyz = stack.xyzAll; epoch = matlab2Epoch(stack.dn');
data = stack.data;
NCol = size(data,2);
lastGood = find(~isnan(data(:,round(NCol/2))),1,'last');
data = data(1:lastGood,:);
bathy = analyzeBathyCollect(xyz, epoch, data, bathy);

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: analyzeSingleBathyRun.m,v 1.1 2012/09/24 23:08:04 stanley Exp $
%
% $Log: analyzeSingleBathyRun.m,v $
% Revision 1.1  2012/09/24 23:08:04  stanley
% Initial revision
%
%
%key 
%comment  
%
