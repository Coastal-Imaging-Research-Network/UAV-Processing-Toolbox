function dnum = epoch2Matlab( epoch )

% Usage:
%
%    dnum = epoch2Matlab( epoch )
%
%   convert a UNIX epoch time as used in the Argus system into a Matlab
%   datenum. You can convert the datenum to whatever you want.
%
%   WARNING: DANGER: UNIX epoch times are all GMT based, and the datenum
%   returned from this routine is GMT. 
%

% get reference time
unixEpoch = datenum( 1970, 1, 1, 0, 0, 0 );

% how much later than reference time is input?
offset = double(epoch) / (24*3600);

% add and return
dnum = unixEpoch + offset;

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

