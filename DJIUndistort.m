function [u,v] = DJIUndistort(ud,vd, lcp)
%   [u,v] = DJIUnDistort(ud,vd,lcp)
% 
% converts from distorted to undistorted pixel locations for a DJI phantom.
%  This is based on the Caltech cam cal equations.  This routine replaces
%  an obsolete version that mapped to and from chip space.

% find the range dependent correction factor, fr.
x = (ud-lcp.c0U)/lcp.fx;  
y = (vd-lcp.c0V)/lcp.fy;
r = sqrt(x.*x + y.*y);   % radius in distorted pixels
r2 = interp1(lcp.fr.*lcp.r,lcp.r,r);    % interp into distorted r space
if r~=0
    x2 = x./r.*r2;       % undistort range
    y2 = y./r.*r2;
    x3 = x2 - interp2(lcp.x,lcp.y,lcp.dx,x2,y2)./r.*r2;    % assume small dx
    y3 = y2 - interp2(lcp.x,lcp.y,lcp.dy,x2,y2)./r.*r2;
    u = x3*lcp.fx + lcp.c0U;
    v = y3*lcp.fy + lcp.c0V;
else
    u = ud;     % camera center pixel is unchanged by distortion
    v = vd;
end


