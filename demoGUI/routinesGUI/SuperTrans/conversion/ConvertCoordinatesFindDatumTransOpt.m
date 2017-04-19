function OPT = ConvertCoordinatesFindDatumTransOpt(OPT,STD)
%CONVERTCOORDINATESFINDDATUMTRANSOPT Find datum transformation options
%
%   This routine finds the options of the datum transformation
%
%   Syntax:
%   OPT = ConvertCoordinatesFindDatumTransOpt(OPT,STD)
%
%   Input:
%   OPT = input options structure
%   STD = structure with all EPSG codes
%
%   Output:
%   OPTS = output options structure
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

% $Id: ConvertCoordinatesFindDatumTransOpt.m 5953 2012-04-12 09:11:21Z boer_g $
% $Date: 2012-04-12 11:11:21 +0200 (Thu, 12 Apr 2012) $
% $Author: boer_g $
% $Revision: 5953 $
% $HeadURL: https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/applications/SuperTrans/conversion/ConvertCoordinatesFindDatumTransOpt.m $
% $Keywords: $

%% find the transformation options

if OPT.CS1.geoRefSys.code == OPT.CS2.geoRefSys.code

    OPT.datum_trans = 'no transformation required';%OPT = rmfield(OPT,'datum_trans');

else % check for identical ellipse/datum yet with different name, such as [] = convertCoordinates(0,0,'CS1.code',31466,'CS2.code',28992)

  if     (OPT.CS1.datum.code == OPT.CS2.datum.code) & ...
         (OPT.CS1.UoM.code   == OPT.CS2.UoM.code)

    OPT.datum_trans = 'no transformation required';% OPT = rmfield(OPT,'datum_trans');

  elseif (OPT.CS1.ellips.code == OPT.CS2.ellips.code) & ...
         (OPT.CS1.UoM.code    == OPT.CS2.UoM.code)

    OPT.datum_trans = 'no transformation required';% OPT = rmfield(OPT,'datum_trans');

  else

    [OPT,ind,direction,ind_alt,dir_alt,dep_alt] = findTransOptions(OPT,STD,OPT.CS1.geoRefSys.code,OPT.CS2.geoRefSys.code,'datum_trans');

    if ~isempty(ind)

        % set parameters, name and code for datum transformation
        OPT.datum_trans.code          = STD.coordinate_operation.coord_op_code(ind);
        OPT.datum_trans.name          = STD.coordinate_operation.coord_op_name(ind);
        OPT.datum_trans.direction     = direction;
        OPT.datum_trans.deprecated    = STD.coordinate_operation.deprecated(ind);
        OPT.datum_trans.scope         = STD.coordinate_operation.coord_op_scope(ind);
        OPT.datum_trans.accuray       = STD.coordinate_operation.coord_op_accuracy(ind);
        OPT.datum_trans.params        = ConvertCoordinatesFindDatumTransParams(OPT.datum_trans.code,STD);
        OPT.datum_trans.method_code   = STD.coordinate_operation.coord_op_method_code(ind);
        OPT.datum_trans.method_name   = STD.coordinate_operation_method.coord_op_method_name{STD.coordinate_operation_method.coord_op_method_code == OPT.datum_trans.method_code};
        OPT.datum_trans.ellips1       = 'CS1';
        OPT.datum_trans.ellips2       = 'CS2';

       %if length(ind_alt)>1 % also include alternative tranformations
        OPT.datum_trans.alt_code       = STD.coordinate_operation.coord_op_code(ind_alt);
        OPT.datum_trans.alt_name       = STD.coordinate_operation.coord_op_name(ind_alt);
        OPT.datum_trans.alt_direction  = dir_alt;
        OPT.datum_trans.alt_deprecated = dep_alt;
        OPT.datum_trans.alt_scope      = STD.coordinate_operation.coord_op_scope(ind_alt);
        OPT.datum_trans.alt_accuray    = STD.coordinate_operation.coord_op_accuracy(ind_alt);
        OPT.datum_trans.alt_method_code= STD.coordinate_operation.coord_op_method_code(ind_alt);
        for ii = 1:length(OPT.datum_trans.alt_method_code)
            OPT.datum_trans.alt_method_name{ii}   = STD.coordinate_operation_method.coord_op_method_name{STD.coordinate_operation_method.coord_op_method_code == OPT.datum_trans.alt_method_code(ii)};
        end
       %end

    else % ind

        % no direct transformation available, try via WGS 84
        OPT.datum_trans = 'no direct transformation available';

        % get ellips for WGS 84
        WGS84.datum.code = 6326;
        OPT.WGS84 = ConvertCoordinatesFindEllips(WGS84,STD);

        %% geogcrs_code1 to WGS 84
        [ OPT,ind,direction,ind_alt,dir_alt] = findTransOptions(OPT,STD,OPT.CS1.geoRefSys.code,4326,'datum_trans_to_WGS84');
        if isempty(ind)
           %OPT.datum_trans_to_WGS84='no direct transformation available';
            OPT.datum_trans = 'no transformation available';
            %            error('no transformation available...');
        else
            % get parameters, name and code for datum transformation TO wgs 84
            OPT.datum_trans_to_WGS84.code             = STD.coordinate_operation.coord_op_code(ind);
            OPT.datum_trans_to_WGS84.name             = STD.coordinate_operation.coord_op_name(ind);
            OPT.datum_trans_to_WGS84.direction        = direction;
           %if length(ind_alt)>1 % also include alternative tranformations
            OPT.datum_trans_to_WGS84.alt_code         = STD.coordinate_operation.coord_op_code(ind_alt);
            OPT.datum_trans_to_WGS84.alt_name         = STD.coordinate_operation.coord_op_name(ind_alt);
            OPT.datum_trans_to_WGS84.alt_direction    = dir_alt;
            OPT.datum_trans_to_WGS84.alt_deprecated   = dep_alt;
           %end
            OPT.datum_trans_to_WGS84.params           = ConvertCoordinatesFindDatumTransParams(STD.coordinate_operation.coord_op_code(ind),STD);
            OPT.datum_trans_to_WGS84.method_code      = STD.coordinate_operation.coord_op_method_code(ind);
            OPT.datum_trans_to_WGS84.method_name      = STD.coordinate_operation_method.coord_op_method_name{STD.coordinate_operation_method.coord_op_method_code == OPT.datum_trans_to_WGS84.method_code};
            OPT.datum_trans_to_WGS84.ellips1          = 'CS1';
            OPT.datum_trans_to_WGS84.ellips2          = 'WGS84';
        end

        %% WGS 84 to geogcrs_code2
        [ OPT,ind,direction,ind_alt,dir_alt] = findTransOptions(OPT,STD,4326,OPT.CS2.geoRefSys.code,'datum_trans_from_WGS84');
        if isempty(ind)
           %OPT.datum_trans_from_WGS84='no direct transformation available';
            OPT.datum_trans = 'no transformation available';
            %             error('no transformation available...');
        else
            % get parameters, name and code for datum transformation TO wgs 84
            OPT.datum_trans_from_WGS84.code           = STD.coordinate_operation.coord_op_code(ind);
            OPT.datum_trans_from_WGS84.name           = STD.coordinate_operation.coord_op_name(ind);
            OPT.datum_trans_from_WGS84.direction      = direction;
           %if length(ind_alt)>1 % also include alternative tranformations
            OPT.datum_trans_from_WGS84.alt_code       = STD.coordinate_operation.coord_op_code(ind_alt);
            OPT.datum_trans_from_WGS84.alt_name       = STD.coordinate_operation.coord_op_name(ind_alt);
            OPT.datum_trans_from_WGS84.alt_direction  = dir_alt;
            OPT.datum_trans_from_WGS84.alt_deprecated = dep_alt;
           %end
            OPT.datum_trans_from_WGS84.params         = ConvertCoordinatesFindDatumTransParams(STD.coordinate_operation.coord_op_code(ind),STD);
            OPT.datum_trans_from_WGS84.method_code    = STD.coordinate_operation.coord_op_method_code(ind);
            OPT.datum_trans_from_WGS84.method_name    = STD.coordinate_operation_method.coord_op_method_name{STD.coordinate_operation_method.coord_op_method_code == OPT.datum_trans_from_WGS84.method_code};
            OPT.datum_trans_from_WGS84.ellips1        = 'WGS84';
            OPT.datum_trans_from_WGS84.ellips2        = 'CS2';
        end

    end  % ind
  end % check ellipse/datum
end % OPT.CS1.geoRefSys.code == OPT.CS2.geoRefSys.code

% finally remove field OPT.datum_trans.code if it is empty
if isfield(OPT.datum_trans_to_WGS84,'code')
    if isempty(OPT.datum_trans_to_WGS84.code)
        OPT = rmfield(OPT,'datum_trans_to_WGS84');
        OPT = rmfield(OPT,'WGS84');
        OPT = rmfield(OPT,'datum_trans_from_WGS84');
    end
end

%%
function [ OPT,ind,direction,ind_alt,dir_alt,dep_alt] = findTransOptions(OPT,STD,geogcrs_code1,geogcrs_code2,datum_trans)

% find available transformation options

ind0   = find(STD.coordinate_operation.source_crs_code == geogcrs_code1 &...
              STD.coordinate_operation.target_crs_code == geogcrs_code2);

% Check if coordinate operation type is transformation
ind=[];
k=0;
for i=1:length(ind0)
    if strcmpi(STD.coordinate_operation.coord_op_type{ind0(i)},'transformation')
        k=k+1;
        ind(k)=ind0(i);
    end
end

direction(1:length(ind)) = {'normal'};

% also look for reverse operations
ind_r0 = find(STD.coordinate_operation.source_crs_code == geogcrs_code2 &...
    STD.coordinate_operation.target_crs_code == geogcrs_code1);

% Check if coordinate operation type is transformation
k=0;
ind_r=[];
for i=1:length(ind_r0)
    if strcmpi(STD.coordinate_operation.coord_op_type{ind_r0(i)},'transformation')
        k=k+1;
        ind_r(k)=ind_r0(i);
    end
end

% check if found methods are reversible, only then add them to list 'ind'
% of possibilities.
reverse_method_codes = STD.coordinate_operation.coord_op_method_code(ind_r);
for ii = 1:length(reverse_method_codes)
    if strcmpi('TRUE',STD.coordinate_operation_method.reverse_op(ii))
        ind(end+1) = ind_r(ii);
        direction(end+1) = {'reverse'};
    end
end

ind_alt = ind;
dir_alt = direction;

% check if found methods are deprecated
dep_alt = STD.coordinate_operation.deprecated(ind_alt);

if ~isempty(OPT.(datum_trans).code)
    % user has defined input
    ii = find(STD.coordinate_operation.coord_op_code(ind_alt) == OPT.(datum_trans).code);
    if isempty(ii)
        error([sprintf(['user defined transformation code ''%d'' is not supported.\n'...
            'choose from available options:\n'],OPT.(datum_trans).code),...
            sprintf('                     ''%d''\n',STD.coordinate_operation.coord_op_code(ind_alt))]);
    else
        ind = ind_alt(ii);
        direction = dir_alt{ii};
        % if method is deprected, give a warning
        if strcmpi(dep_alt{ii},'TRUE')
            disp('Warning: The user defined datum transformation method is deprecated')
        end
    end

    % If no method has been defined by user, use the method found.
    % If more options are found, use the method with the highest code that is
    % not deprecated (it is assumed this value is the newest/best method)
else
    if length(ind_alt)>1
        ii = 1:length(ind_alt);
        ii = ii(strcmpi(dep_alt,'FALSE'));
        [tmp,jj] = max(STD.coordinate_operation.coord_op_code(ind_alt(ii)));
        ii = ii(jj);
        if isempty(ii) % then ignore deprection
            [tmp,ii] = max(STD.coordinate_operation.coord_op_code(ind_alt));
            disp('Warning: The datum transformation method is deprecated; no non-deprecated methods are available')
        end
        ind = ind_alt(ii);
        direction = dir_alt{ii};
    elseif length(ind_alt)==1
        ind = ind_alt;
        direction = direction{1};
        if strcmpi(dep_alt{1},'TRUE')
            disp('Warning: The datum transformation method is deprecated; no non-deprecated methods are available')
        end
    end
end
