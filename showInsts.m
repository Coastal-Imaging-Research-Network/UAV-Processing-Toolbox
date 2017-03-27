function showInsts(I,insts,beta, globs)
%   showInsts(I,insts,beta, globals)
%
% plot instrument locations on an image to confirm that they are proper

figure(3); clf
imagesc(I)
hold on

for i = 1: length(insts)
    xyz = [insts(i).xyzAll];
    UV = findUVnDOF(beta,xyz, globs);
    UV = reshape(UV,[],2);
    plot(UV(:,1),UV(:,2),'.')
end

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

