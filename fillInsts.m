function insts = fillInsts(insts,beta,meta)
%   insts = fillInsts(insts, beta, meta);
%
%  Fill in all of the xyz values for instruments based on the geometry
%  beta.  Inst types currently can be line or matrix.  
%  A line is defined by the xyz locations of its end points (2x3 matrix).
%  Equivalent UV locations are calculated then all intervening pixel
%  locations are interpolated.  Since the camera view will change (a bit)
%  from frame to frame, these are converted to virtual xyz locations  in a
%  matrix xyzAll which will be sampled in subsequent frames.
%  The matrix instrument type (e.g. cBathy) is specified by x and y fields
%  consisting of [xmin dx xmax], and [ymin, dy, ymax] as well as a z field
%  for the single vertical level of sampling.  These are expanded to the
%  full matrix of sampling locations in xyzAll.  All are converted to UV
%  solely for the purpose of removing those which aren't in the initial
%  image frame.  
%  Beta is the 6 dof geometry solution.  

% Last update: KV WRL 04.2017
% - rotAngle field was included to the insts structure to perform a Z-axis
% rotation of (x,y) coordinates of the pixel instruments (both line and
% matrix). Rotation is performed around the baricenter of the pixel
% instrument.

% Rotation matrix
R3 = @(x) [ cosd(x) -sind(x) 0 
            sind(x)  cosd(x) 0
               0        0    1];
bad = [];
for i = 1: length(insts)
    switch insts(i).type
        case 'line'
            
            % Check if insts has a rotAngle field
            if isfield(insts(i), 'rotAngle')
                % Perform rotation of the pixel instrument (x,y)
                % coordinates around its baricenter
                insts(i).xyz = (R3(insts(i).rotAngle)*(insts(i).xyz ...
                    - repmat(mean(insts(i).xyz), 2, 1))')' ...
                    + repmat(mean(insts(i).xyz), 2, 1);
            end
            
            UV = findUVnDOF(beta, insts(i).xyz, meta.globals);
            UV = round(reshape(UV,[],2));
            if ~any(isnan(UV(:)))
                dUV = diff(UV);
                if abs(dUV(1))>abs(dUV(2))    % row-wise
                    U = UV(1,1):sign(dUV(1)):UV(2,1);
                    V = round(interp1(UV(:,1),UV(:,2),U));
                else
                    V = UV(1,2):sign(dUV(2)):UV(2,2);
                    U = round(interp1(UV(:,2),UV(:,1),V));
                end
                xyzAll = findXYZ6dof(U,V,insts(i).xyz(1,3),beta,meta.globals.lcp);
                good = ~isnan(xyzAll(:,1));   % some may be nans due to distortion
                insts(i).xyzAll = xyzAll(good,:); % only keep real values
            else
                bad = [bad i];      % keep list of bad instruments
                disp(['WARNING!!, INSTRUMENT ' insts(i).name ' NOT VALID = OMITTED'])
            end
        case 'matrix'
            x = insts(i).x;
            x = [x(1): x(2): x(3)];
            y = insts(i).y;
            y = [y(1): y(2): y(3)];
            [X,Y] = meshgrid(x,y);
            xyzAll = [X(:) Y(:) repmat(insts(i).z,size(X(:)))];
            
            % Check if insts has a rotAngle field
            if isfield(insts(i), 'rotAngle')
                % Perform rotation of the pixel instrument (x,y)
                % coordinates around its baricenter
                meanxyzAll = [mean(x) mean(y) 0];
                xyzAll = (R3(insts(i).rotAngle)*(xyzAll - repmat(meanxyzAll, length(X(:)), 1))')' ...
                    + repmat(meanxyzAll, length(X(:)), 1);
            end
            
            % test which will be onScreen (so shouldn't distort to nan)
            UV = findUVnDOF(beta, xyzAll, meta.globals);
            UV = round(reshape(UV,[],2));
            good = find(onScreen(UV(:,1),UV(:,2),meta.globals.lcp.NU, ...
                meta.globals.lcp.NV));
            insts(i).xyzAll = xyzAll(good,:);
    end
end
insts = insts(setdiff(1:length(insts),bad));

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

