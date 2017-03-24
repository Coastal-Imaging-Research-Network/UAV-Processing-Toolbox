function P = lcpBeta2P( lcp, beta )

% function P = lcpBeta2P( lcp, beta )
%
%  create a P matrix from the lcp and beta
%
%   used by findUV6DOF and findXYZnDOF and to make things
%   for pixel toolbox geometry.

K = [lcp.fx 0 lcp.c0U;
     0 -lcp.fy lcp.c0V;
     0  0 1];

R = angles2R(beta(4), beta(5), beta(6));
IC = [eye(3) -beta(1:3)'];
P = K*R*IC;
P = P/P(3,4);   % unnecessary since we will also normalize UVs

return;


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
