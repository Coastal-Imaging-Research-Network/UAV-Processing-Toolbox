function lcp = makeTangDist(lcp)
%   lcp = makefr(lcpIn)
%
%  computes the tangential distortion over an expected domain x and y
%  in tan(alpha) coords that can be used for an interp2 for any required
%  set of x,y values

% This is taken from the Caltech cam cal docs.  
xmax = 1.5;     % no idea if this is good
dx = 0.1;
ymax = 1.3;
dy = 0.1;

lcp.x = -xmax: dx: xmax;
lcp.y = -ymax: dy: ymax;
[X,Y] = meshgrid(lcp.x,lcp.y);
X = X(:); Y = Y(:);
r2 = X.*X + Y.*Y;
lcp.dx = reshape(2*lcp.t1*X.*Y + lcp.t2*(r2+2*X.*X),[],length(lcp.x));
lcp.dy = reshape(lcp.t1*(r2+2*Y.*Y) + 2*lcp.t2*X.*Y,[],length(lcp.x));

