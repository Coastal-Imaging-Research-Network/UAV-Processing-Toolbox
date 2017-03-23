function lcp = makeLCPP3(whichStr,NU,NV)
%   lcp = makeLCPP3(whichStr, NU, NV)
% 
% creates the lens calibration profile for a DJI Phantom 3
% camera.  Intrinsic data were computed using independent packages and hand-
% transcribed to this file.  WhichStr is a string describing which DJI is 
% being used.  options currently are only 'Aerielle'.
% There are five collection modes: snaps of 4 by 3 and 16 by 9 aspect as
% well as three video modes of 4K, 1080 and 720.  These are distinguished
% by the image size (NV by NU).  
% This routine has now been changed to recognize that camera calibration
% should be carried out on each image type.  i.e. movie formats are not
% simply extracts of full chip snaps.  Thus the lcp will contain ONLY the
% parameters for a particular image type for a particular vehicle.
% If a type is requested that has not been calibrated, the routine fails.

% Holman, November 2015, at Duck then Corvallis


% data for all five image formats.  NU and NV are image sizes, U0 and V0
% are the coords of the top left pixel on the chip, dU and dV are the
% decimation in U and V

% lcp.NU = [4000 4000 3840 1920 1280];      % possible images width
% lcp.NV = [3000 2250 2160 1080  720];       % possible heights
% lcp.U0 = [1     1    81    81   81];       % left size first pixel 
% lcp.V0 = [1    376  421   421  421];   % 
% lcp.dU = [1     1    1     2    3];           % decimation
% lcp.dV = [1     1    1     2    3];

switch whichStr
    case 'Aerielle'
        % data from Caltech calibrations
        if ((NU == 4000) && (NV == 3000))     % 4 by 3 snap
            lcp.NU = NU;
            lcp.NV = NV;
            lcp.c0U = 2016.23;      
            lcp.c0V = 1421.23;
            lcp.fx = 2327.5;        
            lcp.fy = 2323.56;
            lcp.d1 = -0.1326;  % radial distortion
            lcp.d2 =  0.09946;
            lcp.d3 = -0.0;
            lcp.t1 = -0.0003082;% tangential terms
            lcp.t2 = 0.0005749;
            lcp.r = 0:0.001:1.5;
            lcp = makeRadDist(lcp);
            lcp = makeTangDist(lcp);    % add tangential dist template
        elseif ((NU == 4000) && (NV == 2250))     % 16x9 snap
            lcp.NU = NU;
            lcp.NV = NV;
            lcp.c0U = 2006.000;       
            lcp.c0V = 1156.703;
            lcp.fx = 2309.081;        
            lcp.fy = 2306.763;
            lcp.d1 = -0.02036;  % radial distortion coefficients
            lcp.d2 =  0.01238;
            lcp.d3 = 0.0;
            lcp.t1 = 0.00750;   % tangential distortion coefficients
            lcp.t2 = 0.00125;
            lcp.r = 0:0.001:1.5;
            lcp = makeRadDist(lcp);
            lcp = makeTangDist(lcp);    % add tangential dist template
        elseif ((NU == 3840) && (NV == 2160))     % 4K video
            lcp.NU = NU;
            lcp.NV = NV;
            lcp.c0U = 1957.13;       
            lcp.c0V = 1088.21;
            lcp.fx = 2298.59;        
            lcp.fy = 2310.87;
            lcp.d1 = -0.14185;  % radial distortion coefficients
            lcp.d2 =  0.11168;
            lcp.d3 = 0.0;
            lcp.t1 = 0.00369;   % tangential distortion coefficients
            lcp.t2 = 0.002314;
            lcp.r = 0:0.001:1.5;
            lcp = makeRadDist(lcp);
            lcp = makeTangDist(lcp);    % add tangential dist template
        else
            error('No lens calibration yet for this image format')
        end
    otherwise
        error('Only Aerielle is currently implemented')
end
            


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

