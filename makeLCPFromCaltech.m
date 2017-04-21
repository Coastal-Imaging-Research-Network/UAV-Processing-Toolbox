% Loads the Calib_Results.mat file generated from the Caltech toolbox and
% saves the distortion coefficients to a structure named lcp
% Allison Penko 
% 28 mar 17
% 
% Further documentation on how this script works within the UAV Toolbox located 
% here: https://github.com/Coastal-Imaging-Research-Network/UAV-Processing-Toolbox/wiki/Supporting-Routine-Docs

[calib_resultsFileName,calib_resultsPathName] = uigetfile('*.mat','Select your Calib_Results.mat file');
load([calib_resultsPathName,calib_resultsFileName])

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

dataFileDir = uigetdir([],'Select directory to save lcp.mat');
save([dataFileDir,filesep, 'lcp.mat'],'lcp')

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

