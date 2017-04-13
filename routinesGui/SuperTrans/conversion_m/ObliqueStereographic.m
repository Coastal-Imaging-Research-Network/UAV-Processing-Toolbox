function [x2,y2]=ObliqueStereographic(x1,y1,a,finv,k0,fe,fn,lat0,lon0,iopt)
%OBLIQUESTEREOGRAPHIC   convert between (lon,lat) and (x,y) in oblique stereographic projection
%
%   This function converts between (lon,lat) and (x,y) in oblique 
%   stereographic projection
% 
%   Syntax:
%   [x2,y2]= ObliqueStereographic(x1,y1,a,finv,k0,fe,fn,lat0,lon0,iopt)
%
%   Input:
%   x1
%   y1
%   a
%   finv
%   k0
%   fe
%   fn
%   lat0
%   lon0
%   iopt    = set to 1 for geo2xy, else: xy2geo
% 
%   Output:
%   x2
%   y2
%
%See also CONVERTCOORDINATES

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

% $Id: ObliqueStereographic.m 3210 2010-10-29 13:52:34Z mol $
% $Date: 2010-10-29 15:52:34 +0200 (ven., 29 oct. 2010) $
% $Author: mol $
% $Revision: 3210 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/conversion_m/ObliqueStereographic.m $
% $Keywords: $

%% Reshape to column vector

nx=size(x1,1);
ny=size(x1,2);

x1=reshape(x1,[nx*ny 1]);
y1=reshape(y1,[nx*ny 1]);

x2=zeros(size(x1));
x2(x2==0)=NaN;
y2=x2;

%% Conversion

f = 1.0/finv;
e2 = 2.0*f-f^2;
e=sqrt(e2);

rho0=(a*(1.0 - e^2))/(1.0 - e^2*(sin(lat0))^2)^1.5;
nu0=a/sqrt(1.0 - e2*(sin(lat0))^2);
R= sqrt( rho0 * nu0);
n=  sqrt(1.0 + (e2*(cos(lat0))^4/(1.0 - e2)));
S1 = (1.0 + sin(lat0))/(1.0 - sin(lat0));
S2 = (1.0 - e*sin(lat0))/(1.0 + e*sin(lat0));
w1 = (S1*S2^e)^n;
chi0 = asin((w1-1)/(w1+1));
c =  ((n+sin(lat0))*(1.0 - sin(chi0)))/((n - sin(lat0))*(1.0 + sin(chi0)));
w2 = c*(S1*(S2)^e)^n;
chi0 = asin((w2 - 1.0)/(w2 + 1.0));
lambda0  = lon0;

for i=1:nx*ny

    if iopt==1
        % geo2xy
        lon=x1(i);
        lat=y1(i);
        lambda = n*(lon - lambda0) + lambda0;
        Sa = (1.0 + sin(lat))/(1.0 - sin(lat));
        Sb = (1.0 - e*sin(lat))/(1.0 + e*sin(lat));
        w = c*(Sa*(Sb)^e)^n;
        chi = asin((w - 1.0)/(w + 1.0));
        B = (1.0 + sin(chi)*sin(chi0) + cos(chi)*cos(chi0)*cos(lambda - lambda0));
        x2(i) = fe + 2.0*R*k0*cos(chi)*sin(lambda-lambda0)/B;
        y2(i) = fn + 2.0*R*k0*(sin(chi)*cos(chi0) - cos(chi)*sin(chi0)*cos(lambda - lambda0))/B;
    else
        % xy2geo
        east=x1(i);
        north=y1(i);
        g = 2.0*R*k0*tan(pi/4.0 - chi0/2.0);
        h = 4.0*R*k0*tan(chi0) + g;
        ii = atan((east - fe) / (h + (north - fn)));
        jj = atan((east - fe) / (g - (north - fn))) - ii;
        chi = chi0 + 2.0*atan(((north - fn) - (east - fe)*tan(jj/2.0))/(2.0*R*k0));
        lambda = jj + 2.0*ii + lambda0;
        lon = (lambda-lambda0 ) / n + lambda0;
        psi = 0.5*log ((1.0 + sin(chi)) / ( c*(1 - sin(chi)))) / n;
        % First approximation
        lati = 2*atan(exp(1.0)^psi) - pi/2.0;
        for k = 1:2
            psii = log(tan(lati/2.0 + pi/4.0) * ((1.0 - e*sin(lati))/(1.0 + e*sin(lati)))^(e/2.0));
            latip1 = lati - ( psii - psi )*cos(lati) * (1.0 - e^2*(sin(lati))^2) / (1.0 - e^2);
            lati = latip1;
        end
        x2(i)=lon;
        y2(i)=lati;
    end
end

%% Back to original shape

x2=reshape(x2,[nx ny]);
y2=reshape(y2,[nx ny]);
