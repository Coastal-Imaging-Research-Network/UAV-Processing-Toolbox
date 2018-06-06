function handles=superTransFileConvert(handles,ii)
%SUPERTRANSFILECONVERT   SuperTrans GUI function
%
%   See also: SUPERTRANS

%% Copyright notice
%   --------------------------------------------------------------------
%   Copyright (C) 2008 Deltares
%       Maarten van Ormondt
%
%       Maarten.vanOrmondt@deltares.nl	
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

% This tool is part of <a href="http://OpenEarth.nl">OpenEarthTools</a>.
% OpenEarthTools is an online collaboration to share and manage data and 
% programming tools in an open source, version controlled environment.
% Sign up to recieve regular updates of this function, and to contribute 
% your own tools.

%% Version <http://svnbook.red-bean.com/en/1.5/svn.advanced.props.special.keywords.html>
% Created: 27 Oct 2010
% Created with Matlab version: 7.9.0.529 (R2009b)

% $Id: superTransFileConvert.m 3446 2010-11-29 12:19:40Z ye $
% $Date: 2010-11-29 13:19:40 +0100 (lun., 29 nov. 2010) $
% $Author: ye $
% $Revision: 3446 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/gui/superTransFileConvert.m $
% $Keywords: $

%%
if ii==1
    i1=1;
    i2=2;
%     tr1=handles.Trans1Name;
%     tr2=handles.Trans2Name;
else
    i1=2;
    i2=1;
%     if handles.DoubleTransformation
%         tr1=handles.Trans2Name;
%         tr2=handles.Trans1Name;
%     else
%         tr1=handles.Trans1Name;
%         tr2=handles.Trans2Name;
%     end
end

strs=get(handles.SelectCS(i1),'String');
k=get(handles.SelectCS(i1),'Value');
cs1=strs{k};
tp1=handles.CSType{i1};
strs=get(handles.SelectCS(i2),'String');
k=get(handles.SelectCS(i2),'Value');
cs2=strs{k};
tp2=handles.CSType{i2};

%cd(handles.FilePath);
filterindex=handles.FilterIndex;

% filterspec0= {'*.ldb;*.pol',                       'TEKAL Landboundary File (*.ldb,*.pol)'; ...
%               '*.xyz',                             'Samples file (*.xyz)'; ...
%               '*.grd',                             'Delft3D Grid (*.grd)'; ...
%               '*.map;*.tek',                       'TEKAL Map File (*.map)'; ...
%               '*.map;*.tek',                       'TEKAL Vector File (*.map)'; ...
%               '*.ann',                             'Annotation File (*.ann)'};
filterspec0= {'*.ldb;*.pol',                       'TEKAL Landboundary File (*.ldb,*.pol)'; ...
              '*.xyz',                             'Samples file (*.xyz)'; ...
              '*.grd',                             'Delft3D Grid (*.grd)'};
    
if filterindex==1
    for i=1:size(filterspec0,1)
        filterspec{i,1}=filterspec0{i,1};
        filterspec{i,2}=filterspec0{i,2};
    end
    [filename, pathname, filterindex] = uigetfile(filterspec);
else
    filterspec{1,1}=filterspec0{filterindex,1};
    filterspec{1,2}=filterspec0{filterindex,2};
    for i=1:size(filterspec0,1)
        filterspec{i+1,1}=filterspec0{i,1};
        filterspec{i+1,2}=filterspec0{i,2};
    end
    [filename, pathname, filterindex] = uigetfile(filterspec);
    if filterindex==1
        filterindex=handles.FilterIndex;
    else
        filterindex=filterindex-1;
    end
end

if pathname~=0
    handles.FilePath=pathname;

    if filterindex>0
        handles.FilterIndex=filterindex;
    end

    %cd(handles.CurrentPath);

    NewDataset=0;

    switch filterindex,
        case 1
            % Polyline
            [x,y]=landboundary_da('read',[pathname filename]);
        case 2
            % Samples file
            vals=load([pathname filename]);
            x=vals(:,1);
            y=vals(:,2);
            z=vals(:,3);
        case 3
            % D3D Grid
            %        [x,y]=ReadD3DGrid(pathname,filename);
            [x,y,enc]=wlgrid_da('read',[pathname filename]);
        case 4
            % TEKAL Map
            [x,y,varargout]=ReadTekalMap(pathname,filename);
        case 5
            % TEKAL Vector
            [x,y,varargout]=ReadTekalVector(pathname,filename);
        case 6
            % Annotation file
            [x,y,varargout]=ReadAnnotation(pathname,filename);
    end

    x1=x;
    y1=y;

    if ~isempty(x1) && ~isempty(y1)
        [x2,y2]=convertCoordinates(x1,y1,handles.EPSG,'CS1.name',cs1,'CS1.type',tp1,'CS2.name',cs2,'CS2.type',tp2);
    end

%     if ~isempty(x1) && ~isempty(y1)
%         if handles.DoubleTransformation
%             [x2,y2]=ConvertCoordinates(x1,y1,'CS1.name',cs1,'CS1.type',tp1,'CS2.name',cs2,'CS2.type',tp2);
%         else
%             [x2,y2]=ConvertCoordinates(x1,y1,cs1,tp1,cs2,tp2,handles.CoordinateSystems,handles.Operations,tr1);
%         end
%     end

    switch filterindex,
        case 1
            % Polyline
            [filename pathname]=uiputfile('*.ldb');
            if pathname~=0
                landboundary_da('write',[pathname filename],x2,y2);
            end
        case 2
            % Samples file
            [filename pathname]=uiputfile('*.xyz');
            if pathname~=0
                val=[x2 y2 z];
                save([pathname filename],'val','-ascii');
            end
        case 3
            % D3D Grid
            %        [x,y]=WriteD3DGrid(pathname,filename);
            [filename pathname]=uiputfile('*.grd');
            %        wlgrid('write',[pathname filename],x2,y2,enc);
            switch lower(tp2)
                case{'geo','geographic','spherical','latlon'}
                    tp='Spherical';
                otherwise
                    tp='Cartesian';
            end
            wlgrid_da('write',[pathname filename],x2,y2,enc,tp);
        case 4
            % TEKAL Map
            [x,y,varargout]=WriteTekalMap(pathname,filename);
        case 5
            % TEKAL Vector
            [x,y,varargout]=WriteTekalVector(pathname,filename);
        case 6
            % Annotation file
            [x,y,varargout]=WriteAnnotation(pathname,filename);
    end

end
