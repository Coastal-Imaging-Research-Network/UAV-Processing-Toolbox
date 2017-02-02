function lcp = makeTangDist(lcp)
%   lcp = makefr(lcpIn)
%
%  computes the tangential distortion over an expected domain x and y
%  in tan(alpha) coords that can be used for an interp2 for any required
%  set of x,y values

% This is taken from the Caltech cam cal docs.  
xmax = 1.5;     % no idea if this is good
dx = 0.1;
ymax = 1.3;
dy = 0.1;

lcp.x = -xmax: dx: xmax;
lcp.y = -ymax: dy: ymax;
[X,Y] = meshgrid(lcp.x,lcp.y);
X = X(:); Y = Y(:);
r2 = X.*X + Y.*Y;
lcp.dx = reshape(2*lcp.t1*X.*Y + lcp.t2*(r2+2*X.*X),[],length(lcp.x));
lcp.dy = reshape(lcp.t1*(r2+2*Y.*Y) + 2*lcp.t2*X.*Y,[],length(lcp.x));


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

