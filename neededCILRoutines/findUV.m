function [U,V] = findUV( m, X )

% Usage:
%       [U,V] = findUV(m,X) 
%
%       returns image coordinates of real world coordinates
%
%       input:  m = the DLT coefficient vector A->L
%               X = [N,3] maxtrix (real world coords)
%       output: [U,V] = [N,2] array of image coordinates
%
%

% stolen from geometry5, reformatted to make it obvious

%  Check that the survey coordinates are valid
[N, M] = size(X);
if ((N == 3) & (M~=3))  % matrix transposed
        X = X';
end
if (size(X,2) ~= 3)
        error('Invalid survey coordinates entered into FindUV')
end

% check that m is valid
m = m(:);		% force to a column vector
if length(m) ~= 11 	% invalid geometry
        error('Invalid geometry supplied to findUV')
end

%  Carry out the equivalent vectorized calculation of
%       U = Ax + By + Cz + D / Ex + Fy + Gz + 1;
%       V = Hx + Jy + Kz + L / Ex + Fy + Gz + 1;

Xplus = [X ones(size(X,1),1)];

% !!! used to be rounded to ints! No!
U = ( Xplus * (m(1:4)) ./ (Xplus * [m(5:7);1]) );
V = ( Xplus * (m(8:11)) ./ (Xplus * [m(5:7);1]) );

%
% Copyright by Oregon State University, 2002
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: findUV.m 6 2016-02-11 00:46:00Z  $
%
% $Log: findUV.m,v $
% Revision 1.11  2004/03/25 16:55:26  stanley
% auto insert keywords
%
%
%key geometry 
%comment  Returns image coordinates of real world coordinates 
%
