function [Ur,Vr, thresh] = findCOMRefObjFirstPass(I, c)
%   [URef, VRef, thresh] = findCOMRefObjFirstPass(I,corners)
%
% given a gray shade image, I, find the intensities in a box defined by
% URef and VRef pixels in a box.
% then find the center of mass (COM) of a bright feature (currently defined
% by a user entered threshold chosen by looking at the blow up image.

thresh = [200: 255];  % test for best threshold (bright)
c = round(c);
u = c(1,1):c(2,1);      % grab small window around control point.
v = c(1,2):c(2,2);
[U,V]=meshgrid(u,v);
i = I(v,u);

% now identify a good choice for intensity threshold
cont = 1;
while ~isempty(cont)
    figure(10); clf
    colormap(jet)
    subplot(121); imagesc(u,v,i); axis image; colorbar
    thresh = input('enter a threshold to isolate the target - ');

    Ur = mean(U(i>thresh));
    Vr = mean(V(i>thresh));
    hold on; plot(Ur,Vr, 'w*')
    figure(10);subplot(122)
    imagesc(u,v,i>thresh)
    hold on; plot(Ur,Vr,'w*'); 
    axis image; 
    cont = input('Enter <cr> to accept, 0 to try again - ');
end
close(10)

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

