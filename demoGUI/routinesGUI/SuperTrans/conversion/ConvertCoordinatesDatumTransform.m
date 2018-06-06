function [lat2,lon2,OPT] = ConvertCoordinatesDatumTransform(lat1,lon1,OPT,datum_trans,EPSG)
%CONVERTCOORDINATESDATUMTRANSFORM Datum transformation
%
%   Performs the specified datum transformation for a set of coordinates
%
%   Syntax:
%  [lat2,lon2] =
%  ConvertCoordinatesDatumTransform(lat1,lon1,OPT,datum_trans,EPSG)
%
%   Input:
%   lat1        = input latitude
%   lon1        = input longitude
%   OPT         = structure with input and output coordinate system and 
%                 tranformation information.
%   datum_trans = string specifying if the transformation goes via WGS84:
%                 'datum_trans'            : direct transformation
%                 'datum_trans_to_WGS84'   : transformation to WGS84
%                 'datum_trans_from_WGS84' : transformation from WGS84
%   EPSG        = structure with all EPSG codes
%
%   Output:
%   lat2        = output latitude
%   lon2        = output longitude
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

% $Id: ConvertCoordinatesDatumTransform.m 5953 2012-04-12 09:11:21Z boer_g $
% $Date: 2012-04-12 11:11:21 +0200 (Thu, 12 Apr 2012) $
% $Author: boer_g $
% $Revision: 5953 $
% $HeadURL: https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/applications/SuperTrans/conversion/ConvertCoordinatesDatumTransform.m $
% $Keywords: $

switch OPT.(datum_trans).direction
    case 'normal',  inv =  1;
    case 'reverse', inv = -1;
end

param       = OPT.(datum_trans).params;
method_name = OPT.(datum_trans).method_name;
ell1        = OPT.(OPT.(datum_trans).ellips1).ellips;
ell2        = OPT.(OPT.(datum_trans).ellips2).ellips;

datum_ok = 0;

switch method_name

    case {  'Geocentric translations',...
            'Geocentric translations (geog2D domain)',...
            'Position Vector 7-param. transformation',...
            'Position Vector transformation (geog2D domain)',...
            'Coordinate Frame rotation',...
            'Coordinate Frame Rotation (geog2D domain)',...
            'Molodensky-Badekas 10-parameter transformation',...
            'Molodensky-Badekas (geog2D domain)',...
            'NADCON',...
            'NTv2'}

            % convert geographic 2D coordinates to geographic 3D, by assuming
            % height is 0
            h    = zeros(size(lat1));

            % convert geographic 3D coordinates to geocentric coordinates
            a      = ell1.semi_major_axis;
            invf   = ell1.inv_flattening;
            f      = 1/invf;
            e2     = 2*f-f^2;
            [x,y,z]= ell2xyz(lat1,lon1,h,a,e2);

        switch method_name

            case {'Geocentric translations',...
                  'Geocentric translations (geog2D domain)'}

                dx = inv*getParamValue(param,'X-axis translation','metre',EPSG);
                dy = inv*getParamValue(param,'Y-axis translation','metre',EPSG);
                dz = inv*getParamValue(param,'Z-axis translation','metre',EPSG);

                [x,y,z]=Helmert3(x,y,z,dx,dy,dz);
                
                datum_ok = 1;

            case {'Position Vector 7-param. transformation',...
                  'Position Vector transformation (geog2D domain)',...
                  'Coordinate Frame rotation',...
                  'Coordinate Frame Rotation (geog2D domain)'}

                dx = inv*getParamValue(param,'X-axis translation','metre' ,EPSG);
                dy = inv*getParamValue(param,'Y-axis translation','metre' ,EPSG);
                dz = inv*getParamValue(param,'Z-axis translation','metre' ,EPSG);
                rx = inv*getParamValue(param,'X-axis rotation'   ,'radian',EPSG);
                ry = inv*getParamValue(param,'Y-axis rotation'   ,'radian',EPSG);
                rz = inv*getParamValue(param,'Z-axis rotation'   ,'radian',EPSG);
                ds = inv*getParamValue(param,'Scale difference'  ,''      ,EPSG);

                if any(strcmp(method_name,{'Coordinate Frame rotation','Coordinate Frame Rotation (geog2D domain)'}))
                    rx=rx*-1;
                    ry=ry*-1;
                    rz=rz*-1;
                end

                [x,y,z]=Helmert7(x,y,z,dx,dy,dz,rx,ry,rz,ds);
                
                datum_ok = 1;

            case {'Molodensky-Badekas 10-parameter transformation',...
                  'Molodensky-Badekas (geog2D domain)'} 

                dx = inv*getParamValue(param,'X-axis translation'            ,'metre' ,EPSG);
                dy = inv*getParamValue(param,'Y-axis translation'            ,'metre' ,EPSG);
                dz = inv*getParamValue(param,'Z-axis translation'            ,'metre' ,EPSG);
                rx = inv*getParamValue(param,'X-axis rotation'               ,'radian',EPSG);
                ry = inv*getParamValue(param,'Y-axis rotation'               ,'radian',EPSG);
                rz = inv*getParamValue(param,'Z-axis rotation'               ,'radian',EPSG);
                ds = inv*getParamValue(param,'Scale difference'              ,''      ,EPSG);
                xp =     getParamValue(param,'Ordinate 1 of evaluation point',''      ,EPSG);
                yp =     getParamValue(param,'Ordinate 2 of evaluation point',''      ,EPSG);
                zp =     getParamValue(param,'Ordinate 3 of evaluation point',''      ,EPSG);

                [x,y,z]=MolodenskyBadekas(x,y,z,dx,dy,dz,rx,ry,rz,xp,yp,zp,ds);
                
                datum_ok = 1;

            case 'NADCON'
                
%                [x,y,z]=NADCON(x,y,z);

                fprintf(2,['Warning: Datum transformation method ''' method_name ''' not yet supported, please see: http://www.ngs.noaa.gov/TOOLS/Nadcon/Nadcon.html.\n']);
                
                datum_ok = 0;
        
            case 'NTv2' % external mapping grid
                % http://www.geod.nrcan.gc.ca/tools-outils/ntv2_e.php
                % http://jgridshift.sourceforge.net/ntv2.html

                if any(OPT.CS1.code==[31466 31467 314668 31469])
                   fprintf(2,['Warning: Datum transformation method ''' method_name ''' not yet supported, you might try finishing work on NTv2_read.m.\n']);
                end

                datum_ok = 0;

        end

        % convert geocentric coordinates to geographic 3D coordinates 
        a     = ell2.semi_major_axis;
        invf  = ell2.inv_flattening;
        f     = 1/invf;
        e2    = 2*f-f^2;
        [lat2,lon2,h]=xyz2ell(x,y,z,a,e2);

        % and just forget about h...
        
    otherwise
        warning(['Datum transformation method ''' method_name ''' not yet supported!']);
        
end

%% if failed, retry with available alternatives, if not deprecated,
%  and mention alternative to logging

  if strcmpi(datum_trans,'datum_trans') & ~(datum_ok) 
    if isfield(OPT.(datum_trans),'alt')
       error(['Warning: Datum transformation method ''' method_name ''' not yet supported, and no alternatives available!']);
    end
    if isfield(OPT.(datum_trans),'alt_code')
       ialt = 1;
       nalt = length(OPT.(datum_trans).alt_code);
       OPT.(datum_trans).alt = 0;
       while ~(datum_ok)
         if  (ialt >= nalt)
           error(['Warning: Datum transformation method ''' method_name ''' not yet supported, and no alternatives available!']);
         end
    
         OPT.datum_trans_failed.code        = OPT.(datum_trans).code       ;
         OPT.datum_trans_failed.name        = OPT.(datum_trans).name       ;
         OPT.datum_trans_failed.direction   = OPT.(datum_trans).direction  ;
         OPT.datum_trans_failed.deprecated  = OPT.(datum_trans).deprecated ;
         OPT.datum_trans_failed.scope       = OPT.(datum_trans).scope      ;
         OPT.datum_trans_failed.accuray     = OPT.(datum_trans).accuray    ;
         OPT.datum_trans_failed.params      = OPT.(datum_trans).params;
         OPT.datum_trans_failed.method_code = OPT.(datum_trans).method_code;
         OPT.datum_trans_failed.method_name = OPT.(datum_trans).method_name;

         OPT.(datum_trans).code             = OPT.(datum_trans).alt_code       (ialt);
         OPT.(datum_trans).name             = OPT.(datum_trans).alt_name       {ialt};
         OPT.(datum_trans).direction        = OPT.(datum_trans).alt_direction  {ialt};
         OPT.(datum_trans).deprecated       = OPT.(datum_trans).alt_deprecated {ialt};
         OPT.(datum_trans).scope            = OPT.(datum_trans).alt_scope      {ialt};
         OPT.(datum_trans).accuray          = OPT.(datum_trans).alt_accuray    {ialt};
         OPT.datum_trans.params             = ConvertCoordinatesFindDatumTransParams(OPT.(datum_trans).code,EPSG);
         OPT.(datum_trans).method_code      = OPT.(datum_trans).alt_method_code(ialt);
         OPT.(datum_trans).method_name      = OPT.(datum_trans).alt_method_name{ialt};
         
         try
            if strcmpi(OPT.(datum_trans).deprecated,'false')
              [lat2,lon2,OPT] = ConvertCoordinatesDatumTransform(lat1,lon1,OPT,datum_trans,EPSG);
              datum_ok = 1;
              OPT.(datum_trans).alt = 1;
              warning(['Warning: Alternative datum transformation method ''' OPT.(datum_trans).method_name ''' used. (#',num2str(ialt),' of ',num2str(nalt),')']);
              ialt = ialt+1;
            else
              ialt = ialt+1;
            end
         catch
            ialt = ialt+1;
         end
          
      end
    else
        error(['Warning: Datum transformation method ''' method_name ''' not yet supported, and no alternatives available!']);
    end
  end

%% 
function val = getParamValue(param,name,unit,STD)

ii = strmatch(name,param.name);
if ~isempty(unit)
    val = convertUnits(param.value(ii),param.UoM.sourceN{ii},unit,STD);
else
    val = param.value(ii);
end


