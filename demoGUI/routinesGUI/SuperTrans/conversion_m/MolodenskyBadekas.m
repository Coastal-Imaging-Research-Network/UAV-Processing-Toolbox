function [x1,y1,z1]=MolodenskyBadekas(x0,y0,z0,dx,dy,dz,rx,ry,rz,xp,yp,zp,ds)
%MOLODENSKYBADEKAS  MolodenskyBadekas 10-parameter transformation
%
%  
%
%   Syntax:
%   [x1,y1,z1]=MolodenskyBadekas(x0,y0,z0,dx,dy,dz,rx,ry,rz,xp,yp,zp,ds)
%
%   Input:
%   x0 \
%   y0  > input coordinates
%   z0 /
%   dx \
%   dy  > transformation
%   dz /
%   rx \
%   ry  > rotation
%   rz /
%   xp \
%   yp  > coordinates of the point about which the coordinate reference frame is rotated, given in the source Cartesian coordinate reference system.
%   zp /
%   ds  scale factor
%
%   Output:
%   x1 \
%   y1  > output coordinates
%   z1 /
%See also: CONVERTCOORDINATES, HELMERT7
   
%% Copyright notice
%   --------------------------------------------------------------------
%   Copyright (C) 2010 Deltares for Building with Nature
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

%% Version <http://svnbook.red-bean.com/en/1.5/svn.advanced.props.special.keywords.html>
% Created: 29 Oct 2010
% Created with Matlab version: 7.9.0.529 (R2009b)

% $Id: MolodenskyBadekas.m 3220 2010-11-01 12:44:24Z thijs@damsma.net $
% $Date: 2010-11-01 13:44:24 +0100 (lun., 01 nov. 2010) $
% $Author: thijs@damsma.net $
% $Revision: 3220 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/conversion_m/MolodenskyBadekas.m $
% $Keywords: $

%%

m=1.0 + ds*0.000001;
    
x1 = m*(    (x0-xp) - rz*(y0-yp) + ry*(z0-zp)) + xp + dx;
y1 = m*( rz*(x0-xp) +    (y0-yp) - rx*(z0-zp)) + yp + dy;
z1 = m*(-ry*(x0-xp) + rx*(y0-yp) +    (z0-zp)) + zp + dz;
