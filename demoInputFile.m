% Demo input file for UAV processing.
% The user is responsible for correcting content for each new analysis

% 1.  Paths, names and time stamp info:
inputs.stationStr = 'Aerielle';  
inputs.dateVect = [2015 10 1 19+4 29 0];       % date/time of first frame
inputs.dt = 0.5/(24*3600);           % delta t (s) converted to datenums
inputs.frameFn = 'demoClip';            % root of frames folder name
inputs.gcpFn = [pwd, filesep, 'demoGCPFile.mat'];
inputs.instsFn = [pwd, filesep,'demoInstsFile'];            % instrument m-file location

inputs.pnIn = '/tmp/foo/UAV-Processing-Toolbox-master/demoMovies';
inputs.dayFn = '271_Oct.01';
inputs.pncx = inputs.pnIn;

% 2.  Geometry solution Inputs:
% The six extrinsic variables, the camera location and viewing angles
% in the order [ xCam yCam zCam Azimuth Tilt Roll].
% Some may be known and some unknown.  Enter 1 in knownFlags for known
% variable.  For example, knownFlags = [1 1 0 0 0 1] means that camX and
% camY and roll are known so should not be solved for.  
% Enter values for all parameters below.  If the variable is known, the
% routine will use this data.  If not, this will be the seed for the
% nonlinear search.
inputs.knownFlags = [0 0 0 0 0 0];
inputs.xyCam = [0 600];
inputs.zCam = 100;             % based on last data run                
inputs.azTilt = [95 60] / 180*pi;          % first guess
inputs.roll = 0 / 180*pi; 

% 3.  GCP info
% the length of gcpList and value of nRefs must be >= length(beta0)/2
inputs.gcpList = [1 2 3 6 7];      % use these gcps for init beta soln
inputs.nRefs = 4;                    % number of ref points for stabilization
inputs.zRefs = 7;                    % assumed z level of ref points

% 4.  Processing parameters
inputs.doImageProducts = 1;                    % usually 1.
inputs.showFoundRefPoints = 0;                 % to display ref points as check
inputs.rectxy = [50 0.5 500 400 0.5 1000];     % rectification specs
inputs.rectz = 0;                              % rectification z-level

% residual calculations - NO USER INPUT HERE
inputs = makeUAVPn(inputs);             % make the path to find init-file
inputs.dn0 = datenum(inputs.dateVect);
bs = [inputs.xyCam inputs.zCam inputs.azTilt inputs.roll];  % fullvector
inputs.beta0 = bs(find(~inputs.knownFlags));
inputs.knowns = bs(find(inputs.knownFlags));



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

