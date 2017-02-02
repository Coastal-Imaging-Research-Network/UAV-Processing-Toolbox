function lcp = makeRadDist(lcp)
%   lcp = makeRadDist(lcp)
%
%  computes the radial stretch factor for lens distortion as a function of
%  normalized radius, for any lens calibration profile

% This is taken from an Adobe lcp file found on the web.  

% updated from previous version to reflect that this need only be computed
% once for any lcp, so should be stored in the lcp.

r = [0: 0.01: 2];   % max tan alpha likely to see.
r2 = r.*r;
fr = 1 + lcp.d1*r2 + lcp.d2*r2.*r2 + lcp.d3*r2.*r2.*r2;

% limit to increasing r-distorted (no folding back)
rd = r.*fr;
good = diff(rd)>0;      
lcp.r = r(good);
lcp.fr = fr(good);

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

