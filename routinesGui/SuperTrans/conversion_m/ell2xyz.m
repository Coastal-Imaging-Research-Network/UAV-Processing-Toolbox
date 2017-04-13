function [x,y,z]=ell2xyz(lat,lon,h,a,e2)
%ELL2XYZ  Converts ellipsoidal coordinates to cartesian.
%
%   Converts ellipsoidal coordinates to cartesian (Vectorized). 
%   Version: 18 Jan 96
%
%   Syntax:
%   [x,y,z]=ell2xyz(lat,lon,h,a,e2)
%
%   Input:   
%   lat = vector of ellipsoidal latitudes (radians)
%   lon = vector of ellipsoidal E longitudes (radians)
%   h   = vector of ellipsoidal heights (m)
%   a   = ref. ellipsoid major semi-axis (m)
%   e2  = ref. ellipsoid eccentricity squared
% 
%   Output:  
%   x \
%   y  > vectors of cartesian coordinates in CT system (m)
%   z /
%
% See also CONVERTCOORDINATES

%% Copyright notice
%   --------------------------------------------------------------------
%   Borrowed from the Geodetic Toolbox by Mike Craymer 

%% Version <http://svnbook.red-bean.com/en/1.5/svn.advanced.props.special.keywords.html>
% Created: 29 Oct 2010
% Created with Matlab version: 7.9.0.529 (R2009b)

% $Id: ell2xyz.m 3210 2010-10-29 13:52:34Z mol $
% $Date: 2010-10-29 15:52:34 +0200 (ven., 29 oct. 2010) $
% $Author: mol $
% $Revision: 3210 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/conversion_m/ell2xyz.m $
% $Keywords: $

%%

v=a./sqrt(1-e2*sin(lat).*sin(lat));
x=(v+h).*cos(lat).*cos(lon);
y=(v+h).*cos(lat).*sin(lon);
z=(v.*(1-e2)+h).*sin(lat);
