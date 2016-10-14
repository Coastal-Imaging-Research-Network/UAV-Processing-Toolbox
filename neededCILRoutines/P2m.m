function m = P2m(P);
%
%   m = P2m(P)
%
%  Converts from the projection matrix, P, to the equivalent m vector.

m = [P(1,:) P(3,1:3) P(2,:)];
