function fr = makefr(lcp)
%   fr = makefr(lcp)
%
%  computes the radial stretch factor for lens distortion as a function of
%  normalized radius, for any lens calibration profile

% This is taken from an Adobe lcp file found on the web.  

% updated from previous version to reflect that this need only be computed
% once for any lcp, so should be stored in the lcp.

r2 = lcp.rd1.*lcp.rd1;
fr = 1 + lcp.d1*r2 + lcp.d2*r2.*r2 + lcp.d3*r2.*r2.*r2;
