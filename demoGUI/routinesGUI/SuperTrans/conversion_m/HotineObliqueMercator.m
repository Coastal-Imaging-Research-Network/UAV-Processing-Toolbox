function [x2,y2]=HotineObliqueMercator(x1,y1,a,finv,latc,lonc,alphac,gammac,kc,fe,fn,iopt)
% HOTINEOBLIQUEMERCATOR   One line description (hotine oblique mercator)
%
%   More detailed description
%
%   Syntax:
%   [x2,y2]=ObliqueMercator(x1,y1,a,finv,latc,lonc,alphac,gammac,kc,fe,fn,iopt)
%
%   Input:
%   x1
%   y1
%   a
%   finv
%   latc
%   lonc
%   alphac
%   gammac
%   kc
%   ec
%   nc
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

% $Id: HotineObliqueMercator.m 4722 2011-06-27 10:18:08Z thijs@damsma.net $
% $Date: 2011-06-27 12:18:08 +0200 (lun., 27 juin 2011) $
% $Author: thijs@damsma.net $
% $Revision: 4722 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/conversion_m/HotineObliqueMercator.m $
% $Keywords: $

%%
n1 =length(x1);

ee = 2.718281828;

f  = 1.0/finv;
e2 = 2.0*f-f^2;
e4 = e2^2;
e6 = e2^3;
e8 = e4^2;
e  = e2^.5;

B  = (1.0 + (e2 * (cos(latc))^4 / (1.0 - e2 )))^0.5;
AA = a * B * kc * (1.0 - e2 )^0.5 / ( 1.0 - e2 * (sin(latc))^2);
t0 = tan(pi/4 - latc/2) / ((1.0 - e*sin(latc)) / (1.0 + e*sin(latc)))^(e/2);
D  = B * (1 - e2)^0.5  / (cos(latc) * ( 1.0 -  e2*(sin(latc))^2)^0.5);

D2 = D^2;
if D<1.0
    D2 = 1.0;
end

if latc>=0
    FF = D + (D2 - 1.0)^0.5;
else
    FF = -D - (D2 - 1.0)^0.5;
end

H      = FF*t0^B;
G      = (FF - 1/FF) / 2;
gamma0 = asin(sin(alphac) / D);
lon0   = lonc - (asin(G*tan(gamma0))) / B;

for i=1:n1
    if iopt==1
        %           geo2xy
        lon   = x1(i);
        lat   = y1(i);

        t     = tan(pi/4 - lat/2) / ((1.0 - e * sin(lat)) / (1 + e * sin (lat)))^(e/2);
        Q     = H / t^B;
        S     = (Q - 1/Q) / 2;
        TT    = (Q + 1/Q) / 2;
        VV    = sin(B * (lon - lon0));
        UU    = (- VV * cos(gamma0) + S * sin(gamma0)) / TT;
        v     = AA * log((1 - UU) / (1 + UU)) / (2 * B);
        u     = (AA * atan((S * cos(gamma0) + VV * sin(gamma0)) / cos(B * (lon - lon0 ))) / B);

        x2(i) = v *cos(gammac) + u *sin(gammac) + fe;
        y2(i) = u *cos(gammac) - v *sin(gammac) + fn;

    else
        %           xy2geo
        east=x1(i);
        north=y1(i);

        v     = (east - fe) * cos(gammac) - (north - fn)*sin(gammac);
        u     = (north - fn)*cos(gammac) + (east - fe)*sin(gammac);

        Q     = ee^( - (B * v / AA));
        S     = (Q - 1 / Q) / 2;
        TT    = (Q + 1 / Q) / 2;
        VV    = sin (B* u / AA);
        UU    = (VV * cos(gammac) + S * sin(gammac)) / TT;
        t     = (H / ((1 + UU) / (1 - UU))^0.5)^(1 / B);

        chi   = pi / 2 - 2 * atan(t);

        lat   = chi + sin(2*chi)*( e2 / 2 + 5*e4 / 24 + e6 / 12 +  13*e8/360) +  sin(4*chi)*( 7*e4 /48 + 29*e6 / 240 +  811*e8 / 11520) +  sin(6*chi)*( 7*e6 / 120 + 81*e8 / 1120) + sin(8*chi)*(4279*e8 / 161280);
        lon   = lon0  - atan ((S* cos(gamma0) - VV* sin(gamma0)) / cos(B*u / AA)) / B;

        x2(i) = lon;
        y2(i) = lat;
    end
end
