function [geom, cam, ip] = lcpBeta2GeomCamIp( lcp, beta )

% function [cam, geom, ip] = lcpBeta2GeomCamIp( lcp, beta )
%
%   use the lcp and beta values to create the cam, geom, and ip structs
%   that the PIXEL toolbox uses to build a collect (findUV, findXYX). 

%  step 1, make a P, then get the m from it.
P = lcpBeta2P( lcp, beta );
m = P2m( P );

cam.cameraNumber = 1;
cam.x = beta(1);
cam.y = beta(2);
cam.z = beta(3);
cam.lcp = lcp;

geom.m = m;
geom.azimuth = beta(4);
geom.fov = -1;

ip.width  = lcp.NU;
ip.height = lcp.NV;


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
