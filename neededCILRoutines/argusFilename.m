function name = argusFilename(i1, i2, i3, i4, i5)

%  argusFilename -- create an Argus file name based on relevant data
%
%    name = argusFilename( I ) builds the name based on the
%    data found in I. I is (am?) a struct with the following
%    fields as a minimum:
%
%       i.time -- epoch time (string or number)
%       i.station -- name of station, e.g. 'argus00'
%       i.camera  -- camera number
%	i.type  -- type of the image, e.g. 'snap'
%	i.format -- format for the data, e.g. 'jpg'.
%
%    NOTE that this struct looks very much like the struct returned from
%    parseFilename. There is a reason for that. Fields not mentioned above
%    are ignored in building the filename. Also note that 'epoch' will
%    be treated as 'time' if 'time' is not present.
%
% OR
%    name = argusFilename( TIME, STATION, CAMERA, TYPE, FORMAT ) does
%    the same thing without the nice, clean, pretty, convenient, 
%    tidy, easy struct. Wouldn't you like to use structs? 
%
%  If 'camera' is specified as -1 (the number), the camera specification
%  will be ommitted from the resulting name. This is how you can build
%  names for runup, stereo, etc.
%
%  Note: Nothing checks to see if this file really exists. It's just
%  creating a name in the correct format.
%
%  Example: argusFilename( 9000, 'foobear', 1, 'snap', 'jpg' )
%     ans = 9000.Thu.Jan.01_02_30_00.GMT.1970.foobear.c1.snap.jpg
%

%   $Id: argusFilename.m 196 2016-06-02 20:47:36Z stanley $ 
%   $Log: argusFilename.m,v $
%   Revision 1.26  2012/01/31 23:04:49  stanley
%   fixed comments to remove version info
%
%   Revision 1.25  2008/11/22 00:02:58  stanley
%   fix creation of names with dot-terminal or two-dots
%
%   Revision 1.24  2008/09/12 21:46:13  stanley
%   added a DBTestConnect -- dies silently without DB access
%
%   Revision 1.23  2007/12/04 18:12:36  stanley
%   added error test for non-station
%
%   Revision 1.22  2006/05/09 22:19:05  stanley
%   added small rounding constant to datevec time
%
%   Revision 1.21  2006/05/02 17:16:56  stanley
%   missed one bit
%
%   Revision 1.20  2006/05/01 22:04:42  stanley
%   added fixes for localTZ for sites. ick...
%
%   Revision 1.19  2004/10/13 18:49:04  stanley
%   Deal with cx camera 'numbers'
%
%   Revision 1.18  2004/03/25 16:55:24  stanley
%   auto insert keywords
%

% recordPath;

% DBTestConnect;

if nargin == 5
	i.time = i1;
	i.station = i2;
	i.camera = i3;
	i.type = i4;
	i.format = i5;
elseif nargin == 1
	i = i1;
else
	error('Invalid input list');
end

% make 'epoch' a synonym for 'time'
try
	% look for 'time', ok if there
	t = getfield(i,'time'); 
catch
	% no 'time', look for 'epoch'
	try	
		t = getfield(i,'epoch');
	catch
		error('no time or epoch field in input');
	end
end
i.time = t;

if ischar( i.time ) 
	i.time = str2num(i.time);
end

% allow wildcard camera spec from empty camera
if isempty(i.camera)
	camData = '.c*';
% allow cx for multi-camera names
elseif ischar(i.camera)
	camData = ['.c' i.camera ];
% reverse the parseFilename of data type files -- they get -1 for camera
elseif (i.camera == -1)
	camData = '';
% all else just puts in camera number
else
	camData = [ '.c' num2str(i.camera) ];
end

% one last check -- time must be int
i.time = floor(i.time);

% Stefan, May 2002: Get TZname/offset from table site. If empty, than
% use default GMT
% station = DBGetStationsByName(i.station,i.time);
% if isempty(station)
	% no station by that name, punt!
	site.useLocalNames = 0;
	site.TZName = 'GMT';
	site.TZoffset = 0;
	warning( [ 'DB has no station ' i.station ', assuming GMT' ] );
% else
% 	site = DBGetTableEntry('site','id',station.siteID);
% end;
                                                                                
% If local TZstring in filename, than use that one & convert timestring
% to local time
% if site.useLocalNames
%     TZName = site.TZName;
%     TZoffset = site.TZoffset;
%     % end;
%     % if ~isempty(TZName) & ~isempty(TZoffset)
%     time = i.time+TZoffset*60;
% else
    TZName = 'GMT';
    time = i.time;
% end
                                                                                
% hey! what this 0.01 anyway!?!. 
% taking integer seconds into double matlab time results in quantizing
% error! int->double->datevec->round sometimes results in seconds
% of 59.99999, which should have been rounded by datevec into a
% normalized 0 seconds and +1 minutes. "floor" is wrong -- 59.99999
% should be 0 +1min and not 59. So, add very small time which should
% ALWAYS round out of the second pos but never cause rollover into
% minutes. Tried .5 (normal rounding) but example
% (1.131267000000000e+09) rounded to +1 second. Sigh. 
d = round(datevec(epoch2Matlab(time+0.01)));
dmon = datestr(epoch2Matlab(time), 3);
dday = datestr(epoch2Matlab(time), 8);

if isfield( i, 'short' )
	name = sprintf( ...
		['%d.%02d%02d%02d.%s%s.%s.%s'], ...
		i.time, ...
		d(4), ...
		d(5), ...
		d(6), ...
		i.station, ...
		camData, i.type, i.format );

else

	name = sprintf( ...
		['%d.%s.%s.%02d_%02d_%02d_%02d.%s.%4d.%s%s.%s.%s'], ...
		i.time, ...
		dday, ...
		dmon, ...
		d(3), ...
		d(4), ...
		d(5), ...
		d(6), ...
		TZName, ...
		d(1), ...
		i.station, ...
		camData, i.type, i.format );

end;

% one last fix. Empty type or format may leave double dots or dot at 
% end of name. remove.

if( name(end) == '.' )
	name = name(1:end-1);
end

boo = strfind(name, '..');
if ~isempty(boo)  
	for i=boo
		name = [name(1:i-1) name(i+1:end)];
	end
end 

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

