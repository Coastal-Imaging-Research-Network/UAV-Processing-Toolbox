function [xh,yh,zh] = findHorizon(xo,yo,zo,az);
% find the coordinates of the horizon
% 
% [xh,yh,zh] = find_horizon(xo,yo,zo,az);
%
% Input
% xo,yo coordinates of observation point
%  zo, elevation above sealevel (meters) of observation point
%  az, azimuthal angles to horizon (az = 0) along y=const.
%
% Output
% xh, yh, zh, coodinates of horizon (z relative to sealevel!)
% only need to know the radius of the earth: 6378140 (m)

% first find distances centered on xo,yo
% earth's radius 
R = 6378140; % meters

% ERROR IN THESE EQUATIONS OCURRED prior to 8 Sept. 2000
% HERE ARE CORRECT EQUATIONS
% horizontal coordinate of horizon
ds = sqrt(zo*(zo+2*R))*R/(zo+R);
% distance below observation point
% SKIP GEOMETRIC COMPUTATION: dz = zo*(zo+2*R)/(zo+R);
% USE "Astro-Navigation by Calculator" by Levison, 1984
dip = (0.0293 * pi/180)*sqrt(zo); % VALID for zo in METERS
dz = ds*dip;

% elevation to horizon
zh = zo-dz + 0*az;
yh = ds*cos(az) + yo;
xh = ds*sin(az) + xo;
