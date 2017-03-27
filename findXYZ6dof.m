function xyz = findXYZ6dof(U, V, z, b, lcp)
%   xyz = findXYZ6dof(U, V, z, beta, lcp)
%
% finds the world coordinates corresponding to a DJI pixel at coords UV, at
% an equivalent vertical location specified by z.  beta is the six dof
% extrinsic parameters [xyzCam azimuth tilt roll] where angles are in
% radians.  lcp and image size NU, NV are also needed.

[u2,v2] = undistort(U(:),V(:),lcp);  % undistort

% build projection matrix in chip pixels
P = lcpBeta2P( lcp, b );

m = P2m(P);
xyz = findXYZ(m,[u2 v2], z, 3);


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

