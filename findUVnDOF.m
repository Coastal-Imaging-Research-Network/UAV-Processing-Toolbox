function [UV] = findUVnDOF(b, xyz, g)
%   [UV] = findUVnDOF(beta, xyz, {globs})
%
% computes the distorted UV coordinates that correspond to a set of xyz
% points where the extrinsic parameters are specified by beta
% There are numerous options for beta, depending on what is known or not 
% known.  xyz is assumed to be an Nx3 list of world coordinates
% beta options
%   length 6 (6 dof)    - [xCam yCam zCam azimuth tilt roll]
%   length 5 (5 dof)    - [xCam yCam zCam azimuth tilt]
%   length 3 (3 dof)    - [azimuth tilt roll]
%   length 2 (2 dof)    - [azimuth tilt]
%
% When a beta is less than 6, the missing parameters are assumed to be
% passed as global variables in a structure globs.lcp, .knownFlags and 
% .knowns where the knowns are listed in their natural order.  
% This structure is passed as an optional third argument in the
% function call normally.  However, if this routine is called as the forward 
% model in nlinfit, only two input arguments are allowed.  In that case,
% the globally-passed version, g2, is used to fill in these variables.
% If beta is a 1x6 vector, the global information is still needed for the
% lcp structure.
%
%  NOTE - this returns DISTORTED COORDINATES.  THEY ARE ALSO RETURNED AS A
%  COLUMN VECTOR of U(:); V(:) for use with nlinfit!!

global globs

if nargin == 3;     % passing globals as input
    globs = g;
end
if length(b)<6      % there are some knowns
    if sum(~globs.knownFlags) ~= length(b)
        error('Length of beta0 must equal length of unknowns in knownFlags')
    end
    b2 = nan(1,6);
    b2(find(globs.knownFlags)) = globs.knowns;
    b2(find(~globs.knownFlags)) = b;
    lcp = globs.lcp;
else
    b2 = b;     % fully 6 dof input beta
end
lcp = globs.lcp;

P = lcpBeta2P( lcp, b2 );

UV = P*[xyz'; ones(1,size(xyz,1))];
UV = UV./repmat(UV(3,:),3,1);

[U,V] = distort(UV(1,:),UV(2,:),lcp); 
UV = [U; V];

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

