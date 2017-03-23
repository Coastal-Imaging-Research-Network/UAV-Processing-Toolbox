function images = buildRectProducts(dn ,images, I, beta, glob)
%   images = buildRectProducts(dn, images, I, beta, glob)
%
% builds standard Argus image products in a structure, images, that
% contains fields dn (all the time stamps that went into the product),
% sumI, bright, dark.  These will accumulate as the function is
% called incrementally.  After all images are accumulated, image products
% are computed using function makeFinalRects.  dn, I are the current image
% and time, while images is used as both input and output (with incremental
% information).  Assumes RGB format.  Geometry beta is needed to align
% otherwise shifting images. xy is the list of rectification specs, as
% [xmin dx xmax ymin dy ymax] supplied by the user.  z is the rectification 
% level.  images should be empty for the first (initialization) call.
% glob is a structure that must include a field .lcp.

I = double(I);
[NV,NU,NC] = size(I);
Us = [1:NU];
Vs = [1:NV]';
xy = images.xy;
z = images.z;
if ~isfield(images,'xyz')   % first frame, initialize everything then add first frame
    x = [xy(1):xy(2): xy(3)]; y = [xy(4):xy(5): xy(6)];
    [X,Y] = meshgrid(x,y);
    images.dn = dn;
    images.sumI = zeros(length(y),length(x),3);   % nan init images
    images.bright = images.sumI;    
    images.dark = images.sumI;
    images.N = zeros(size(X));      % count valid frames everywhere
    
    % load first frame info
    xyz = [X(:) Y(:) repmat(z, size(X(:)))];
    UV = round(findUVnDOF(beta,xyz,glob));
    UV = reshape(UV,[],2);
    good = find(onScreen(UV(:,1),UV(:,2),NU,NV));
    ind = sub2ind([NV NU],UV(good,2),UV(good,1));
    foo = images.sumI;
    %clear I2
    for i = 1: 3    % for rgb, fill in snap content in rect frame
        I3 = I(:,:,i);
        I2 = I3(ind);
        bar = foo(:,:,i);
        bar(good) = I2;
        foo(:,:,i) = bar; 
    end
    images.dn = dn;
    images.x = x;
    images.y = y;
    images.sumI  = foo;
    images.bright = foo;
    images.dark = foo;
    images.xyz = xyz; % for later interp2
    images.N(good) = 1;
else
    I = double(I);
    images.dn = [images.dn; dn];
    UV = round(findUVnDOF(beta,images.xyz, glob));    % don't bother with fractions
    UV = reshape(UV,[],2);
    good = find(onScreen(UV(:,1),UV(:,2),NU,NV));   % index into images.xx
    ind = sub2ind([NV NU],UV(good,2),UV(good,1));   % indiced into I
    Ig = rgb2gray(I/255);
    IDark = rgb2gray(images.dark/255);
    darker = find(Ig(ind) < IDark(good));
    IBright = rgb2gray(images.bright/255);
    brighter = find(Ig(ind) > IBright(good));
    for i = 1: 3    % for rgb
        %I2 = round(interp2(Us,Vs,I(:,:,i),UV(good,1),UV(good,2)));
        foo = I(:,:,i);
        I2 = foo(ind);
        bar = images.sumI(:,:,i);
        bar(good) = nansum([bar(good) I2]');
        images.sumI(:,:,i) = bar;
        bar = images.bright(:,:,i);
        bar(good(brighter)) = I2(brighter);
        images.bright(:,:,i) = bar;
        bar = images.dark(:,:,i);
        bar(good(darker)) = I2(darker);
        images.dark(:,:,i) = bar;
    end
    images.N(good) = images.N(good)+1;
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

