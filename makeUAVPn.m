function in = makeUAVPn(in)
%   UAVinputs = makeUAVPn(UAVInputs)
%
% start to create a consistent structure of inputs for processing a UAV
% data collection.  UAVinputs is a structure that will contain all the
% input information and will be stored with the results in cx for record
% keeping.  UAVInputs as input to this function must have fields 
% 'stationStr' and 'dateVect'.  To this will added fields 
%   'ArgusDayFn'    the argus folder name, 
%   'pnIn'          the expect full pathname for the input frames
%   'pncx'          the full pathname for the cx output directory

% Below (commented out) is the normal location for CIL product storage
% under /ftp/pub.  For the demo we will store it locally.  However, the
% user should develop a better storage strategy for real data.  Also, note
% that a successful run will leave a 'meta' file in this directory.  If
% someone else tries running the demo this will be found and geometries
% will not be computed for the second person.

% dn0 = datenum(in.dateVect);    % GMT time of first frame
% in.dayFn = argusDay(matlab2Epoch(dn0));
% in.pncx = ['/ftp/pub/' in.stationStr '/' num2str(in.dateVect(1)) ...
%             '/cx/' in.dayFn '/'];    
in.dayFn = 'demoResults';
display('Select Directory for local Results to be stored')
in.pncx = uigetdir([],'Select Directory for local Results to be stored'); % select local demo results directory
in.pncx=[in.pncx,filesep]; %add file separator at end of path for proper path saving       

% Below (commented out) is the normal frame location for CIL work
% It has been replaced temporarily by the pathname for the demo clips.  You
% should definitely NOT store your data in the toolbox, so you need to
% change this for your system.

%in.pnIn = ['/scratch/temp/holman/' in.stationStr '/' num2str(in.dateVect(1)) '/'];

display('Select Directory where movie frames are located')
in.pnIn = uigetdir([],'Select Directory where movie frames are located');

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

