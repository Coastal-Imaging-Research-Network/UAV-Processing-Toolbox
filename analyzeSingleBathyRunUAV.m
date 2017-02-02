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

%
%   Copyright (C) 2017  Coastal Imaging Research Network
%                       and Oregon State University

%    This program is free software: you can redistribute it and/or  
%    modify it under the terms of the GNU General Public License as 
%    published by the Free Software Foundation, version 3 of the 
%    License.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see
%                                <http://www.gnu.org/licenses/>.

% CIRN: https://coastal-imaging-research-network.github.io/
% CIL:  http://cil-www.coas.oregonstate.edu
%
%key UAVProcessingToolbox
%

