function lcp = makeLCPFromCaltech(calib_resultsPn)
% Creates the lens calibration profile (lcp) for a camera, based on
%   "Calib_Results.mat" generated from the Caltech Calibration toolbox.
%
% Input:
%   calib_resultsPn = full directory path where "Calib_Results.mat" are saved
%
% Output:
%   lcp = lens calibration profile (struct)
%
% Usage: lcp = makeLCPFromCaltech(calib_resultsPn)
%
% Revisions: 
%   Holman, November 2015, at Duck then Corvallis
%   Allison Penko & Jenna Brown, March 2017, CIRN Boot Camp
%
% Further documentation on how this script works within the UAV Toolbox located here: 
%   https://github.com/Coastal-Imaging-Research-Network/UAV-Processing-Toolbox/wiki/Supporting-Routine-Docs

if nargin < 1
    [calib_resultsFn,calib_resultsPn] = uigetfile('*.mat','Select your Calib_Results.mat file');
end
if ~strcmp(calib_resultsPn(end),filesep)
    calib_resultsPn = [calib_resultsPn,filesep];
end
load([calib_resultsPn,'\Calib_Results.mat'])

            lcp.NU = nx;     % number of pixel columns
            lcp.NV = ny;     % number of pixel rows
            lcp.c0U = cc(1); % U coordinate of pripcipal point    
            lcp.c0V = cc(2); % V coordinate of principal point
            lcp.fx = fc(1);  % x component of focal length (in pixels)  
            lcp.fy = fc(2);  % y component of focal length (in pixels)
            lcp.d1 = kc(1);  % radial distortion coefficients
            lcp.d2 = kc(2);
            lcp.d3 = kc(5);
            lcp.t1 = kc(3);         % tangential distortion coefficients
            lcp.t2 = kc(4);
            lcp.r = 0:0.001:1.5;    % for processing disortion
            lcp = makeRadDist(lcp);
            lcp = makeTangDist(lcp);    % add tangential dist template

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

