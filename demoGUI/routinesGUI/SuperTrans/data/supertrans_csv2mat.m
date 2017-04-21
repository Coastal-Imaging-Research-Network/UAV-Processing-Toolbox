function varargout = supertrans_csv2mat
%SUPERTRANS_CSV2MAT convert bunch of EPSG *.csv files to one mat file
%
%   <D> = supertrans_csv2mat  
%
% reads all *csv required for Supertrans and saves them to a mat file
% called EPSG<new>.mat (because reading the *.csv files is slow)
%
% you can load the data with 
%
%   D = load('EPSG<new>.mat')
%
% See also :supertrans, convertCoordinates<New>

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

% $Id: supertrans_csv2mat.m 4247 2011-03-13 11:27:07Z thijs@damsma.net $
% $Date: 2011-03-13 12:27:07 +0100 (dim., 13 mars 2011) $
% $Author: thijs@damsma.net $
% $Revision: 4247 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/data/supertrans_csv2mat.m $
% $Keywords: $

%% get all csv files in csv dir, and put their contents in SuperTransData.m
clear all

%% get all csv files in csv dir
csvFiles = dir2(fullfile(filepathstr(mfilename('fullpath'))),'dir_excl','[^(csv_files)|(custom_additions_to_epsg_db)]','file_incl','\.csv$'); 
csvFiles([csvFiles.isdir]) = [];
%% add them all to superTransData.m
for iCsvFile = 1:length(csvFiles)
    fclose all;
    
    disp(['processing ',num2str(iCsvFile,'%0.3d'),' of ',num2str(length(csvFiles),'%0.3d'),': ',csvFiles(iCsvFile).name])
    fid = fopen([csvFiles(iCsvFile).pathname,csvFiles(iCsvFile).name]);

    %% get header names
    tLine0=fgetl(fid);
    rowNames=lower(strread(tLine0,'%q','delimiter',','));    
    %replace spaces in headers
    for jj=1:length(rowNames)
        rowNames{jj}=strrep(rowNames{jj},' ','_');
    end
    fileName = csvFiles(iCsvFile).name;
    fileName = fileName(1:end-4);
    
    if exist('EPSG','var')
        if isfield(EPSG,fileName)
            fields = fieldnames(EPSG.(fileName));
            nn = length(EPSG.(fileName).(fields{1}));
        else
            nn = 0;
        end
    else
        nn = 0;
    end
        
    %% find headers that refer to data that should be interpreted as numbers
    %in stead of strings
    for jj=1:length(rowNames) 
        if (strcmpi(rowNames{jj}(end-3:end),'code')&&~strcmpi(rowNames{jj}(1:5),'iso_a'))...
                ||strcmpi(rowNames{jj}(end-2:end),'lat')...
                ||strcmpi(rowNames{jj}(end-2:end),'lon')...
                ||strcmpi(rowNames{jj},'semi_minor_axis')...
                ||strcmpi(rowNames{jj},'semi_major_axis')...
                ||strcmpi(rowNames{jj},'inv_flattening')...
                ||strcmpi(rowNames{jj},'factor_b')... 
                ||strcmpi(rowNames{jj},'factor_c')...
                ||strcmpi(rowNames{jj},'parameter_value')  
                isNum(jj) = true;
        else
            isNum(jj) = false;
        end
    end
   
    %% read entire file
    for ii=1:2147483647 %max size of for loop
        tLine = fgetl(fid);
        if ~ischar(tLine),   break,   end
        % check for text qualifiers '"'; if they are found,
        % add new lines till another text qualifier is found
        if any(strfind(tLine,'"'))
            while odd(sum(tLine=='"'))
                tLine=[tLine,fgetl(fid)];
            end
            %then replace delimiters (',') between text qualifiers with ';'
            textQualifiers = strfind(tLine,'"');
            delimiters = strfind(tLine,',');
            for kk=1:2:length(textQualifiers)
                tLine(delimiters(delimiters>textQualifiers(kk)&delimiters<textQualifiers(kk+1)))=';';
            end
        end
        content=strread(tLine,'%q','delimiter',',');
        for jj=1:length(content)
            if isNum(jj)
                EPSG.(fileName).(rowNames{jj})(ii+nn)=str2double(content(jj));
            else
                EPSG.(fileName).(rowNames{jj})(ii+nn)=content(jj);
            end
        end
    end
    fclose(fid);
end

save(fullfile(filepathstr(mfilename('fullpath')),'EPSG'),'-struct','EPSG','-V6'); 

if nargout==1
   varargout = {EPSG};
end