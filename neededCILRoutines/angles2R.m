function R = angles2R(a,t,s)

% R = angles2R(a,t,s)
% Makes rotation matrix from input azimuth, tilt, and swing (roll)
% From p 612 of Wolf, 1983
%

R(1,1) = cos(a) * cos(s) + sin(a) * cos(t) * sin(s);
R(1,2) = -cos(s) * sin(a) + sin(s) * cos(t) * cos(a);
R(1,3) = sin(s) * sin(t);
R(2,1) = -sin(s) * cos(a) + cos(s) * cos(t) * sin(a);
R(2,2) = sin(s) * sin(a) + cos(s) * cos(t) * cos(a);
R(2,3) = cos(s) * sin(t);
R(3,1) = sin(t) * sin(a);
R(3,2) = sin(t) * cos(a);
R(3,3) = -cos(t);

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

