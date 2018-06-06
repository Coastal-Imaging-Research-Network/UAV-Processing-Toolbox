function [beta6dof,Ur,Vr,fail,ci,mse] = GUIfindNewBeta(Ig,beta, meta)
%   [betaNew6dof,Ur,Vr,failFlag] = findNewBeta(Ig,betaOld, meta)
%
%  computes an updated 6 dof beta for a new UAV video frame Ig, based on
%  the found locations of refPoints.  If the first ref point finds no
%  bright pixels, it is assumed that the run is over (UAV changed view
%  quickly on the way home) and failFlag is set to true.  Globals must
%  include fields lcp, knowns and knownFlags.

% Last update: KV WRL 04.2017
% - MSE and confidence intervals (ci) are computed for nlinfit

global globs currentAxes
globs = meta.globals;

xyz = [meta.refPoints.xyz];
xyz = reshape(xyz(:),3,[])';
dUV = [meta.refPoints.dUV];
dUV = reshape(dUV(:),2,[])';
thresh = [meta.refPoints.thresh];
[Ur,Vr, fail] = GUIfindCOMRefObj(Ig,xyz,beta,dUV,thresh,meta);
if fail
    beta6dof = [];
    Ur = []; Vr = [];
    return
end

% find n-dof solution and expand to 6 dof final result
options.Tolfun = 1e-12;
options.TolX = 1e-12;
[betaNew, R, ~, CovB, mse, ~] = nlinfit(xyz, [Ur(:); Vr(:)],'findUVnDOF',beta, options);
ciNew = nlparci(betaNew, R, 'covar', CovB);

beta6dof(find(meta.globals.knownFlags)) = meta.globals.knowns;
beta6dof(find(~meta.globals.knownFlags)) = betaNew;

ci(:, find(globs.knownFlags)) = zeros(2,length(globs.knowns));
ci(:, find(~globs.knownFlags)) = ciNew';

% show results in case debug is needed
colormap(gray)
imagesc(Ig, 'Parent', currentAxes)
hold on
axis off
axis image
plot(currentAxes, Ur,Vr,'r*')
uv = findUVnDOF(beta6dof, xyz, globs);
uv = reshape(uv,[],2);
plot(currentAxes, uv(:,1),uv(:,2),'ko')
title(currentAxes, sprintf('RMSE = %.2f pixels', sqrt(mse)));
pause(0.01)

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

