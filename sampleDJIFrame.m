function data = sampleDJIFrame(insts, I, beta, globs)
%   data = sampleDJIFrame(insts, I, beta, globs);
%
%  samples pixels from a grayshade frame, I, at pixels that are determined
%  by the instrument descriptions in insts, created by makeDJIInsts
%%U = 1:globs.lcp.NU;
%%V = 1:globs.lcp.NV;
if( isfield( insts, 'cams' ) )    % actually 'r'
    xyzAll = insts.cams(1).XYZ;
    data = nan(1,size(xyzAll,1));
    UV = round(findUVnDOF( beta, xyzAll, globs));
    UV = reshape(UV,[],2);
    good = find(onScreen(UV(:,1),UV(:,2),globs.lcp.NU,globs.lcp.NV));
    ind = sub2ind([globs.lcp.NV globs.lcp.NU], UV(good,2),UV(good,1));
    data(good) = I(ind);
else
    
    for i = 1: length(insts)
        data(i).I = nan(1,size(insts(i).xyzAll,1));
        UV = round(findUVnDOF(beta,insts(i).xyzAll,globs));
        UV = reshape(UV,[],2);
        good = find(onScreen(UV(:,1),UV(:,2),globs.lcp.NU,globs.lcp.NV));
        ind = sub2ind([globs.lcp.NV globs.lcp.NU],UV(good,2),UV(good,1));
        data(i).I(good) = I(ind);
    end
    
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

