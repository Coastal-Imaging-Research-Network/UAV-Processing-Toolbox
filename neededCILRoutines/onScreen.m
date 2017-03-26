function yesNo = onScreen(U, V, Umax, Vmax)

% Usage:
%
%  yesNo = onScreen(U, V, UMax, VMax)
%
%  determines if pixel coordinates are located in an image.
%	U - column list of U pixel coords
%	V - column list of V pixel coords, same length
%       UMax,VMax - optional U and V max for image. If not present,
%	      assumes 640 by 480
%       yesNo - vector of logical true where pixel is on screen
%
%  if you do not provide Umax/Vmax, onScreen will leave a 10 pixel
%  border at the top and bottom of the image to avoid Argus text labels
%

if nargin == 2
	Umin = 1;
	Umax = 640;
	% leave a gap for labels at top and bottom of argus images.
	Vmin = 10;	
	Vmax = 470;
else
	Umin = 1;
	Vmin = 1;
end

%  make sure U V are columns of the same length
[n,m] = size(U);
if m > n
	U = U';
end

[n,m] = size(V);
if m > n
	V = V';
end

if (size(U,1) ~= size(V,1))
	error('U and V vectors not the same length')
	return
end

% start with NO
yesNo = zeros(size(U,1),1);

% find where is YES
on = find((U>=Umin) & (U<=Umax) & (V>=Vmin) & (V<=Vmax));

% and return a vector
yesNo(on) = ones(size(on));

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

