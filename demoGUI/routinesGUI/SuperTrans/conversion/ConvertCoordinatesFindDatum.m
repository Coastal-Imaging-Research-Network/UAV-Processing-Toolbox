function CS = ConvertCoordinatesFindDatum(CS,STD)
%CONVERTCOORDINATESFINDDATUM Find datum for coordinate system
%
%   Looks for the datum of the specified coordinate system.
%
%   Syntax:
%   CS = ConvertCoordinatesFindDatum(CS,STD)
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

% $Id: ConvertCoordinatesFindDatum.m 5953 2012-04-12 09:11:21Z boer_g $
% $Date: 2012-04-12 11:11:21 +0200 (Thu, 12 Apr 2012) $
% $Author: boer_g $
% $Revision: 5953 $
% $HeadURL: https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/applications/SuperTrans/conversion/ConvertCoordinatesFindDatum.m $
% $Keywords: $

ind1 = find(STD.coordinate_reference_system.coord_ref_sys_code == CS.geoRefSys.code);
CS.datum.code = STD.coordinate_reference_system.datum_code(ind1); %#ok<FNDSB>
if isnan(CS.datum.code)
    error('It Seems no Datum is specified for the selected coordinate reference system in the EPSG database')
end
ind2 = find(STD.datum.datum_code == CS.datum.code);
CS.datum.name = STD.datum.datum_name{ind2}; %#ok<FNDSB>
