function XYZ = findXYZ(m, UV, val, flag)
%
%  XYZ = findXYZ(m, UV, val, flag)
%
%  Routine to find new [x y z] location based on the image geometry, m,
%  and image coordinates, UV.  The Direct Linear Transformation (DLT) 
%  equations, which transform the XYZ world coordinates into UV image 
%  coordinates:
%
%       U = (Ax + By + Cz + D)/(Ex + Fy + Gz + 1);
%       V = (Hx + Jy + Kz + L)/(Ex + Fy + Gz + 1);
%
%  can be rearranged to solve for x, y, or z in terms of the image coordinates.
%  Because the system is underdetermined, one of the coordinates must be 
%  specified.  The variable, flag, indicates which of the three coordinates 
%  is known: flag=1 for x, flag=2 for y, and flag=3 for z.  The value of the 
%  known coordinate is entered into the variable val, which can be a scalar or 
%  an array.
%
%  Inputs:
%   m       - geometry vector (Walton m-vector = DLT coefficients)
%   UV      - Nx2 matrix of [U V] coordinates
%   val     - the specific value for the known x, y, or z coordinate
%             If val is a scalar, it is used for all UV pairs.
%             If val is an array, it must be as long as UV.
%   flag    - flag indicating which of the x, y, or z coordinates is known,
%             e.g., flag = 3 implies that z is known.
%
%  Output:
%   XYZ     - Nx3 matrix of [x y z] values
%
% Holman & Paden 04/28/04

% Check for valid UV pairs

[N,M] = size(UV);
if (M ~= 2)
    error('[U V] values must be entered as rows')
end

% Build val array if not already there.

if (length(val) == 1)
    val = ones(N,1)*val;
end

if(length(val) ~= N)
    error('array of val not same length as UV list');
end

U = UV(:,1);
V = UV(:,2);

% Change from Walton m-vector notation to DLT notation so don't have to
% use subscripts

A = m(1);  B = m(2);  C = m(3);  D = m(4);   E = m(5);   F = m(6);
G = m(7);  H = m(8);  J = m(9);  K = m(10);  L = m(11);

% Assign variable names to coefficients derived in solving for x,y, or z

M = (E*U - A);
N = (F*U - B);
O = (G*U - C);
P = (D - U);
Q = (E*V - H);
R = (F*V - J);
S = (G*V - K);
T = (L - V);

% Solve for unknown coordinates for given known coordinate

switch flag

    case 1

        X =  val;      
        Y = ((O.*Q - S.*M).*X + (S.*P - O.*T))./(S.*N - O.*R);
        Z = ((N.*Q - R.*M).*X + (R.*P - N.*T))./(R.*O - N.*S);

    case 2

        Y =  val;
        X = ((O.*R - S.*N).*Y + (S.*P - O.*T))./(S.*M - O.*Q);
        Z = ((M.*R - Q.*N).*Y + (Q.*P - M.*T))./(Q.*O - M.*S);

    case 3

        Z =  val;
        X = ((N.*S - R.*O).*Z + (R.*P - N.*T))./(R.*M - N.*Q);
        Y = ((M.*S - Q.*O).*Z + (Q.*P - M.*T))./(Q.*N - M.*R);
end

XYZ = [X Y Z];

%

%
%   Copyright (C) 2017  Coastal Imaging Research Network
%                       and Oregon State University

%    This program is free software: you can redistribute it and/or  
%    modify it under the terms of the GNU General Public License as 
%    published by the Free Software Foundation, version 3 of the 
%    License.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see
%                                <http://www.gnu.org/licenses/>.

% CIRN: https://coastal-imaging-research-network.github.io/
% CIL:  http://cil-www.coas.oregonstate.edu
%
%key UAVProcessingToolbox
%

