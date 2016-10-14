function xyz = DJIFindXYZ6dof(U, V, z, b, lcp)
%   xyz = DJIFindXYZ6dof(U, V, z, beta, lcp)
%
% finds the world coordinates corresponding to a DJI pixel at coords UV, at
% an equivalent vertical location specified by z.  beta is the six dof
% extrinsic parameters [xyzCam azimuth tilt roll] where angles are in
% radians.  lcp and image size NU, NV are also needed.

[u2,v2] = DJIUndistort(U(:),V(:),lcp);  % undistort

% build projection matrix in chip pixels
K = [lcp.fx 0 lcp.c0U;          % chip scale K
     0 -lcp.fy lcp.c0V;
     0  0 1];

R = angles2R(b(4), b(5), b(6));
IC = [eye(3) -b(1:3)'];
P = K*R*IC;
P = P/P(3,4);   % unnecessary since we will also normalize UVs
m = P2m(P);
xyz = findXYZ(m,[u2 v2], z, 3);

