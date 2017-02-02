function I2 = undistortDJISnap(I, whichDJIStr)
%   I2 = undistortDJISnap(I1, whichDJIStr)

[NV,NU,NC] = size(I);
lcp = makeLCPP2(whichDJIStr,NU,NV);
u = 1: NU;
v = 1: NV;
[U,V] = meshgrid(u,v);
[Ud,Vd] = DJIDistort(U(:),V(:),lcp);
foo = interp2(double(squeeze(I(:,:,1))),Ud,Vd);
I2(:,:,1) = reshape(foo, size(U));
foo = interp2(double(squeeze(I(:,:,2))),Ud,Vd);
I2(:,:,2) = reshape(foo,size(U));
foo = interp2(double(squeeze(I(:,:,3))),Ud,Vd);
I2(:,:,3) = reshape(foo,size(U));

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

