function lcp = makeRadDist(lcp)
%   lcp = makeRadDist(lcp)
%
%  computes the radial stretch factor for lens distortion as a function of
%  normalized radius, for any lens calibration profile

% This is taken from an Adobe lcp file found on the web.  

% updated from previous version to reflect that this need only be computed
% once for any lcp, so should be stored in the lcp.

r = [0: 0.01: 2];   % max tan alpha likely to see.
r2 = r.*r;
fr = 1 + lcp.d1*r2 + lcp.d2*r2.*r2 + lcp.d3*r2.*r2.*r2;

% limit to increasing r-distorted (no folding back)
rd = r.*fr;
good = diff(rd)>0;      
lcp.r = r(good);
lcp.fr = fr(good);
