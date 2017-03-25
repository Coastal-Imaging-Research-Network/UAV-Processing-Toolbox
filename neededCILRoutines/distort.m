function [Ud, Vd] = distort(Uu, Vu, cam, ip)
%
% [Ud, Vd] = distort(Uu, Vu, cam, ip)
%
%  Routine to re-distort pixel coordinates for display on an image.
%  This version assumes that the image processor and camera data are stored
%  within structures (and can be retrieved by DBgetImageData or equiv).
%  Uu and Vu are columns of undistorted pixel coordinates, 
%  while Ud and Vd are their distorted equivalents.
%  Shorter calls are
% 	[Ud, Vd] = distort(UVu, cam, ip);
% 	UVd = distort(Uu, Vu, cam, ip);
% 	UVd = distort(UVu, cam, ip);
%
%  where UV is a matrix of 2 columns [U, V].
%
%  This version corrects a previous problem wherein image coordinate which 
%  were very far off-screen could be sometimes re-distorted back into the 
%  image.  This is done by omitting stopping the correction for points
%  whose distance from image center is beyond the turnaround in the UV
%  vs newUV function.
%

%  From several previous versions, by Holman, 7/16/98

% input error checking

global whichDistort;

whichDistort = [];
UisNx2 = 0;

if nargin == 2      % UV passed as matrix, AND distortCaltech
    cam = Vu;      % lcp is second parameter
    UisNx2 = 1;
    whichDistort = 'caltech';
end
    
if nargin == 3      % UV passed as matrix, OR distortCaltech
    
    % select which based on arg 2. struct means Old with K.
    if( isstruct( Vu ))
        ip = cam;
        cam = Vu;
        UisNx2 = 1;
    else              % nonstruct means we must be caltech
        % and cam is already lcp
    end
end

if( UisNx2 )   % U/V must be an Nx2
    
    if size(Uu,2) ~= 2
        Uu = Uu';
    end
    if size(Uu) ~= 2
        error('invalid arguments for undistort ([Uu Vu] or Uu, Vu expected')
    end
    Vu = Uu(:,2);     % sort into columns
    Uu = Uu(:,1);
    
end

U = Uu(:);
V = Vu(:);
if length(U) ~= length(V)
    error('U and V must be the same length (distort)')
end

% here we have sorted everything out, cam, ip, UV, etc.
% new db: ip is basically useless and empty. cam has all the data, in a new format.
if (isfield(cam,'Drad') ...
        && ~isempty(cam.K) ...
        && (numel(cam.K)>1) ...
        && (numel(cam.Drad)>2) )
    whichDistort = '2';
    [Ud, Vd] = distort2( U, V, cam, ip );
    
elseif (isfield(cam, 'lcp'))
    whichDistort = 'caltech';
    [Ud, Vd] = distortCaltech( U, V, cam.lcp );
    
elseif (isfield(cam,'c0U'))
    whichDistort = 'caltech';
    [Ud, Vd] = distortCaltech( U, V, cam );
    
else
    
    whichDistort = '1';
    
    %  Compute the maximum d for which you will allow distortion.  Beyond this
    %  value distortion can falsely bring points back onto the screen.
    %  Calculation is just based on finding max in newU vs U analytically
    
    if cam.D1 ~= 0
        d2max = -(1 + cam.D2) / (3 * cam.D1);
    else
        d2max = 1e8;	% some large number
    end
    
    %  Now carry out the distortion calculation.  Default is to return original points
    
    x = (U / ip.lx) - ip.U0;
    y = (V / ip.ly) - ip.V0;
    d2 = x.^2 + y.^2;
    
    good = d2 < d2max;
    Ud = U;
    Vd = V;
    
    scale = 1 + cam.D2 + cam.D1*d2(good);
    Ud(good) = ((x(good) .* scale) + ip.U0) * ip.lx;
    Vd(good) = ((y(good) .* scale) + ip.V0) * ip.ly;
    
end;

if nargout == 1
    Ud = [Ud Vd];
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

