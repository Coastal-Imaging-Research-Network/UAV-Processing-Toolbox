function beta6DOF = find6DOFGeom(I, gcp, in, meta)
%   [beta6DOF,refPoints] = find6DOFGeom(I, gcps, input, meta)
%
% Initialize a UAV movie analysis using the first (or any) frame.
% Displays the frame and asks user to ginput the locations of points
% specified in gcpUseList whose locations and id are in gcps.  The
% nonlinear fit is seeded with 6 dof beta0 = [xyzCam azimuth tilt, roll]
% with angles in radians.  Returns the best fit geometry beta6 dof.
% Stage 2 is the creation of nRefPoints reference points, each expressed in 
% a structure
% NOTE - lcp, NU and NV are passed in meta but are made global for nlinfit.  

global globs        % this is only used for output to findUVnDOF
globs = meta.globals;

% break out gcp locations
nGcps = length(in.gcpList);
x = [gcp(in.gcpList).x];
y = [gcp(in.gcpList).y];
z = [gcp(in.gcpList).z];
xyz = [x' y' z'];

% digitize the gcps and find best fit geometry
figure(1); clf
imagesc(I);
disp(['computing geometry using ' num2str(nGcps) ' control points'])
for i = 1: nGcps
    disp(['Digitize ' gcp(in.gcpList(i)).name])
    UV(i,:) = ginput(1);     
end
beta = nlinfit(xyz,[UV(:,1); UV(:,2)],'findUVnDOF',in.beta0);
beta6DOF(find(globs.knownFlags)) = globs.knowns;
beta6DOF(find(~globs.knownFlags)) = beta;
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