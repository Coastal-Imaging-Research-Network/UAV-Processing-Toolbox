function finalImages = makeFinalImages(images)
%   finalImages = makeFinalImages(images)
%
% takes an accumated images file and quickly calculates the timex, variance
% and other images

finalImages.dn = images.dn(1);
N = repmat(images.N,[1 1 3]);
finalImages.x = images.x;
finalImages.y = images.y;
finalImages.timex = uint8(images.sumI./N);
finalImages.bright = uint8(images.bright);
finalImages.dark = uint8(images.dark);

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

