function [x2,y2]= CassiniSoldner(x1,y1,a,finv,fe,fn,lat0,lon0,iopt)
%CASSINISOLDNER   map between (lon,lat) and (x,y) in Cassini-Soldner projection
%
%   map between (lon,lat) and (x,y) in Cassini-Soldner projection
%
%   Syntax:
%   [x2,y2]=...
%   CassiniSoldner(x1,y1,a,finv,fe,fn,lat0,lon0,iopt)
%
%   Input:
%   x1      =
%   y1      =
%   a       =
%   finv    =
%   fe      =
%   fn      =
%   lat0    =
%   lon0    =
%   iopt    = Set to 1 for geo2xy, else: xy2geo
% 
%   Output:
%   x2      =
%   y2      =
%
%See also: CONVERTCOORDINATES

%% Copyright notice
%   --------------------------------------------------------------------
%   Copyright (C) 2010 <COMPANY>
%       <NAME>
%
%       <EMAIL>	
%
%       <ADDRESS>
%
%   This library is free software: you can redistribute it and/or
%   modify it under the terms of the GNU Lesser General Public
%   License as published by the Free Software Foundation, either
%   version 2.1 of the License, or (at your option) any later version.
%
%   This library is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%   Lesser General Public License for more details.
%
%   You should have received a copy of the GNU Lesser General Public
%   License along with this library. If not, see <http://www.gnu.org/licenses/>.
%   --------------------------------------------------------------------

% This tool is part of <a href="http://OpenEarth.nl">OpenEarthTools</a>.
% OpenEarthTools is an online collaboration to share and manage data and 
% programming tools in an open source, version controlled environment.
% Sign up to recieve regular updates of this function, and to contribute 
% your own tools.

%% Version <http://svnbook.red-bean.com/en/1.5/svn.advanced.props.special.keywords.html>
% Created: 29 Oct 2010
% Created with Matlab version: 7.9.0.529 (R2009b)

% $Id: CassiniSoldner.m 3210 2010-10-29 13:52:34Z mol $
% $Date: 2010-10-29 15:52:34 +0200 (ven., 29 oct. 2010) $
% $Author: mol $
% $Revision: 3210 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/conversion_m/CassiniSoldner.m $
% $Keywords: $

%%
n1  = length(x1(:));
x2  = repmat(nan,size(x1));
y2  = repmat(nan,size(x1));

f=1/finv;
e2=2.0*f-f^2;
e=sqrt(e2);
e4=e2^2;
e6=e2^3;
eac2= e2/(1.0-e2);
M0  = a*((1.0 - e2/4.0 - 3.0*e4/64.0 - 5.0*e6/256.0)*lat0 -        ...
    (3.0*e2/8.0 +                                                  ...
    3.0*e4/32.0 + 45.0*e6/1024.0)*sin(2.0*lat0) + (15.0*e4/256.0 + ...
    45.0*e6/1024.0)*sin(4.0*lat0) - (35.0*e6/3072.0)*sin(6.0*lat0));

for i=1:n1
    if (iopt==1) % then
        %%          geo2xy
        lon=x1(i);
        lat=y1(i);
        M  = a*((1.0 - e2/4.0 - 3.0*e4/64.0 - 5.0*e6/256.0)*lat -          ...
            (3.0*e2/8.0 + 3.0*e4/32.0 + 45.0*e6/1024.0)*sin(2.0*lat) +         ...
            (15.0*e4/256.0 + 45.0*e6/1024.0)*sin(4.0*lat) -                    ...
            (35.0*e6/3072.0)*sin(6.0*lat));
        nu = a/(1-e2*(sin(lat)^2))^(0.5);
        C = e2 * cos(lat)^2/(1-e2);
        T = tan(lat)^2;
        A = (lon-lon0)*cos(lat);
        X = M-M0+nu*tan(lat)*(A^2/2+(5-T+6*C)*A^4/24);
        
        x2 = fe + nu*(A-T*A^3/6-(8-T+8*C)*T*A^5/120);
        y2 = fn + X;
        
        
    else
        %%          xy2geo
        x=x1(i);
        y=y1(i);
        
        e1  = (1.0 - (1.0 - e2)^0.5)/(1.0 + (1.0 - e2)^0.5);
        M1  = M0 + (y - fn);
        mu1 = M1/(a*(1.0 - e2/4.0 - 3.0*e4/64.0 - 5.0*e6/256.0));
        
        lat1 = mu1 + ((3.0*e1)/2.0 - 27.0*e1^3/32.0)*sin(2.0*mu1) +        ...
            (21.0*e1^2/16.0 -55.0*e1^4/32.0)*sin(4.0*mu1)+                     ...
            (151.0*e1^3/96.0)*sin(6.0*mu1) +                                   ...
            (1097.0*e1^4/512.0)*sin(8.0*mu1);
        rho1 = a*(1-e2)/(1-e2*sin(lat1)^2)^(1.5);
        nu1 = a/(1-e2*sin(lat1)^2)^(0.5);
        T1   = (tan(lat1))^2;
        D    = (x - fe)/nu1;
        
        lat = lat1 - (nu1*tan(lat1)/rho1)*(D^2/2-(1+3*T1)*D^4/24);
        lon = lon0 + (D-T1*D^3/3+(1+3*T1)*T1*D^5/15)/cos(lat1);
        
        x2 = lon;
        y2 = lat;
        
    end%if
    
end