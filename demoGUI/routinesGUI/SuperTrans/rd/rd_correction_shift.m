function [x_shift y_shift] = rd_correction_shift(xRD, yRD)
%RD_CORRECTION_SHIFT Computes the shift of psuedo RD to RD

% Rijksdriehoek coordinates are defined wrt the ETRS coordinates by
% transformation formula's. Next to this mathematical definition, one needs
% to correct for the (max 25 cm) error that has arisen after re-measuring
% RD with better equipement than when it was defined. This function
% interpolates the correction grid as provided by RDNAP 

%% Copyright notice
%   --------------------------------------------------------------------
%   Copyright (C) 2011 Van Oord Dredging and Marine Contractors BV
%       Thijs Damsma
%
%       tda@vanoord.com
%
%       Watermanweg 64
%       3067 GG
%       Rotterdam
%       The Netherlands
%
%   This library is free software: you can redistribute it and/or
%   modify it under the terms of the GNU Lesser General Public
%   License as published by the Free Software Foundation, either
%   version 2.1 of the License, or (at your option) any later version.
%
%   This library is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%   Lesser General Public License for more details.
%
%   You should have received a copy of the GNU Lesser General Public
%   License along with this library. If not, see <http://www.gnu.org/licenses/>.
%   --------------------------------------------------------------------

% This tool is part of <a href="http://OpenEarth.nl">OpenEarthTools</a>.
% OpenEarthTools is an online collaboration to share and manage data and
% programming tools in an open source, version controlled environment.
% Sign up to recieve regular updates of this function, and to contribute
% your own tools.

%% Version <http://svnbook.red-bean.com/en/1.5/svn.advanced.props.special.keywords.html>
% Created: 18 Jan 2011
% Created with Matlab version: 7.12.0.62 (R2011a)

% $Id: rd_correction_shift.m 3905 2011-01-18 11:48:51Z thijs@damsma.net $
% $Date: 2011-01-18 12:48:51 +0100 (mar., 18 janv. 2011) $
% $Author: thijs@damsma.net $
% $Revision: 3905 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/rd/rd_correction_shift.m $
% $Keywords: $

%%
[c.x,c.y,c.x_shift    ] = surfer_read('private\x2c.grd');
[c.x,c.y,c.y_shift,OPT] = surfer_read('private\y2c.grd');

x_shift = nan(size(xRD));
y_shift = nan(size(yRD));

for ii = 1:numel(xRD)
    % find nearest x,y point
    if xRD(ii)>OPT.min_x && xRD(ii)<OPT.max_x &&...
            yRD(ii)>OPT.min_y && yRD(ii)<OPT.max_y
        ix = find(c.x>xRD(ii),1,'first')+[-2 -1 0 1];
        iy = find(c.y>yRD(ii),1,'first')+[-2 -1 0 1];
        
        if ix(1)>=1 &&  ix(4)<=length(c.x)&&...
                iy(1)>=1 &&  iy(4)<=length(c.y)
            if any(any(isnan(c.x_shift(iy,ix)+c.y_shift(iy,ix))))
                % do nothing
            else    
                ddx = 1 - mod(xRD(ii),1000)/1000;
                ddy = 1 - mod(yRD(ii),1000)/1000;
                
                f(1) =    -0.5*ddx+ddx*ddx    -0.5*ddx*ddx*ddx;
                f(2) = 1.0-2.5*ddx    *ddx    +1.5*ddx*ddx*ddx;
                f(3) =     0.5*ddx+2.0*ddx*ddx-1.5*ddx*ddx*ddx;
                f(4) =    -0.5*ddx    *ddx    +0.5*ddx*ddx*ddx;
                g(1) =    -0.5*ddy+ddy*ddy    -0.5*ddy*ddy*ddy;
                g(2) = 1.0-2.5*ddy    *ddy    +1.5*ddy*ddy*ddy;
                g(3) =     0.5*ddy+2.0*ddy*ddy-1.5*ddy*ddy*ddy;
                g(4) =    -0.5*ddy    *ddy    +0.5*ddy*ddy*ddy;
                
                gfac = rot90(kron(g',f),2);
                
                x_shift(ii) = sum(sum(c.x_shift(iy,ix).*gfac));
                y_shift(ii) = sum(sum(c.y_shift(iy,ix).*gfac));
            end
        end
    end
end