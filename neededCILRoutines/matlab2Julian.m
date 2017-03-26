function julian = matlab2Julian(yyyy, mm, dd, hr, min, sec)

% Usage:
%
%  julian = matlab2Julian(yyyy, mm, dd, hr, min, sec)
%  or
%  julian = matlab2Julian(date_vec)
%  or
%  julian = matlab2Julian(datenum)
%  or
%  julian = matlab2Julian(datestring)
%
%	where date_vec is a 1x6 vector from the call datevec
%             datenum is a Matlab Datenum
%             datestring is a string understandable by datenum
%
%  Returns the Julian day for any human time.  
%
%  DANGER: WARNING: input times are assumed to be GMT.
%
%  WARNING: DANGER: If the year is less than 38, we assume 2000's, if
%   less than 100 1900's. Dissavow all decadence of the Y2K issue and
%   use four digit years! Show your disdain! 
%  

% convert input into a datenum
% if one input parameter, either datevec or datenum or string
if nargin == 1
	% look for a string
	if ischar(yyyy)
		in = datenum(yyyy);
	% this is a datevec
	elseif length(yyyy) == 6
		if yyyy(1) < 38
			yyyy(1) = yyyy(1) + 2000;
		elseif yyyy(1) < 100
			yyyy(1) = yyyy(1) + 1900;
		end
		in = datenum( yyyy(1), yyyy(2), yyyy(3), ...
			      yyyy(4), yyyy(5), yyyy(6) );
	% else it is a datenum
	elseif length(yyyy) == 1
		in = yyyy;
	else
		error('invalid datenum or datevec input')
	end
% look for abbreviated form "yy mm dd"
elseif nargin == 3
	if yyyy < 38
		yyyy = yyyy + 2000;
	elseif yyyy < 100
		yyyy = yyyy + 1900;
	end
	in = datenum(yyyy, mm, dd);
% now look for full yymmddhhmmss
elseif nargin == 6
	if yyyy < 38
		yyyy = yyyy + 2000;
	elseif yyyy < 100
		yyyy = yyyy + 1900;
	end
	in = datenum(yyyy, mm, dd, hr, min, sec);
else
	error( 'invalid input to function');
end

% get back a year from our input datenum
year = str2num(datestr(in,10));

% get the datenum for 1/1/year 0:0:0
epoch = datenum( year, 1, 1, 0, 0, 0 );

julian = fix(in - epoch) + 1;

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

