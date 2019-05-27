function OPT=FindCSOptions(OPT,STD,varargin)
%FINDCSOPTIONS   SuperTrans GUI function
%
%   See also: SUPERTRANS

%% Copyright notice
%   --------------------------------------------------------------------
%   Copyright (C) 2008 Deltares
%       Maarten van Ormondt
%
%       Maarten.vanOrmondt@deltares.nl	
%
%       Deltares
%       P.O. Box 177
%       2600 MH Delft
%       The Netherlands
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

% This tool is part of <a href="http://OpenEarth.nl">OpenEarthTools</a>.
% OpenEarthTools is an online collaboration to share and manage data and 
% programming tools in an open source, version controlled environment.
% Sign up to recieve regular updates of this function, and to contribute 
% your own tools.

%% Version <http://svnbook.red-bean.com/en/1.5/svn.advanced.props.special.keywords.html>
% Created: 27 Oct 2010
% Created with Matlab version: 7.9.0.529 (R2009b)

% $Id: FindCSOptions.m 5352 2011-10-19 15:21:06Z thijs@damsma.net $
% $Date: 2011-10-19 17:21:06 +0200 (mer., 19 oct. 2011) $
% $Author: thijs@damsma.net $
% $Revision: 5352 $
% $HeadURL: https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/applications/SuperTrans/gui/FindCSOptions.m $
% $Keywords: $

%%
OPT.CS1.name                    = []; % coordinate system name
OPT.CS1.code                    = []; % coordinate system reference code 
OPT.CS1.type                    = []; % projection type
                                      % projection types supported:
                                      % projected, geographic 2D
                                      %
                                      % projection not (yet) supported:
                                      % engineering, geographic 3D, vertical, geocentric,  compound
                                      %
                                      % allowed synonyms for 'projected'are:
                                      % 'xy','proj','cartesian','cart'
                                      % allowed sysnonyms for 'geographic '2D' are:
                                      % 'geo','geographic2d','latlon','lat lon','geographic'
                                      
OPT.CS1.geoRefSys.name          = []; % associated geographic reference system name
OPT.CS1.geoRefSys.code          = []; % associated geographic reference system code
OPT.CS1.coordSys.name           = []; %
OPT.CS1.coordSys.code           = []; %
                                      
OPT.CS1.ellips.name             = []; % ellipsoide name
OPT.CS1.ellips.code             = []; % ellipsoide code
OPT.CS1.ellips.inv_flattening   = []; % inverse flattening
OPT.CS1.ellips.semi_major_axis  = []; % semi major axis
OPT.CS1.ellips.semi_minor_axis  = []; % semi minor axis
                                      
OPT.CS1.UoM.name                = []; % unit of measure name of coordinates
OPT.CS1.UoM.code                = []; % unit of measure code of coordinates
                                      
OPT.proj_conv1                  = [];
OPT.proj_conv1.name             = []; % projection to datum conversion name
OPT.proj_conv1.code             = []; % projection to datum conversion code
OPT.proj_conv1.param.val        = []; % conversion paramter values
OPT.proj_conv1.param.code       = []; % conversion paramter codes
OPT.proj_conv1.param.name       = []; % conversion paramter names 

OPT.datum_trans                 = [];
OPT.datum_trans.code            = []; %
OPT.datum_trans_to_WGS84.code   = []; %
OPT.WGS84                       = []; % properties of WGS84 ellipsoide for intermediate conversion
OPT.datum_trans_from_WGS84.code = []; %

OPT.proj_conv2                  = [];
OPT.proj_conv2.name             = []; % projection to datum conversion name
OPT.proj_conv2.code             = []; % projection to datum conversion code
OPT.proj_conv2.param.val        = []; % conversion paramter values
OPT.proj_conv2.param.code       = []; % conversion paramter codes
OPT.proj_conv2.param.name       = []; % conversion paramter names 

OPT.CS2.name                    = []; 
OPT.CS2.code                    = []; 
OPT.CS2.type                    = []; 
OPT.CS2.geoRefSys.name          = []; 
OPT.CS2.geoRefSys.code          = []; 
OPT.CS2.coordSys.name           = []; 
OPT.CS2.coordSys.code           = []; 
OPT.CS2.ellips.name             = []; 
OPT.CS2.ellips.code             = []; 
OPT.CS2.ellips.inv_flattening   = []; 
OPT.CS2.ellips.semi_major_axis  = []; 
OPT.CS2.ellips.semi_minor_axis  = []; 
OPT.CS2.UoM.name                = []; 
OPT.CS2.UoM.code                = []; 

[OPT, Set, Default]     = setproperty(OPT,varargin);

OPT.CS1 = ConvertCoordinatesCheckInput(OPT.CS1,STD);
OPT.CS2 = ConvertCoordinatesCheckInput(OPT.CS2,STD);

%% find coordinate reference system
OPT.CS1 = ConvertCoordinatesFindCoordRefSys(OPT.CS1,STD);
OPT.CS2 = ConvertCoordinatesFindCoordRefSys(OPT.CS2,STD);

%% find coordinate system
OPT.CS1 = ConvertCoordinatesFindCoordSys(OPT.CS1,STD);
OPT.CS2 = ConvertCoordinatesFindCoordSys(OPT.CS2,STD);

%% find coordinate system unit of measure
OPT.CS1 = ConvertCoordinatesFindUoM(OPT.CS1,STD);
OPT.CS2 = ConvertCoordinatesFindUoM(OPT.CS2,STD);

%% find geographic reference system
OPT.CS1 = ConvertCoordinatesFindGeoRefSys(OPT.CS1,STD);
OPT.CS2 = ConvertCoordinatesFindGeoRefSys(OPT.CS2,STD);

%% find datum
OPT.CS1 = ConvertCoordinatesFindDatum(OPT.CS1,STD);
OPT.CS2 = ConvertCoordinatesFindDatum(OPT.CS2,STD);

%% find ellips
OPT.CS1 = ConvertCoordinatesFindEllips(OPT.CS1,STD);
OPT.CS2 = ConvertCoordinatesFindEllips(OPT.CS2,STD);

%% find conversion parameters
switch OPT.CS1.type
    case 'projected' % Coordinate conversion to radians
        OPT.proj_conv1 = ConvertCoordinatesFindConversionParams(OPT.CS1,STD);
    case 'geographic 2D' % do nothing
        OPT.proj_conv1 = 'no projection conversion necessary';
    otherwise, error(['CRS type ''' OPT.CS1.type ''' not supported (yet)',sprintf('\n\n'),var2evalstr(OPT)])
end

switch OPT.CS2.type
    case 'projected' % Coordinate conversion to radians
        OPT.proj_conv2 = ConvertCoordinatesFindConversionParams(OPT.CS2,STD);
    case 'geographic 2D' % do nothing
        OPT.proj_conv2 = 'no projection conversion necessary';
    otherwise, error(['CRS type ''' OPT.CS1.type ''' not supported (yet)',sprintf('\n\n'),var2evalstr(OPT)])
end
