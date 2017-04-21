function x2 = convertUnits(x1,sourceUoM,targetUoM,STD)
% CONVERTUNITS converts between different unit of measures
%
%   Converts between different units of measures.
%
%   Syntax:
%   x2 = convertUnits(x1,sourceUoM,targetUoM,STD)
%
%   Input:
%   x1          = input value
%   sourceUoM   = input unit of measure
%   targetUoM   = output unit of measure
%   STD         = structure with all EPSG codes
%
%   Output:
%   x2          = converted value
%
%   See also  qp_unitconversion, UNITCONV, CONVERTCOORDINATES, convert_units

%% Copyright notice
%   --------------------------------------------------------------------
%   Copyright (C) 2010 Deltares
%       <NAME>
%
%       <EMAIL>	
%
%       <ADDRESS>
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
% Created: 29 Oct 2010
% Created with Matlab version: 7.9.0.529 (R2009b)

% $Id: convertUnits.m 7052 2012-07-27 12:44:44Z boer_g $
% $Date: 2012-07-27 14:44:44 +0200 (Fri, 27 Jul 2012) $
% $Author: boer_g $
% $Revision: 7052 $
% $HeadURL: https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/applications/SuperTrans/conversion/convertUnits.m $
% $Keywords: $

%%
if strcmpi(sourceUoM,targetUoM)
    x2 = x1;
else
    ind1 = find(strcmpi(STD.unit_of_measure.unit_of_meas_name,sourceUoM));
    ind2 = find(strcmpi(STD.unit_of_measure.unit_of_meas_name,targetUoM));

    % check if both are both same type:
    if ~strcmp(STD.unit_of_measure.unit_of_meas_type(ind1),STD.unit_of_measure.unit_of_meas_type(ind2))
        error('The type of unit specified (%s) does not match the type that is expected (%s).',...
            STD.unit_of_measure.unit_of_meas_type{ind1},STD.unit_of_measure.unit_of_meas_type{ind2})
    end

    %convert source to SI
    if ismember(sourceUoM, {'metre','radian','unity'})
        xSI = x1;
    else
        % check if conversion parameters are defined
        fact_b = STD.unit_of_measure.factor_b(ind1);
        fact_c = STD.unit_of_measure.factor_c(ind1);
        if ~isnan(fact_b+fact_c)
            % check if the parameter closely resembles pi. If so, replace by pi
            if abs(abs(fact_b)-pi)<0.001, fact_b=pi()*sign(fact_b); end
            if abs(abs(fact_c)-pi)<0.001, fact_c=pi()*sign(fact_c); end
            xSI = x1*fact_b/fact_c;
        else %do something special for every predetermined case
            switch sourceUoM
                case 'sexagesimal DMS'
                    % Pseudo unit. Format: signed degrees - period - minutes (2
                    % digits) - integer seconds (2 digits) - fraction of seconds
                    % (any precision). Must include leading zero in minutes and
                    % seconds and exclude decimal point for seconds. Convert to
                    % degree using formula.
                    x1a  = abs(x1)+2*eps(x1); %correct for numerical error
                    degs = floor(x1a);
                    mins = floor(100*(x1a-degs));
                    secs = 10000*(x1a-degs-mins/100);
                    if secs>60
                        mins = mins+1;
                        secs = 0;
                    end
                    xSI = sign(x1).*(degs+mins/60+secs/3600)/180*pi;
                case 'sexagesimal DM'
                    % Pseudo unit. Format: sign - degrees - decimal point - integer
                    % minutes (two digits) - fraction of minutes (any precision).
                    % Must include leading zero in integer minutes.  Must exclude
                    % decimal point for minutes.  Convert to deg using algorithm.
                    degs =floor(abs(x1));
                    mins = 100*(abs(x1)-degs);
                    xSI = sign(x1).*(degs+mins/60)/180*pi;
                otherwise
                    error(['unable to convert to ''' sourceUoM ''' to an SI unit'])
            end
        end
    end

    %convert SI to target
    if ismember(targetUoM, {'metre','radian','unity'})
        x2 = xSI;
    else
        % check if conversion parameters are defined
        fact_b = STD.unit_of_measure.factor_b(ind2);
        fact_c = STD.unit_of_measure.factor_c(ind2);

        % check if conversion parameters are defined
        if ~isnan(fact_b+fact_c)

            % check if the parameter closely resembles pi. If so, replace by pi
            if abs(abs(fact_b)-pi)<0.001, fact_b=pi()*sign(fact_b); end
            if abs(abs(fact_c)-pi)<0.001, fact_c=pi()*sign(fact_c); end

            x2 = xSI*fact_c/fact_b;
        else %do something special for every predetermined case
            switch targetUoM
                case 'sexagesimal DMS'
                    % Pseudo unit. Format: signed degrees - period - minutes (2
                    % digits) - integer seconds (2 digits) - fraction of seconds
                    % (any precision). Must include leading zero in minutes and
                    % seconds and exclude decimal point for seconds. Convert to
                    % degree using formula.
                    xSI     = (xSI+100*eps)*180/pi; % eps is added to deal
                    % with numerical precision
                    degs    = floor(abs(xSI));
                    mins    = floor((abs(xSI)-degs)*60);
                    secs    = ((abs(xSI)-degs)*60 - mins)*60;
                    x2      = sign(xSI).*(degs+mins/100+secs/10000);
                otherwise
                    error(['unable to convert ''' sourceUoM ''' to ''' targetUoM ''''])
            end
        end
    end
end

