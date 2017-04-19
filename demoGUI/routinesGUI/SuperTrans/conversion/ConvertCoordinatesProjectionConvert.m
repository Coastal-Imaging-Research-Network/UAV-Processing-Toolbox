function [y1,x1] = ConvertCoordinatesProjectionConvert(x1,y1,CS,proj_conv,direction,STD)
% CONVERTCOORDINATESPROJECTIONCONVERT Performs a projection conversion
%
%   This routine performs the conversion of the projection, thus from 
%   projected to geographic or vice versa.
%
%   Syntax:
%   [y1,x1] = ...
%   ConvertCoordinatesProjectionConvert(x1,y1,CS,proj_conv,direction,STD)
% 
%   Input (watch the order: lon-lat / x-y (NOT lat-lon !):
%   x1          = input coordinate (x or lon)
%   y1          = input coordinate (y or lat)
%   CS          = coordinate system structure
%   proj_conv   = Structure with conversion parameters (code, name, method
%                 and param)
%   direction   = 'xy2geo' for projected to geographic, 
%                 'geo2xy' for geographic to projected
%   STD         = structure with all EPSG codes
%
%   Output:
%   y1          = output coordinate (y or lat)
%   x1          = output coordinate (x or lon)
%
%   See also CONVERTCOORDINATES

%   --------------------------------------------------------------------
%   Copyright (C) 2009 Deltares for Building with Nature
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

% $Id: ConvertCoordinatesProjectionConvert.m 5953 2012-04-12 09:11:21Z boer_g $
% $Date: 2012-04-12 11:11:21 +0200 (Thu, 12 Apr 2012) $
% $Author: boer_g $
% $Revision: 5953 $
% $HeadURL: https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/applications/SuperTrans/conversion/ConvertCoordinatesProjectionConvert.m $
% $Keywords: $

switch direction
    case 'xy2geo', iopt = 0;
    case 'geo2xy', iopt = 1;
end
    
param  = proj_conv.param;
method = proj_conv.method;
ell    = CS.ellips;

a    = ell.semi_major_axis;
invf = ell.inv_flattening;

switch method.name
    case 'Cassini-Soldner'
        ii = strcmp('False easting'                           ,param.name); fe    = convertUnits(param.value(ii),param.UoM.name{ii},'Clarke''s link',STD);
        ii = strcmp('False northing'                          ,param.name); fn    = convertUnits(param.value(ii),param.UoM.name{ii},'Clarke''s link',STD);
        ii = strcmp('Latitude of natural origin'              ,param.name); lat0  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Longitude of natural origin'             ,param.name); lon0  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        a = convertUnits(a,'foot','Clarke''s link',STD);
        
        [x1,y1]= CassiniSoldner(x1,y1,a,invf,fe,fn,lat0,lon0,iopt);
    
    case 'Krovak Oblique Conic Conformal'
    
        ii = strcmp('False easting'                            ,param.name); fe    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('False northing'                           ,param.name); fn    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('Latitude of projection centre'            ,param.name); latpc = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Azimuth of initial line'                  ,param.name); alphac= convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Latitude of pseudo standard parallel'     ,param.name); lat1  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Scale factor on pseudo standard parallel' ,param.name); sf    = param.value(ii);
        ii = strcmp('Longitude of origin'                      ,param.name); lon0  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        
        [x1,y1]= KrovakObliqueConformalConic(x1,y1,a,invf,fe,fn,latpc,alphac,lat1,sf,lon0,iopt);
        
    case 'Lambert Conic Conformal (2SP)'

        ii = strcmp('Longitude of false origin'               ,param.name); lonf  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Easting at false origin'                 ,param.name); fe    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('Latitude of false origin'                ,param.name); latf  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Northing at false origin'                ,param.name); fn    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('Latitude of 1st standard parallel'       ,param.name); lat1  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Latitude of 2nd standard parallel'       ,param.name); lat2  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);

        [x1,y1]= LambertConicConformal2SP(x1,y1,a,invf,lonf,fe,latf,fn,lat1,lat2,iopt);

    case 'Lambert Conic Conformal (2SP Belgium)'

        ii = strcmp('Longitude of false origin'               ,param.name); lonf  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Easting at false origin'                 ,param.name); fe    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('Latitude of false origin'                ,param.name); latf  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Northing at false origin'                ,param.name); fn    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('Latitude of 1st standard parallel'       ,param.name); lat1  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Latitude of 2nd standard parallel'       ,param.name); lat2  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);

        [x1,y1]= LambertConicConformal2SPBelgium(x1,y1,a,invf,lonf,fe,latf,fn,lat1,lat2,iopt);

    case 'Lambert Conic Conformal (1SP)'

        ii = strcmp('Latitude of natural origin'              ,param.name); lato  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Longitude of natural origin'             ,param.name); lono  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('False easting'                           ,param.name); fe    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('False northing'                          ,param.name); fn    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('Scale factor at natural origin'          ,param.name); ko    = param.value(ii);

        [x1,y1]= LambertConicConformal1SP(x1,y1,a,invf,lato,lono,fe,fn,ko,iopt);
        
    case 'Lambert Conic Conformal (West Orientated)'

        ii = strcmp('Latitude of natural origin'              ,param.name); lato  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Longitude of natural origin'             ,param.name); lono  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('False easting'                           ,param.name); fe    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('False northing'                          ,param.name); fn    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('Scale factor at natural origin'          ,param.name); ko    = param.value(ii);

        [x1,y1]= LambertConicConformalWO(x1,y1,a,invf,lato,lono,fe,fn,ko,iopt);

    case {'Transverse Mercator','Transverse Mercator (South Orientated)'}

        ii = strcmp('Scale factor at natural origin'          ,param.name); k0    = param.value(ii);
        ii = strcmp('False easting'                           ,param.name); FE    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('False northing'                          ,param.name); FN    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('Latitude of natural origin'              ,param.name); lat0  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Longitude of natural origin'             ,param.name); lon0  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);

        [x1,y1]= TransverseMercator(x1,y1,a,invf,k0,FE,FN,lat0,lon0,iopt);

    case 'Oblique Stereographic'

        ii = strcmp('Scale factor at natural origin'          ,param.name); k0    = param.value(ii);
        ii = strcmp('False easting'                           ,param.name); FE    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('False northing'                          ,param.name); FN    = convertUnits(param.value(ii),param.UoM.name{ii},'metre',STD);
        ii = strcmp('Latitude of natural origin'              ,param.name); lat0  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);                                          
        ii = strcmp('Longitude of natural origin'             ,param.name); lon0  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);

        [x1,y1]= ObliqueStereographic(x1,y1,a,invf,k0,FE,FN,lat0,lon0,iopt);

    case 'Oblique Mercator'

        ii = strcmp('Latitude of projection centre'           ,param.name); latc    = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Longitude of projection centre'          ,param.name); lonc    = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Azimuth of initial line'                 ,param.name); alphac  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Angle from Rectified to Skew Grid'       ,param.name); gammac  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);                                      
        ii = strcmp('Scale factor on initial line'            ,param.name); kc      = param.value(ii);      
        ii = strcmp('Easting at projection centre'            ,param.name); ec      = param.value(ii); 
        ii = strcmp('Northing at projection centre'           ,param.name); nc      = param.value(ii); 

        [x1,y1]= ObliqueMercator(x1,y1,a,invf,latc,lonc,alphac,gammac,kc,ec,nc,iopt);

    case 'Hotine Oblique Mercator'

        ii = strcmp('Latitude of projection centre'           ,param.name); latc    = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Longitude of projection centre'          ,param.name); lonc    = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Azimuth of initial line'                 ,param.name); alphac  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);
        ii = strcmp('Angle from Rectified to Skew Grid'       ,param.name); gammac  = convertUnits(param.value(ii),param.UoM.name{ii},'radian',STD);                                      
        ii = strcmp('Scale factor on initial line'            ,param.name); kc      = param.value(ii);      
        ii = strcmp('False easting'                           ,param.name); fe      = param.value(ii); 
        ii = strcmp('False northing'                          ,param.name); fn      = param.value(ii); 

        [x1,y1]= HotineObliqueMercator(x1,y1,a,invf,latc,lonc,alphac,gammac,kc,fe,fn,iopt);

    otherwise
        error(['conversion method ' method.name ' not (yet) supported'])
end
end
