function [x2,y2]= TransverseMercator(x1,y1,a,finv,k0,FE,FN,lat0,lon0,iopt)
%TRANSVERSEMERCATOR   map between (lon,lat) and (x,y) in transverse mercator projection
%
%   This routine maps between (lon,lat) and (x,y) in transverse mercator
%   projection
%
%   Syntax:
%   [x2,y2]= transversemercator(x1,y1,a,finv,k0,FE,FN,lat0,lon0,iopt)
%
%   Input:
%   x1
%   y1
%   a
%   finv
%   k0
%   FE
%   FN
%   lat0
%   lon0
%   iopt    = set to 1 for geo2xy, else: xy2geo
%
%   Ouput:
%   x2
%   y2
%
%See also CONVERTCOORDINATES

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

% $Id: TransverseMercator.m 4722 2011-06-27 10:18:08Z thijs@damsma.net $
% $Date: 2011-06-27 12:18:08 +0200 (lun., 27 juin 2011) $
% $Author: thijs@damsma.net $
% $Revision: 4722 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/conversion_m/TransverseMercator.m $
% $Keywords: $

%%
n1  = length(x1(:));
x2  = nan(size(x1));
y2  = nan(size(x1));

f=1/finv;
e2=2.0*f-f^2;
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
        T  = (tan(lat))^2;
        nu = a /(1.0 - e2*(sin(lat))^2)^0.5;
        C  = e2*(cos(lat))^2/(1.0 - e2);
        AA  = (lon - lon0)*cos(lat);
        M  = a*((1.0 - e2/4.0 - 3.0*e4/64.0 - 5.0*e6/256.0)*lat -          ...
            (3.0*e2/8.0 + 3.0*e4/32.0 + 45.0*e6/1024.0)*sin(2.0*lat) +         ...
            (15.0*e4/256.0 + 45.0*e6/1024.0)*sin(4.0*lat) -                    ...
            (35.0*e6/3072.0)*sin(6.0*lat));
        
        x2(i) =  FE + k0*nu*(AA + (1 - T + C)*AA^3/6.0 +                   ...
            (5.0 - 18.0*T + T^2 + 72.0*C - 58.0*eac2)*AA^5/120.0);
        
        y2(i) =  FN + k0*(M - M0 + nu*tan(lat)*(AA^2/2.0 +                 ...
            (5.0 - T + 9.0*C + 4.0*C^2)*AA^4/24.0 +                            ...
            (61.0 - 58.0*T + T^2 +                                             ...
            600.0*C - 330.0*eac2)*AA^6/720.0));
    else
        %%          xy2geo
        E=x1(i);
        N=y1(i);
        e1  = (1.0 - (1.0 - e2)^0.5)/(1.0 + (1.0 - e2)^0.5);
        M1  = M0 + (N - FN)/k0;
        mu1 = M1/(a*(1.0 - e2/4.0 - 3.0*e4/64.0 - 5.0*e6/256.0));
        lat1 = mu1 + ((3.0*e1)/2.0 - 27.0*e1^3/32.0)*sin(2.0*mu1) +        ...
            (21.0*e1^2/16.0 -55.0*e1^4/32.0)*sin(4.0*mu1)+                     ...
            (151.0*e1^3/96.0)*sin(6.0*mu1) +                                   ...
            (1097.0*e1^4/512.0)*sin(8.0*mu1);
        nu1  = a /(1.0 - e2*(sin(lat1))^2)^0.5;
        rho1 = a*(1.0 - e2)/(1.0 - e2*(sin(lat1))^2)^1.5;
        T1   = (tan(lat1))^2;
        C1   = eac2*(cos(lat1))^2;
        D    = (E - FE)/(nu1*k0);
        lat = lat1 - (nu1*tan(lat1)/rho1)*(D^2/2.0 - (5.0 +                ...
            3.0*T1 + 10.0*C1 - 4.0*C1^2 - 9.0*eac2)*D^4/24.0 + (61.0           ...
            + 90.0*T1 + 298.0*C1 + 45.0*T1^2 - 252.0*eac2 -                    ...
            3.0*C1^2)*D^6/720.0);
        lon = lon0 + (D - (1 + 2.0*T1 + C1)*D^3/6.0 + (5.0 -               ...
            2.0*C1 + 28.0*T1 - 3.0*C1^2 + 8.0*eac2 +                           ...
            24.0*T1^2)*D^5/120.0) / cos(lat1);
        x2(i)=lon;
        y2(i)=lat;
    end%if
end%do

end
