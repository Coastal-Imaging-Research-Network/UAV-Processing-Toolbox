function insts = makeDJIInst
%   insts = makeDJIInsts
%
% creates pixel instruments for UAV video. Types can be line or matrix
% this one is empty - just test image products. All in Argus Coordinates

% Last update: KV WRL 04.2017
% - rotAngle was included to perform a Z-axis rotation of
% the pixel instruments around their baricenter

cnt = 1;

% vBar instruments
y = [-450 -100];
x = [30];
z = 0;
for i = 1: length(x)
    insts(cnt).type = 'line';
    insts(cnt).xyz = [x(i) y(1) z; x(i) y(2) z];
    insts(cnt).name = ['vBar' num2str(x(i))];
    insts(cnt).shortName = ['vBar' num2str(x(i))];
    insts(cnt).rotAngle = -20;
    cnt = cnt+1;
end

% make slice to check stabilisation over a fixed object
% y = -100;
% x = [-10 30];
% z = 0;
% insts(cnt).type = 'line';
% insts(cnt).xyz = [x(1) y z; x(2) y z];
% insts(cnt).name = ['runup' num2str(y)];
% insts(cnt).shortName = ['runup' num2str(y)];
% insts(cnt).rotAngle = -20;
% cnt = cnt+1;

% some runup lines
x = [-50 100];
y = [-300];
z = 0;
for i = 1: length(y)
    insts(cnt).type = 'line';
    insts(cnt).xyz = [x(1) y(i) z; x(2) y(i) z];
    insts(cnt).name = ['runup' num2str(y(i))];
    insts(cnt).shortName = ['runup' num2str(y(i))];
    insts(cnt).rotAngle = -30;
    cnt = cnt+1;
end

% cBathy array
x = [-20 5 800];   % determine sample region and spacing
y = [-600 10 -50];    % format is [min del max]
z = 0;
rotAngle = -20 ; % in degrees (clockwise rotation)


insts(cnt).type = 'matrix';
insts(cnt).name = 'cBathyArray';
insts(cnt).shortName = 'mBW';
insts(cnt).x = x;
insts(cnt).y = y;
insts(cnt).z = z;
insts(cnt).rotAngle = rotAngle;
cnt = cnt+1;

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

