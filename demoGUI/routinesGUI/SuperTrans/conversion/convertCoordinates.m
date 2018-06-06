function [x2,y2,varargout]=convertCoordinates(x1,y1,varargin)
%CONVERTCOORDINATES transformation between coordinate systems
%
% [x2,y2,<logs>] = convertCoordinatesNew(x1,y1,'keyword','value')
%
% Note 1: Beware of the Lon-Lat order of in- and output arguments!
% Note 2: (x1,y1) can be vectors or matrices.
% Note 3: Does not work for MatLab 7.0 and older (invalid MEX file warnings)
% Note 4: Dutch Rijksdriehoek(RD) to WGS 84 conversions are NOT exact.
%         Accuracy is better than 0.5m (plate tectonics), but multiple
%         conversions can mess things up.
%         For accurate conversions, see  <a href="http://www.rdnap.nl/">www.rdnap.nl/</a>
%
% x1,y1 : values of the coordinates to be transformed   , either X-Y or Lon-Lat.
% x2,y2 : values of the coordinates after transformation, either X-Y or Lon-Lat.
% logs  : contains all conversion parameters that were used.
%         To check this output, use 'var2evalstr(logs)'.
%
% Additionally, vector fields can be transformed. In this case, a vector rotation
% will be applied to correct for e.g. the difference between North in geographical
% coordinate systems and the y direction in projected coordinate systems.
% The third and fourth input argument must be matrices containing the u and v
% components of the original vector field. The third and fourth output argument are
% matrices of the u and v components of the corrected vector field.
%
% [x2,y2,u2,v2,<logs>] = convertCoordinatesNew(x1,y1,u1,v1,'keyword','value')
%
% Optionally the data structure with EPSG codes can be pre-loaded
% in the active memory, CONVERTCOORDINATES can be told to keep it 
% as persistent dataset.
%   To remove it from memory, see PERSISTENT, or issue clear all
% Both methods greatly speeds up the routine if many calls are made,
% so the call is either
%
%    EPSG        = load('EPSG');
%    [x2,y2,logs] = convertCoordinates(x1,y1,EPSG,'keyword','value')
%
%       or:
%
%    [x2,y2,logs] = convertCoordinates(x1,y1,'persistent','keyword','value')
%
%       or:
%
%    [x2,y2,logs] = convertCoordinates(x1,y1,     'keyword','value')
%
% The most important keyword value pairs are the identifiers for the
% coordinate systems:
%    (from) 'Coordinate System 1' (CS1)
%    (to)   'Coordinate System 2' (CS2).
%
% Any combination of name, type and code that identifies a unique
% coordinate system will do.
%
%    CS1.name = coordinate system name
%    CS1.code = coordinate system reference code
%    CS1.type = projection type
%
% When multiple coordinate systems fit the criteria, an error message is
% returned that lists these options. This can be an alternative method to
% search the EPSG database in addition to <a href="http://www.epsg-registry.org">www.epsg-registry.org</a>.
% E.g. to find your local UTM31 datum & zone: 
% [~,~]=convertCoordinates(0,0,'CS1.name','31','CS2.code',[])
%
% Projection types supported     : projected and geographic 2D
% Projection not (yet) supported : engineering, geographic 3D, vertical, geocentric,  compound
%
% Supported synonyms for 'projected'    : 'xy' ,'proj'  ,'cartesian','cart'
% Supported synonyms for 'geographic 2D': 'geo','latlon','lat lon'  ,'geographic','geographic2d'
%
% Example 1: 4 different notations of 1 single transformation case:
%
%    [x,y,logs]=convertCoordinates(5,52,'CS1.name','WGS 84','CS1.type','geo','CS2.name','WGS 84 / UTM zone 31N','CS2.type','xy')
%    [x,y,logs]=convertCoordinates(5,52,'CS1.code',4326                     ,'CS2.name','WGS 84 / UTM zone 31N')
%
%    ESPG = load('EPSG')
%
%    [x,y,logs]=convertCoordinates(52,5,EPSG,'CS1.name','WGS 84','CS1.type','geo','CS2.code',32631)
%    [x,y,logs]=convertCoordinates(52,5,EPSG,'CS1.code',4326                     ,'CS2.code',32631)
%
% Example 2: decimal degree to sexagesimal DMS conversion:
%
%   [lon,lat,logs]=convertCoordinates(52,5.5,'CS1.code',4326,'CS2.code',4326,'CS2.UoM.name','sexagesimal DMS')
%
% Example 3: Rijksdriehoek to WGS 84 including vector correction:
%
%   [lon,lat,u2,v2,logs]=convertCoordinates(200000,500000,10,15,'persistent','CS1.code',28992,'CS2.code',4326)
%
% Example 4: Rijksdriehoek to WGS 84 (COPY 'N PASTE READY):
%
%   [lon,lat,logs]=convertCoordinates(xRD,yRD,'CS1.code',28992,'CS2.code',4326)
%
% +-------+-----------------------------+---------------------------+
% | code  |  name                       |  type                     |
% +-------+-----------------------------+---------------------------+
% |  4326 | 'WGS 84'                    | 'geographic 2D' (lon,lat) |  To find
% |  4230 | 'ED50'                      | 'geographic 2D' (lon,lat) |  specifications of
% | 28992 | 'Amersfoort / RD New'       | 'projected'     (x,y)     |  more coordinate
% |  7415 | 'Amersfoort / RD New + NAP' | 'projected'     (x,y)     |  systems:
% | 32631 | 'WGS 84 / UTM zone 31N'     | 'projected'     (x,y)     |  (name <=> code):
% | 23031 | 'ED50 / UTM zone 31N'       | 'projected'     (x,y)     |  <a href="http://www.epsg-registry.org">www.epsg-registry.org</a>
% +-------+-----------------------------+---------------------------+
%
% See also: SuperTrans, EPSG.mat

% TO DO: add calling conversion dll's per chunk for LAAAAAAAAAArge matrices to avoid mex memory issues

%   --------------------------------------------------------------------
%   Copyright (C) 2009 Deltares for Building with Nature
%   Based on SuperTrans by Maarten van Ormondt (Maarten.vanOrmondt@deltares.nl).
%   Rewritten by
%
%       Thijs Damsma
%
%       Thijs.Damsma@deltares.nl
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

% $Id: convertCoordinates.m 8304 2013-03-08 17:03:36Z boer_g $
% $Date: 2013-03-08 18:03:36 +0100 (Fri, 08 Mar 2013) $
% $Author: boer_g $
% $Revision: 8304 $
% $HeadURL: https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/applications/SuperTrans/conversion/convertCoordinates.m $
% $Keywords: $

%% version check

   if datenum(version('-date'))<datenum(2007,1,1)
      warning('the matlab version your using might be to old for this function');
   end

%% check if EPSG codes are given
% Check if vector correction is required

   if isnumeric(varargin{1})
       % Vectors u and v are input
       vectorCorrection=1;
       u1=varargin{1};
       v1=varargin{2};
       for i=1:length(varargin)-2
           v{i}=varargin{i+2};
       end
       varargin=v;
   else
       vectorCorrection=0;
   end
       
   if odd(length(varargin))
       if strcmpi(varargin{1},'persistent')
           persistent EPSG
           if isempty(EPSG)
               EPSG = load('EPSG');
           end
       elseif isstruct(varargin{1})
           EPSG = varargin{1};
       end
       varargin(1) = [];
   else
       EPSG = load('EPSG');
   end

%% convert input to doubles

    if ~strcmp(class(x1),'double')||~strcmp(class(y1),'double')
    %     disp('warning: x1 and y1 are converted to double''s')
        x1 = double(x1);
        y1 = double(y1);
    end

%% get and set keyword value parameters

   OPT = [];
   OPT = FindCSOptions(OPT,EPSG,varargin{:});

%% Transform input coordinates to geographic 2D radians

   switch OPT.CS1.type
       case 'projected' % convert projection to geographic radians
           x1 = convertUnits(x1,OPT.CS1.UoM.name,'metre',EPSG);
           y1 = convertUnits(y1,OPT.CS1.UoM.name,'metre',EPSG);
           [lat1,lon1] = ConvertCoordinatesProjectionConvert(x1,y1,OPT.CS1,OPT.proj_conv1,'xy2geo',EPSG);
           if vectorCorrection
               x1v = convertUnits(x1,OPT.CS1.UoM.name,'metre',EPSG)+10; % End of vector is 10 m in positive x direction
               y1v = convertUnits(y1,OPT.CS1.UoM.name,'metre',EPSG);
               [lat1v,lon1v] = ConvertCoordinatesProjectionConvert(x1v,y1v,OPT.CS1,OPT.proj_conv1,'xy2geo',EPSG);
           end
       case 'geographic 2D' % do nothing, except for a unit conversion
           lon1 = convertUnits(x1,OPT.CS1.UoM.name,'radian',EPSG);
           lat1 = convertUnits(y1,OPT.CS1.UoM.name,'radian',EPSG);
           if vectorCorrection
               lon1v = convertUnits(x1,OPT.CS1.UoM.name,'radian',EPSG)+2e-6; % End of vector is 2e-6 radians to the East
               lat1v = convertUnits(y1,OPT.CS1.UoM.name,'radian',EPSG);
           end
   end

%% find datum transformation options
% check if geogcrs_code1 and geogcrs_code2 are different
%
% check if there is a direct transormation between geogcrs_code1 and
% geogcrs_code2;
%
% * if multiple options found, use the newest unless user has defined something else
% * if no direct transformation exists, convert via WGS 84

   OPT = ConvertCoordinatesFindDatumTransOpt(OPT,EPSG);
   
%% do datum transformation
%  OPT is also return argument to accomodate logging use of alternative transformations

   if ischar(OPT.datum_trans)
       if strcmpi(OPT.datum_trans,'no transformation available')
           error('No transformation methods available ...');
       elseif strcmpi(OPT.datum_trans,'no transformation required');
           % no transformation required
           lat2 = lat1;
           lon2 = lon1;
           if vectorCorrection
               lat2v = lat1v;
               lon2v = lon1v;
           end
       elseif strcmpi(OPT.datum_trans,'no direct transformation available');
           [lat2,lon2,OPT] = ConvertCoordinatesDatumTransform(lat1,lon1,OPT,'datum_trans_to_WGS84'  ,EPSG);
           [lat2,lon2,OPT] = ConvertCoordinatesDatumTransform(lat2,lon2,OPT,'datum_trans_from_WGS84',EPSG);
           if vectorCorrection
               [lat2v,lon2v,OPT] = ConvertCoordinatesDatumTransform(lat1v,lon1v,OPT,'datum_trans_to_WGS84'  ,EPSG);
               [lat2v,lon2v,OPT] = ConvertCoordinatesDatumTransform(lat2v,lon2v,OPT,'datum_trans_from_WGS84',EPSG);
           end
       end
   else
       [lat2,lon2,OPT] = ConvertCoordinatesDatumTransform(lat1,lon1,OPT,'datum_trans'          ,EPSG);
       if vectorCorrection
           [lat2v,lon2v,OPT] = ConvertCoordinatesDatumTransform(lat1v,lon1v,OPT,'datum_trans'          ,EPSG);
       end
   end

%% Transform geographic 2D radians to output coordinates

   switch OPT.CS2.type
       case 'projected' % convert projection to geographic radians
           [y2,x2] = ConvertCoordinatesProjectionConvert(lon2,lat2,OPT.CS2,OPT.proj_conv2,'geo2xy',EPSG);
           x2 = convertUnits(x2,'metre',OPT.CS2.UoM.name,EPSG);
           y2 = convertUnits(y2,'metre',OPT.CS2.UoM.name,EPSG);
           if vectorCorrection
               [y2v,x2v] = ConvertCoordinatesProjectionConvert(lon2v,lat2v,OPT.CS2,OPT.proj_conv2,'geo2xy',EPSG);
               x2v = convertUnits(x2v,'metre',OPT.CS2.UoM.name,EPSG);
               y2v = convertUnits(y2v,'metre',OPT.CS2.UoM.name,EPSG);
           end
       case 'geographic 2D'
           x2 = convertUnits(lon2,'radian',OPT.CS2.UoM.name,EPSG);
           y2 = convertUnits(lat2,'radian',OPT.CS2.UoM.name,EPSG);
           if vectorCorrection
               x2v = convertUnits(lon2v,'radian',OPT.CS2.UoM.name,EPSG);
               y2v = convertUnits(lat2v,'radian',OPT.CS2.UoM.name,EPSG);
           end
   end

%% force NaN to correct artefacts by e.g.
%  [lon,lat]=convertCoordinates(nan,nan,'CS1.code',28992,'CS2.code',4326)

   mask = isnan(x1) | isnan(y1);
   x2(mask) = NaN;
   y2(mask) = NaN;

%% Vector correction

   if vectorCorrection
       % Compute components of difference vector of CS1 and CS2 
       dx=x2v-x2;
       dy=y2v-y2;
       switch OPT.CS2.type
           case 'geographic 2D'
               % Correct for the fact that 1 degree longitude is shorter than
               % one degree latitude
               dx=dx.*cos(pi.*y2/180);
           otherwise
       end
       % Angle is difference between x direction in CS1 and CS2
       angle=atan2(dy,dx);
       % Rotate vector field
       u2=u1.*cos(angle)-v1.*sin(angle);
       v2=u1.*sin(angle)+v1.*cos(angle);
       % Set output arguments
       varargout{1}=u2;
       varargout{2}=v2;
       varargout{3}=OPT;
       varargout{4}=angle;
   else
       varargout{1}=OPT;
   end
   
   end

%% EOF
