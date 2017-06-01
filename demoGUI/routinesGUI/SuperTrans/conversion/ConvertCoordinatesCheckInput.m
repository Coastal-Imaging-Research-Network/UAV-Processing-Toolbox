function CS = ConvertCoordinatesCheckInput(CS,STD)
%CONVERTCOORDINATESCHECKINPUT Performs checks on specified system
%
%   Performs checks on specified coordinate system. It will return error
%   messages if coordinate types or epsg codes are unknown.
%
%   Syntax:
%   CS = ConvertCoordinatesCheckInput(CS,STD)
%
%   Input:
%   CS  = coordinate system structure
%   STD = structure with all EPSG codes
%
%   Output:
%   CS = coordinate system structure
%
%   See also CONVERTCOORDINATES

%   --------------------------------------------------------------------
%   Copyright (C) 2009 Deltares for Building with Nature
%       Thijs Damsma
%
%       Thijs.Damsma@deltares.nl
%
%       Deltares
%       P.O. Box 177
%       2600 MH Delft
%       The Netherlands
%
%   This library is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   This library is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this library.  If not, see <http://www.gnu.org/licenses/>.
%   --------------------------------------------------------------------

% $Id: ConvertCoordinatesCheckInput.m 5953 2012-04-12 09:11:21Z boer_g $
% $Date: 2012-04-12 11:11:21 +0200 (Thu, 12 Apr 2012) $
% $Author: boer_g $
% $Revision: 5953 $
% $HeadURL: https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/applications/SuperTrans/conversion/ConvertCoordinatesCheckInput.m $
% $Keywords: $

if ~isempty(CS.type)
    switch lower(CS.type)
        case {'geographic 2d','geo','geographic2d','latlon','lat lon','geographic'}
            CS.type = 'geographic 2D';
        case {'projected','xy','proj','cartesian','cart'}
            CS.type = 'projected';
        case {'engineering', 'geographic 3D', 'vertical', 'geocentric',  'compound'}
            error(['input ''CType = ' CS.type ''' is not (yet) supported']);
        otherwise
            error(['coordinate type ''' CS.type ''' is not supported']);
    end
end

if ~isempty(CS.code)
    if ischar(CS.code)
        CS.code = str2num(CS.code); % catch ascii EPSG codes
    end
    ind1              = find(STD.coordinate_reference_system.coord_ref_sys_code == CS.code);
    if isempty(ind1)
        error(['epsg code unknown: ',num2str(CS.code)])
    else
        
        switch STD.coordinate_reference_system.coord_ref_sys_kind{ind1}
            
            case {'geographic 2D','projected'}
                % ok
                
            case {'compound'}
                CS.code = STD.coordinate_reference_system.cmpd_horizcrs_code(ind1); %#ok<FNDSB>
                disp(sprintf([...
                    'coordinate system: ''%s'' is of type compound (3D coordinates system);\n'...
                    'Only the 2D component is used in conversion;\n'...
                    'conversion is performed for coordinate system %d'],...
                    STD.coordinate_reference_system.coord_ref_sys_name{ind1},CS.code));
            otherwise
                error(['coordinate type '''...
                    STD.coordinate_reference_system.coord_ref_sys_kind{ind1}...
                    ''' is not supported']);
        end
    end
end


