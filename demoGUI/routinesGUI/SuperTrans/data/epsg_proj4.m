function str = epsg_proj4(epsg_code,varargin)
%EPSG_PROJ4  gets the proj4 projection string for an epsg code
%
%   Uses spatialreference.org webservice. If you recieve a proxy error, 
%   adjust the settings in File > Preferences > Web
%
%   Succesfully retrieved data is stored locally in the folder
%   epsg_code_to_proj4params located in the matlab temporary
%   directory. 
%
%   Syntax:
%   proj4 = epsg_proj4(epsg_code,<store>)
%
%   Input:
%   epsg_code  = EPSG code
%   <store>    = optionally directory where to store downloaded data
%                when 1, data is stored OpenEarthTools checkout
%
%   Output:
%   proj4 = proj4 projection string for an epsg code
%
%   Example
%   proj4 = epsg_proj4(4326)
%
%   See also: convertCoordinates, nc_cf_grid_mapping, epsg_wkt

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

% $Id: epsg_proj4.m 7889 2013-01-09 17:12:29Z tda.x $
% $Date: 2013-01-09 18:12:29 +0100 (Wed, 09 Jan 2013) $
% $Author: tda.x $
% $Revision: 7889 $
% $HeadURL: https://svn.oss.deltares.nl/repos/openearthtools/trunk/matlab/applications/SuperTrans/data/epsg_proj4.m $
% $Keywords: $

%%

if nargin==2
   if isnumeric(varargin{1})
      epsg_tempdir = mfilename('fullpath');
      else
      epsg_tempdir = varargin{1};
   end
else
   epsg_tempdir = fullfile(tempdir,'spatialreference.org/ref/epsg',num2str(epsg_code),'proj4'); % same as url
end   

if ~exist(epsg_tempdir,'dir')
    mkpath(epsg_tempdir);
end

epsg_proj4_filename = sprintf('%d.txt',epsg_code);
if exist(fullfile(epsg_tempdir,epsg_proj4_filename),'file')
    fid = fopen(fullfile(epsg_tempdir,epsg_proj4_filename),'r');
    str = fread(fid,inf,'*char')';
    fclose(fid);
else
    try
        if epsg_code==28992 || epsg_code==7415 % here EPSG database is wrong or empty 7415=29882 + NAP!
            str = '+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.999908 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +towgs84=565.4174,50.3319,465.5542,-0.398957388243134,0.343987817378283,-1.87740163998045,4.0725 +no_defs'; % note that epsg tables are wrong for 28992, need to specify ellipsoid explicity manually !
        else
            str = urlread(sprintf('http://spatialreference.org/ref/epsg/%d/proj4/',epsg_code));
        end
        try
            fid = fopen(fullfile(epsg_tempdir,epsg_proj4_filename),'w');
            fwrite(fid,str,'char');
            fclose(fid);
        catch
            disp('no proj4 file could be written');
        end
    catch
        str = sprintf('failed to retreive well known text of EPSG code %d',epsg_code);
        fprintf(2,'%s: cannot get proj4, please work online to be able to access %s,\n  or place a proj4 file manually at %s\n',...
            mfilename,'http://spatialreference.org',fullfile(epsg_tempdir,epsg_proj4_filename));
    end
end