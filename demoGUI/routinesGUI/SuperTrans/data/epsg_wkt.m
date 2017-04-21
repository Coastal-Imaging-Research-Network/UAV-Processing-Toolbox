function str = epsg_wkt(epsg_code,varargin)
%EPSG_WKT  gets the well known text representation of an epsg code
%
%   Uses spatialreference.org webservice. If you recieve a proxy error, 
%   adjust the settings in File > Preferences > Web
%
%   Succesfully retrieved data is stored locally in the folder
%   epsg_code_to_in_well_known_text located in the matlab temporary
%   directory. 
%
%   Syntax:
%   wkt = epsg_wkt(epsg_code,<store>)
%
%   Input:
%   epsg_code  = EPSG code
%   <store>    = optionally directory where to store downloaded data
%                when 1, data is stored OpenEarthTools checkout
%
%   Output:
%   wkt = well known text representation of epsg code
%
%   Example
%   wkt = epsg_wkt(4326)
%
%   See also: convertCoordinates, nc_cf_grid_mapping, epsg_proj4

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
% Created: 06 Aug 2010
% Created with Matlab version: 7.10.0.499 (R2010a)

% $Id: epsg_wkt.m 7889 2013-01-09 17:12:29Z tda.x $
% $Date: 2013-01-09 18:12:29 +0100 (Wed, 09 Jan 2013) $
% $Author: tda.x $
% $Revision: 7889 $
% $HeadURL: https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/applications/SuperTrans/data/epsg_wkt.m $
% $Keywords: $

%%
if nargin==2
   if isnumeric(varargin{1})
      epsg_tempdir = mfilename('fullpath');
      else
      epsg_tempdir = varargin{1};
   end
else
   epsg_tempdir = fullfile(tempdir,'spatialreference.org/ref/epsg',num2str(epsg_code),'prettywkt'); % same as url
end

if ~exist(epsg_tempdir,'dir')
    mkpath(epsg_tempdir);
end

epsg_wkt_filename = sprintf('%d.txt',epsg_code);
if exist(fullfile(epsg_tempdir,epsg_wkt_filename),'file')
    fid = fopen(fullfile(epsg_tempdir,epsg_wkt_filename),'r');
    str = fread(fid,inf,'*char')';
    fclose(fid);
else
    try
        str = urlread(sprintf('http://spatialreference.org/ref/epsg/%d/prettywkt/',epsg_code));
        try
            fid = fopen(fullfile(epsg_tempdir,epsg_wkt_filename),'w');
            fwrite(fid,str,'char');
            fclose(fid);
        catch
            disp('no wkt file could be written');
        end
    catch
        str = sprintf('failed to retreive well known text of EPSG code %d',epsg_code);
        fprintf(2,'%s: cannot get wkt, please work online to be able to access %s,\n  or place a wkt file manually at %s\n',...
            mfilename,'http://spatialreference.org',fullfile(epsg_tempdir,epsg_wkt_filename));
    end
end