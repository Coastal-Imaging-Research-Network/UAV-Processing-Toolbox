% UAVProcessingCodes
%
% Documentation
%   UAVProcessingREADME.doc, also in pdf version.
%
% Primary Functions
%   sampleAerielleVideoDemo - master analysis routine
%   demoInputFile   - user input paths and parameters
%   makeInstsDemo   - example file to create pixel instruments
%   demoGCPFile     - example GCP file (.mat) from survey data
%   makeLCPP3       - create Lens Calibration Profile for Phantom 3
%   loadAndPartitionMovies - CIL-specific routine to break out frames
%
% Support main routines
%   initUAVAnalysis - initialize geometry and reference points
%   findNewBeta     - find ref points and solve geom for new frame
%   findCOMRefObjFirstPass - find center of mass, threshold of reference object
%   findCOMRefObj   - find center of mass of reference object
%   fillInsts       - fill in all pixels for pixel instruments
%   showInsts       - show instruments on image for QC
%   sampleDJIFrame  - extract pixel time series for instruments
%   buildRectProducts - accumulate image product data frame by frame
%   makeFinalImages - compute image products after all frames read in
%   printAndSaveImageProducts - save png and matlab copies of images
%
% Support minor routines
%   findUVnDOF      - find U,V for any xyz using n dof geometry
%   DJIFindXYZ6dof  - find XYZ for any UV using 6 dof geometry
%   DJIUndistort    - convert from distorted to undistorted coords
%   makeUAVPn       - create good pathnames for CIL expectations
%   makefr          - used in distortion, f(r).
%   makeRadDist     - radial distance for distortion calcs
%   makeTangDist    - tangential distance for distortion calcs
%
% CILroutines that are called
%   findXYZ         - find XYZ for any UV
%   onScreen        - determines if pixels lie within the image space
%   matlab2Epoch    - conversion from datenum to Argus epoch time
%   angles2R        - create rotation matrix for projection
%   argusDay        - create standard format Argus day folder name
%   argusFilename   - create standard format Argus filename (uses DB!)
%   matlab2Julian   - create Julian day
%   every           - perl script to break out frame, likely won't work.


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

