function [Uu, Vu] = undistort( Ud, Vd, camera, ip )
%
%       [Uu, Vu] = undistort( Ud, Vd, camera, ip )
%  or
%       [Uu, Vu] = undistort(UVd, camera, ip)
%       UVu = undistort(Ud, Vd, camera, ip)
%       UVu = undistort(UVd, camera, ip)
%
%  computes undistorted pixel coordinates [Uu Vu] corresponding to 
%  distorted coordinates [Ud Vd].  Calculation is based on 
%  camera distortion parameters and image parameters contained
%  in the structures camera and ip.  Inputs can be either two
%  column vectors or an N by 2 matrix.  Output is similar.
%
%  Routine was updated 08/02 to reduce errors O(1 pixel) in the 
%  relationship  UV = distort(undistort(UV)).  This was done 
%  through a two-pass calculation.
%

% updated 08/02 by Holman
% copyright 2002, Argus Users Group.

% input error checking
global whichUndistort;

whichUndistort = [];
UisNx2 = 0;

if nargin == 2      % UV passed as matrix, AND distortCaltech
    camera = Vd;      % lcp is second parameter
    UisNx2 = 1;
end

if nargin == 3      % UV passed as matrix, OR distortCaltech
    
    % select which based on arg 2. struct means Old with K.
    if( isstruct( Vd ))
        ip = camera;
        camera = Vd;
        UisNx2 = 1;
    else              % nonstruct means we must be caltech
        % and cam is already lcp
    end
end

if( UisNx2 )   % U/V must be an Nx2
    
    if size(Ud,2) ~= 2
        Ud = Ud';
    end
    if size(Ud) ~= 2
        error('invalid arguments for undistort ([Uu Vu] or Uu, Vu expected')
    end
    Vd = Ud(:,2);     % sort into columns
    Ud = Ud(:,1);
    
end

if length(Ud) ~= length(Vd)
    error('U and V must be the same length (undistort)');
end

% here we have cam, ip, etc. if cam has Drad, call new undistort.
if isfield( camera, 'Drad' )
    if( ~isempty( camera.K ) ...
            && (numel(camera.K)>1)  ...
            && (numel(camera.Drad)>2) )
        whichUndistort = 'OldK';
        [Uu, Vu] = undistort2( Ud, Vd, camera );
        if nargout == 1
            Uu = [Uu Vu];
        end
        return;
    end;
elseif (isfield( camera, 'lcp'))
    whichUndistort = 'caltech';
    [Uu, Vu] = undistortCaltech( Ud, Vd, camera.lcp );

elseif (isfield( camera, 'c0U'))
    whichUndistort = 'caltech';
    [Uu, Vu] = undistortCaltech( Ud, Vd, camera );
    
    
else
    
    whichUndistort = '1';
    
    % convert to cartesian coordinates, find scale and undistort
    % First pass
    U1 = (Ud ./ ip.lx) - ip.U0; V1 = (Vd ./ ip.ly) - ip.V0;
    d2 = U1.^2 + V1.^2;
    scale = 1 + ( camera.D2 + camera.D1*d2 );
    
    % second pass - find better scale based on (U2 V2)
    d2 = d2 ./ scale.^2;
    scale = 1 + ( camera.D2 + camera.D1*d2 );
    U1 = U1 ./ scale; V1 = V1 ./ scale;
    
    Uu = (U1 + ip.U0) * ip.lx; Vu = (V1 + ip.V0) * ip.ly;
    
end

if nargout == 1
    Uu = [Uu Vu];
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

