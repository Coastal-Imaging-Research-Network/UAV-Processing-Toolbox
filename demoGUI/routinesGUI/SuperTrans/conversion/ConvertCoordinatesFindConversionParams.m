function proj_conv = ConvertCoordinatesFindConversionParams(CS,STD)
%CONVERTCOORDINATESFINDCONVERSIONPARAMS Find conversion parameters
%
%   Finds the conversion parameters for the specified coordinate system by
%   looking in the EPSG database.
%
%   Syntax:
%   proj_conv = ConvertCoordinatesFindConversionParams(CS,STD)
%
%   Input:
%   CS  = coordinate system structure
%   STD = structure with all EPSG codes
%
%   Output:
%   proj_conv = Structure with conversion parameters (code, name, method
%               and param)
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

% $Id: ConvertCoordinatesFindConversionParams.m 5953 2012-04-12 09:11:21Z boer_g $
% $Date: 2012-04-12 11:11:21 +0200 (Thu, 12 Apr 2012) $
% $Author: boer_g $
% $Revision: 5953 $
% $HeadURL: https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/applications/SuperTrans/conversion/ConvertCoordinatesFindConversionParams.m $
% $Keywords: $

ind1 = find(STD.coordinate_reference_system.coord_ref_sys_code == CS.code);
% Conversion parameters
proj_conv.code =      STD.coordinate_reference_system.projection_conv_code(ind1); %#ok<FNDSB>

% Conversion method
ind5             = find(STD.coordinate_operation.coord_op_code == proj_conv.code);
proj_conv.name        =      STD.coordinate_operation.coord_op_name(ind5);
proj_conv.method.code =      STD.coordinate_operation.coord_op_method_code(ind5);
ind6             = find(STD.coordinate_operation_method.coord_op_method_code == proj_conv.method.code);
proj_conv.method.name =      STD.coordinate_operation_method.coord_op_method_name{ind6};

ind2           = find(STD.coordinate_operation_parameter_value.coord_op_code == proj_conv.code);
proj_conv.param.codes       =      STD.coordinate_operation_parameter_value.parameter_code(ind2);
for ii=1:length(proj_conv.param.codes)
    ind3(ii) = find(STD.coordinate_operation_parameter.parameter_code == proj_conv.param.codes(ii));
end
proj_conv.param.name        =      STD.coordinate_operation_parameter.parameter_name(ind3);
proj_conv.param.value       =      STD.coordinate_operation_parameter_value.parameter_value(ind2);

% Conversion parameters; Unit of Measure
proj_conv.param.UoM.codes   =      STD.coordinate_operation_parameter_value.uom_code(ind2);
for ii=1:length(proj_conv.param.UoM.codes)
    ind4(ii) = find(STD.unit_of_measure.uom_code == proj_conv.param.UoM.codes(ii));
end
proj_conv.param.UoM.name = STD.unit_of_measure.unit_of_meas_name(ind4);

