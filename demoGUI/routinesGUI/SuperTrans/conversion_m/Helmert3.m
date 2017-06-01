function [x1,y1,z1]=Helmert3(x0,y0,z0,dx,dy,dz)
%HELMERT3  Helmert 3-parameter transformation
%
%   This function performs a Helmert 3-parameter transformation
%
%   Syntax:
%   [x1,y1,z1]=Helmert3(x0,y0,z0,dx,dy,dz)
%
%   Input:
%   x0 \
%   y0  > input coordinates
%   z0 /
%   dx \
%   dy  > transformation
%   dz /
%
%   Output:
%   x1 \
%   y1  > output coordinates
%   z1 /
%
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

% $Id: Helmert3.m 3210 2010-10-29 13:52:34Z mol $
% $Date: 2010-10-29 15:52:34 +0200 (ven., 29 oct. 2010) $
% $Author: mol $
% $Revision: 3210 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/conversion_m/Helmert3.m $
% $Keywords: $

%%

x1 = x0 + dx;
y1 = y0 + dy;
z1 = z0 + dz;
