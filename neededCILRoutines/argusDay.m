function day = argusDay(i)

%  argusDay -- create the argus "day" string
%
%   day = argusDay( I ) builds the day based on the
%   data found in I. I is either a double or string containing
%   the epoch time, or a struct with the field 'time'. 
%
%   The struct may contain other fields, which will be ignored.
%   A struct from parseFilename may be used as input to this
%   function.
%
%   Example: day = argusDay( 900000000 );
%            day = argusDay( '900000000' );
%            i.time = 900000000; day = argusDay( i );
%            day = '190_Jul.09';
%
%   $Id: argusDay.m 196 2016-06-02 20:47:36Z stanley $ 
%   $Log: argusDay.m,v $
%   Revision 1.12  2004/03/25 16:55:23  stanley
%   auto insert keywords
%

if isstruct(i)
	if ischar(i.time)
		when = str2num(i.time);
	else
		when = i.time;
	end
elseif ischar( i ) 
	when = str2num(i);
else
	when = i;
end

% oh bummer, cannot use ctime, ctime thinks in TZ
%timestr = ctime(i.time);
d = datevec(epoch2Matlab(when));
dmon = datestr(epoch2Matlab(when), 3);
jul = matlab2Julian( d );

day = sprintf('%03d_%s.%02d', jul, dmon, d(3) ); 
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

