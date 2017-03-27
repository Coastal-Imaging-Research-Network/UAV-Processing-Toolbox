function [ud,vd] = distortCaltech(u,v,lcp)
%   [ud,vd] = DJIDistort(u,v,lcp)
% 
% converts from undistorted to distorted pixel locations for a DJI phantom.
%  This is based on equations from the Caltech lens distortion manuals.  
%  lcp contains all the relevant intrinsic as well as radial and tangential
%  distortion coefficients.

% written Dec 2015, updated from a now obsolete version that used a single
% lens calibration for the largest (chip size) image while converting from
% smaller image types.  This was found not to work for phantom 3s.

% find the range dependent correction factor, fr.
x = (u(:)-lcp.c0U)/lcp.fx;  % normalize to tanAlpha
y = (v(:)-lcp.c0V)/lcp.fy;
r2 = x.*x + y.*y;   % distortion found based on Large format units
fr = interp1(lcp.r,lcp.fr,sqrt(r2));
dx = interp2(lcp.x,lcp.y,lcp.dx,x,y);
dy = interp2(lcp.x,lcp.y,lcp.dy,x,y);
x2 = x.*fr + dx;
y2 = y.*fr + dy;
ud = x2*lcp.fx+lcp.c0U;       % answer in chip pixel units
vd = y2*lcp.fy+lcp.c0V;


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

