function [lon2,lat2]=convertCoordinates_Singapore_SVY21(X,Y)
%convertCoordinates_Singapore_SVY21   custom coordinate projection for Singapore (epsg:3414)
%
%  [lon,lat]=convertCoordinates_Singapore_SVY21(X,Y)
%
% conversion of Singapore xy projected grid (SVY21) to lat lon coordinate WGS84
%
%See also: convertCoordinates, 
% http://spatialreference.org/ref/epsg/3414/,
% http://www.sla.gov.sg/htm/ser/ser0402.htm

%% Copyright notice
%   --------------------------------------------------------------------
%   Copyright (C) 2011 <COMPANY>
%       Maarten van Ormondt, Ann Sisomphon, Gerben de Boer
%
%       <EMAIL>	
%
%       <ADDRESS>
%
%   This library is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   This library is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this library.  If not, see <http://www.gnu.org/licenses/>.
%   --------------------------------------------------------------------

% This tool is part of <a href="http://www.OpenEarth.eu">OpenEarthTools</a>.
% OpenEarthTools is an online collaboration to share and manage data and 
% programming tools in an open source, version controlled environment.
% Sign up to recieve regular updates of this function, and to contribute 
% your own tools.

% $Id: convertCoordinates_Singapore_SVY21.m 5953 2012-04-12 09:11:21Z boer_g $
% $Date: 2012-04-12 11:11:21 +0200 (Thu, 12 Apr 2012) $
% $Author: boer_g $
% $Revision: 5953 $
% $HeadURL: https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/applications/SuperTrans/conversion/convertCoordinates_Singapore_SVY21.m $
% $Keywords: $

% PROJCS["SVY21 / Singapore TM",
%     GEOGCS["SVY21",
%         DATUM["SVY21",
%             SPHEROID["WGS 84",6378137,298.257223563,
a    = 6378137;
finv = 298.257223563;
%                 AUTHORITY["EPSG","7030"]],
%             AUTHORITY["EPSG","6757"]],
%         PRIMEM["Greenwich",0,
%             AUTHORITY["EPSG","8901"]],
%         UNIT["degree",0.01745329251994328,
%             AUTHORITY["EPSG","9122"]],
%         AUTHORITY["EPSG","4757"]],
%     UNIT["metre",1,
%         AUTHORITY["EPSG","9001"]],
%     PROJECTION["Transverse_Mercator"],
%     PARAMETER["latitude_of_origin",1.366666666666667],
lat0 =  1.366666666    .*pi./180; % radian
%     PARAMETER["central_meridian",103.8333333333333],
lon0 =103.8333333333333.*pi./180;
%     PARAMETER["scale_factor",1],
k0 = 1;
%     PARAMETER["false_easting",28001.642],
FE = 28001.642;
%     PARAMETER["false_northing",38744.572],
FN = 38744.572;
%     AUTHORITY["EPSG","3414"],
%     AXIS["Easting",EAST],
%     AXIS["Northing",NORTH]]
    
[lon,lat]= TransverseMercator(X,Y,a,finv,k0,FE,FN,lat0,lon0,2);

%% convert back to deg

lon2=lon.*180./pi;
lat2=lat.*180./pi;

% TO DO: implement in convertCoordinates
% use map code (3414=SVY21/TM projected, 4757=Singapore Geographic2D => transfer to the same globe reference)
% [lon,lat,log]=convertCoordinates(grid.X,grid.Y,'CS1.code',3414,'CS2.code',4757)
