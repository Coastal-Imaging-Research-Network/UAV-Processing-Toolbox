function [x1,y1,z1]=Helmert7(x0,y0,z0,dx,dy,dz,rx,ry,rz,ds)
%HELMERT7  Helmert 7-parameter transformation
%
%  
%
%   Syntax:
%   [x1,y1,z1]=Helmert7(x0,y0,z0,dx,dy,dz,rx,ry,rz,ds)
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
%   ds  scale factor
%
%   Output:
%   x1 \
%   y1  > output coordinates
%   z1 /
%See also: CONVERTCOORDINATES, HELMERT3
   
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

% $Id: Helmert7.m 3210 2010-10-29 13:52:34Z mol $
% $Date: 2010-10-29 15:52:34 +0200 (ven., 29 oct. 2010) $
% $Author: mol $
% $Revision: 3210 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/conversion_m/Helmert7.m $
% $Keywords: $

%%

m=1.0 + ds*0.000001;
      
x1 = m*(    x0 - rz*y0 + ry*z0) + dx;
y1 = m*( rz*x0 +    y0 - rx*z0) + dy;
z1 = m*(-ry*x0 + rx*y0 +    z0) + dz;
