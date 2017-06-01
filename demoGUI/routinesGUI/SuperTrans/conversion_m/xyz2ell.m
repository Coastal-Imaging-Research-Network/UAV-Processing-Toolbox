function [lat,lon,h]=xyz2ell(X,Y,Z,a,e2)
% XYZ2ELL  Converts cartesian coordinates to ellipsoidal. 
%
%   Converts cartesian coordinates to ellipsoidal. Uses iterative alogithm.
%   Vectorized.
%   Version: 25 Oct 96
%
%   Syntax:
%   [lat,lon,h]=xyz2ell(X,Y,Z,a,e2)
%
%   Input:   
%   x \
%   y  > vectors of cartesian coordinates in CT system (m)
%   z /
%   a   = ref. ellipsoid major semi-axis (m)
%   e2  = ref. ellipsoid eccentricity squared
% 
%   Output:  
%   lat = vector of ellipsoidal latitudes (radians)
%   lon = vector of ellipsoidal E longitudes (radians)
%   h   = vector of ellipsoidal heights (m)
%
% See also CONVERTCOORDINATES, XYZ2ELL2, XYZ2ELL3.

%% Copyright notice
%   --------------------------------------------------------------------
%   Borrowed from the Geodetic Toolbox by Mike Craymer 

%% Version <http://svnbook.red-bean.com/en/1.5/svn.advanced.props.special.keywords.html>
% Created: 29 Oct 2010
% Created with Matlab version: 7.9.0.529 (R2009b)

% $Id: xyz2ell.m 4722 2011-06-27 10:18:08Z thijs@damsma.net $
% $Date: 2011-06-27 12:18:08 +0200 (lun., 27 juin 2011) $
% $Author: thijs@damsma.net $
% $Revision: 4722 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/conversion_m/xyz2ell.m $
% $Keywords: $

%% Reshape to column vector

nx = size(X,1);
ny = size(Y,2);

X  = reshape(X,[nx*ny 1]);
Y  = reshape(Y,[nx*ny 1]);
Z  = reshape(Z,[nx*ny 1]);

% Conversion
elat = 1.e-12;
eht  = 1.e-5;
p    = sqrt(X.*X+Y.*Y);
lat  = atan2(Z,p./(1-e2));
h    = 0;
dh   = 1;
dlat = 1;
while sum(dlat>elat) || sum(dh>eht)
  lat0 = lat;
  h0   = h;
  v    = a./sqrt(1-e2.*sin(lat).*sin(lat));
  h    = p./cos(lat)-v;
  lat  = atan2(Z, p.*(1-e2.*v./(v+h)));
  dlat = abs(lat-lat0);
  dh   = abs(h-h0);
end
lon = atan2(Y,X);

%% Back to original shape

lat = reshape(lat,[nx ny]);
lon = reshape(lon,[nx ny]);
h   = reshape(h,  [nx ny]);
