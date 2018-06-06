function CS = ConvertCoordinatesFindCoordRefSys(CS,STD)
%CONVERTCOORDINATESFINDCOORDREFSYS Fills coordinate system information
%
%   Finds corresponding code, type and name when only code or name has been
%   specified in the coorinate system information structure.
%
%   Syntax:
%   CS = ConvertCoordinatesFindCoordRefSys(CS,STD)
%
%   Input:
%   CS  = coordinate system structure with only name or code defined
%   STD = structure with all EPSG codes
%
%   Output:
%   CS = complete coordinate system structure
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

% $Id: ConvertCoordinatesFindCoordRefSys.m 7934 2013-01-21 10:35:17Z boer_g $
% $Date: 2013-01-21 11:35:17 +0100 (Mon, 21 Jan 2013) $
% $Author: boer_g $
% $Revision: 7934 $
% $HeadURL: https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/applications/SuperTrans/conversion/ConvertCoordinatesFindCoordRefSys.m $
% $Keywords: $

% code
if ~isempty(CS.code),
    code = STD.coordinate_reference_system.coord_ref_sys_code == CS.code;
else
    code = true(size(STD.coordinate_reference_system.coord_ref_sys_code));
end

% name
if ~isempty(CS.name),
    name = strcmpi(CS.name,STD.coordinate_reference_system.coord_ref_sys_name);
    %also check for approximate matches, is nothing turned up
    if sum(name)==0
        disp('WARNING: no exact match of coordinate system name is found, approximate match tried')
        name = strfind(lower(STD.coordinate_reference_system.coord_ref_sys_name),lower(CS.name));
        name = ~cellfun('isempty',name);
        if sum(name)==0
            error('no approximate match of coordinate system name is found')
        end
    end
else
    name = true(size(STD.coordinate_reference_system.coord_ref_sys_name));
end

%type
if ~isempty(CS.type),
    type = strcmpi(CS.type,STD.coordinate_reference_system.coord_ref_sys_kind);
else
    type = true(size(STD.coordinate_reference_system.coord_ref_sys_kind));
end

ind = find(code&name&type);

% check output, and display errors
if     isempty(ind)
    error(['no coordinate reference system can by found with code:''' CS.code ''',name:''' CS.name ''', type:''' CS.type ''''])
elseif length(ind)==1
    % do nothing
elseif length(ind)<1000
    ERR = sprintf('%d coordinate reference systems can be found with options: \ncode:''%d'', name:''%s'', type:''%s''\n\n',length(ind), CS.code,CS.name,CS.type);
    for ii=1:length(ind)
        ERR = [ERR,sprintf('code:%11s, name:%50s, type:%16s\n',...
            ['''' num2str(STD.coordinate_reference_system.coord_ref_sys_code(ind(ii))) ''''],...
            [''''         STD.coordinate_reference_system.coord_ref_sys_name{ind(ii)}  ''''],...
            [''''         STD.coordinate_reference_system.coord_ref_sys_kind{ind(ii)}  ''''])];
    end
    error(ERR);
else
    error('%d coordinate reference systems can be found with options: \ncode:''%d'', name:''%s'', type:''%s''\n\n',length(ind), CS.code,CS.name,CS.type);
end

CS.code = STD.coordinate_reference_system.coord_ref_sys_code(ind);
CS.name = STD.coordinate_reference_system.coord_ref_sys_name{ind};
CS.type = STD.coordinate_reference_system.coord_ref_sys_kind{ind};
