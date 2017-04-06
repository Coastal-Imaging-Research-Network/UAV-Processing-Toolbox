function d = DJIReadInternalData( file )

%  function d = DJIReadInternalData( file )
%
%   where file = name of DJI snapshot image
%         d = struct output with name/value pairs
%
%   DJI stores a few handy things in the snapshot in an XML
%   format string, not EXIF. X/Y/Z speeds, elevations, and 
%   angles of the aircraft and camera (gimbal). 
%
%  Note: the gimbal angles are relative to ground, not the
%  airframe! Very nice. 

% look through the jpeg file for 'drone-dji:' tags. 
%  return a struct with field/value pairs for all of them.

% read the file as text
ft = fileread( file ); 

% find all the 'dji-drone:' strings
dd = strfind( ft, 'drone-dji:' );

%%

for ii = 1:length(dd)
    tstart = dd(ii)+10;
    tlen = min(strfind(ft(tstart:tstart+128),'='))-2;
    tag = ft(tstart:tstart+tlen);

    vstart = tstart+tlen+3;
    vlen = min(strfind(ft(vstart:vstart+50),'"')-2);
    val = ft(vstart:vstart+vlen);
    
    d.(tag) = val;
    
end


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

