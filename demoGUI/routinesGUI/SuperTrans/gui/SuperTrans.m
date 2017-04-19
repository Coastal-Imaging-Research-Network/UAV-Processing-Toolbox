function SuperTrans(varargin)
%SUPERTRANS   GUI for transformation between coordinate systems
%
%   With this program, you can perform coordinate transformations between
%   various coordinate systems. 
%
%   Syntax:
%   SuperTrans
%
%   See also: CONVERTCOORDINATES

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

% $Id: SuperTrans.m 4873 2011-07-19 15:03:29Z ormondt $
% $Date: 2011-07-19 17:03:29 +0200 (mar., 19 juil. 2011) $
% $Author: ormondt $
% $Revision: 4873 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/gui/SuperTrans.m $
% $Keywords: $

%%
if isempty(which('MakeNewWindow'))
    error('First run oetsettings!');
    return
end

curdir=pwd;

if ~isempty(varargin)
    handles.EPSG=varargin{1};
else
    handles.EPSG = load('EPSG.mat');
    if exist('EPSG_ud.mat','file')
        sud=load('EPSG_ud.mat');
        fnames1=fieldnames(handles.EPSG);
        for i=1:length(fnames1)
            fnames2=fieldnames(handles.EPSG.(fnames1{i}));
            for j=1:length(fnames2)
                if ~isempty(sud.(fnames1{i}).(fnames2{j}))
                    nori=length(handles.EPSG.(fnames1{i}).(fnames2{j}));
                    nnew=length(sud.(fnames1{i}).(fnames2{j}));
                    for k=1:nnew
                        if iscell(handles.EPSG.(fnames1{i}).(fnames2{j}))
                            handles.EPSG.(fnames1{i}).(fnames2{j}){nori+k}=sud.(fnames1{i}).(fnames2{j}){k};
                        else
                            handles.EPSG.(fnames1{i}).(fnames2{j})(nori+k)=sud.(fnames1{i}).(fnames2{j})(k);
                        end
                    end
                end
            end
        end
    end
end

handles.OPT=[];

handles.MainWindow      = MakeNewWindow('SuperTrans',[760 550],'resize','off');
handles.BackgroundColor = get(gcf,'Color');
bgc                     = handles.BackgroundColor;
handles.FilterIndex     = 1;
handles.FilePath        = curdir;

nproj=0;
ngeo=0;

for i=1:length(handles.EPSG.coordinate_reference_system.coord_ref_sys_kind)
    switch lower(handles.EPSG.coordinate_reference_system.coord_ref_sys_kind{i}),
        case{'projected'}
            switch lower(handles.EPSG.coordinate_reference_system.coord_ref_sys_name{i})
                case{'epsg vertical perspective example'}
                    % This thing doesn't work
                otherwise
                    nproj=nproj+1;
                    handles.CSProj(nproj)=i;
                    handles.StrProj{nproj}=handles.EPSG.coordinate_reference_system.coord_ref_sys_name{i};
                    handles.ProjCode(nproj)=handles.EPSG.coordinate_reference_system.coord_ref_sys_code(i);
            end
        case{'geographic 2d'}
            if handles.EPSG.coordinate_reference_system.coord_ref_sys_code(i)<1000000
                ngeo=ngeo+1;
                handles.CSGeo(ngeo)=i;
                handles.StrGeo{ngeo}=handles.EPSG.coordinate_reference_system.coord_ref_sys_name{i};
                handles.GeoCode(ngeo)=handles.EPSG.coordinate_reference_system.coord_ref_sys_code(i);
            end
    end
end

% menu

f = uimenu('Label','File Convert');
    uimenu(f,'Label','Convert A --> B','Callback',{@FileConvert_CallBack,1});
    uimenu(f,'Label','Convert B --> A','Callback',{@FileConvert_CallBack,2});
    uimenu(f,'Label','Exit','Callback','close(gcf)','Separator','on');
f = uimenu('Label','Manage');
    uimenu(f,'Label','Datums','Callback',{@ManageDatums_CallBack},'Enable','off');
    uimenu(f,'Label','Coordinate Systems','Callback',{@ManageCoordinateSystems_CallBack},'Enable','off');
f = uimenu('Label','Help');
    uimenu(f,'Label','Online help','Callback','web(''http://public.deltares.nl/display/OET/Supertrans'',''-browser'')');
    uimenu(f,'Label','EPSG Geodetic Parameter Registry','Callback','web(''http://www.epsg-registry.org/'',''-browser'')');
    uimenu(f,'Label','About','Callback',{@About_CallBack},'Enable','on');
    
% buttons

uipanel('Title','Coordinate System A','Units','pixels','Position',[ 20 215 355 325],'BackgroundColor',bgc);
uipanel('Title','Coordinate System B','Units','pixels','Position',[385 215 355 325],'BackgroundColor',bgc);

handles.ToggleXY(1)                = uicontrol(gcf,'Style','radiobutton','String','Eastings / Northings','Position',[ 30 500 120 20],'BackgroundColor',bgc,'Tag','UIControl');
handles.ToggleGeo(1)               = uicontrol(gcf,'Style','radiobutton','String','Latitude / Longitude','Position',[160 500 120 20],'BackgroundColor',bgc,'Tag','UIControl');
set(handles.ToggleXY(1),'Value',1);
set(handles.ToggleGeo(1),'Value',0);

handles.ToggleXY(2)                = uicontrol(gcf,'Style','radiobutton','String','Eastings / Northings','Position',[400 500 120 20],'BackgroundColor',bgc,'Tag','UIControl');
handles.ToggleGeo(2)               = uicontrol(gcf,'Style','radiobutton','String','Latitude / Longitude','Position',[530 500 120 20],'BackgroundColor',bgc,'Tag','UIControl');
set(handles.ToggleXY(2),'Value',0);
set(handles.ToggleGeo(2),'Value',1);

handles.SelectCS(1)                = uicontrol(gcf,'Style','popupmenu','String',handles.StrProj,'Position', [ 30 470 245 20],'BackgroundColor',[1 1 1],'Tag','UIControl');
handles.PushFindCS(1)              = uicontrol(gcf,'Style','pushbutton','String','?','Position', [275 470 14 20],'ToolTipString','Find','Tag','UIControl');
handles.TextCS(1)                  = uicontrol(gcf,'Style','text','String','code : ','Position', [295 466 75 20],'HorizontalAlignment','left','BackgroundColor',bgc,'Tag','UIControl');

handles.SelectCS(2)                = uicontrol(gcf,'Style','popupmenu','String',handles.StrGeo, 'Position',[395 470 245 20],'BackgroundColor',[1 1 1],'Tag','UIControl');
handles.PushFindCS(2)              = uicontrol(gcf,'Style','pushbutton','String','?','Position', [640 470 14 20],'ToolTipString','Find','Tag','UIControl');
handles.TextCS(2)                  = uicontrol(gcf,'Style','text','String','code : ','Position', [660 466 75 20],'HorizontalAlignment','left','BackgroundColor',bgc,'Tag','UIControl');

handles.TextDatum(1)               = uicontrol(gcf,'Style','text','String','Datum : ',    'Position',[ 30 440 330 20],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');
handles.TextDatum(2)               = uicontrol(gcf,'Style','text','String','Datum : ',    'Position',[395 440 330 20],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');
handles.TextEllipsoid(1)           = uicontrol(gcf,'Style','text','String','Ellipsoid : ','Position',[ 30 420 330 20],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');
handles.TextEllipsoid(2)           = uicontrol(gcf,'Style','text','String','Ellipsoid : ','Position',[395 420 330 20],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');
handles.TextCoordinateOperation(1) = uicontrol(gcf,'Style','text','String','Operation : ','Position',[ 30 400 330 20],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');
handles.TextCoordinateOperation(2) = uicontrol(gcf,'Style','text','String','Operation : ','Position',[395 400 330 20],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');

for i=1:7
    handles.TextConversionParameters(1,i) = uicontrol(gcf,'Style','text','String','','Position',[ 30 400-i*25-4 170 20],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');
    handles.TextConversionParameters(2,i) = uicontrol(gcf,'Style','text','String','','Position',[395 400-i*25-4 170 20],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');
    handles.EditConversionParameters(1,i) = uicontrol(gcf,'Style','edit','String','','Position',[200 400-i*25   100 20],'BackgroundColor',[1 1 1],'HorizontalAlignment','right','Tag','UIControl');
    handles.EditConversionParameters(2,i) = uicontrol(gcf,'Style','edit','String','','Position',[565 400-i*25   100 20],'BackgroundColor',[1 1 1],'HorizontalAlignment','right','Tag','UIControl');
    handles.TextConversionUnits(1,i)      = uicontrol(gcf,'Style','text','String','','Position',[305 400-i*25-4  60 20],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');
    handles.TextConversionUnits(2,i)      = uicontrol(gcf,'Style','text','String','','Position',[670 400-i*25-4  60 20],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');
end
set(handles.EditConversionParameters,'Enable','off');

uipanel('Title','Datum Transformation','Units','pixels','Position',[20 60 720 150],'BackgroundColor',bgc);

handles.SelectDatumTransformationMethod=uicontrol(gcf,'Style','popupmenu','String','datums','Position',[ 30 170 230 20],'BackgroundColor',[1 1 1],'Tag','UIControl');
handles.TextDatumTransformationCode=uicontrol(gcf,'Style','text','String','code : ','Position',[265 166 70 20],'HorizontalAlignment','left','BackgroundColor',bgc,'Tag','UIControl');
handles.TextTransformationMethod=uicontrol(gcf,'Style','text','String','','Position',[ 30 145 400 15],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');
for i=1:3
    handles.TextTransformationParameters(i)   = uicontrol(gcf,'Style','text','String','','Position',[ 25 145-i*25-4  90 20],'BackgroundColor',bgc,'HorizontalAlignment','right','Tag','UIControl');
    handles.EditTransformationParameters(i)   = uicontrol(gcf,'Style','edit','String','','Position',[120 145-i*25    80 20],'BackgroundColor',[1 1 1],'HorizontalAlignment','right','Tag','UIControl');
    handles.TextTransformationUnits(i)        = uicontrol(gcf,'Style','text','String','','Position',[205 145-i*25-4  50 20],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');
end
for i=1:3
    handles.TextTransformationParameters(i+3) = uicontrol(gcf,'Style','text','String','','Position',[260 145-i*25-4  90 20],'BackgroundColor',bgc,'HorizontalAlignment','right','Tag','UIControl');
    handles.EditTransformationParameters(i+3) = uicontrol(gcf,'Style','edit','String','','Position',[355 145-i*25    80 20],'BackgroundColor',[1 1 1],'HorizontalAlignment','right','Tag','UIControl');
    handles.TextTransformationUnits(i+3)      = uicontrol(gcf,'Style','text','String','','Position',[440 145-i*25-4  50 20],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');
end
for i=1:3
    handles.TextTransformationParameters(i+6) = uicontrol(gcf,'Style','text','String','','Position',[505 145-i*25-4  90 20],'BackgroundColor',bgc,'HorizontalAlignment','right','Tag','UIControl');
    handles.EditTransformationParameters(i+6) = uicontrol(gcf,'Style','edit','String','','Position',[600 145-i*25    80 20],'BackgroundColor',[1 1 1],'HorizontalAlignment','right','Tag','UIControl');
    handles.TextTransformationUnits(i+6)      = uicontrol(gcf,'Style','text','String','','Position',[685 145-i*25-4  50 20],'BackgroundColor',bgc,'HorizontalAlignment','left','Tag','UIControl');
end
set(handles.EditTransformationParameters,'Enable','off');

handles.EditX(1)      = uicontrol(gcf,'Style','edit','String','200000.0','Position',[ 35 20 80 20],'BackgroundColor',[1 1 1],'HorizontalAlignment','right','Tag','UIControl');
handles.EditY(1)      = uicontrol(gcf,'Style','edit','String','500000.0','Position',[155 20 80 20],'BackgroundColor',[1 1 1],'HorizontalAlignment','right','Tag','UIControl');
handles.EditX(2)      = uicontrol(gcf,'Style','edit','String','0.0','Position',[540 20 80 20],'BackgroundColor',[1 1 1],'HorizontalAlignment','right','Tag','UIControl');
handles.EditY(2)      = uicontrol(gcf,'Style','edit','String','0.0','Position',[660 20 80 20],'BackgroundColor',[1 1 1],'HorizontalAlignment','right','Tag','UIControl');
                
handles.TextX(1)      = uicontrol(gcf,'Style','text','String','x','Position',[  0 16 30 20],'HorizontalAlignment','right','BackgroundColor',bgc,'Tag','UIControl');
handles.TextY(1)      = uicontrol(gcf,'Style','text','String','y','Position',[120 16 30 20],'HorizontalAlignment','right','BackgroundColor',bgc,'Tag','UIControl');
handles.TextX(2)      = uicontrol(gcf,'Style','text','String','lon','Position',[505 16 30 20],'HorizontalAlignment','right','BackgroundColor',bgc,'Tag','UIControl');
handles.TextY(2)      = uicontrol(gcf,'Style','text','String','lat','Position',[625 16 30 20],'HorizontalAlignment','right','BackgroundColor',bgc,'Tag','UIControl');

handles.PushConvert(1)= uicontrol(gcf,'Style','pushbutton','String','<-- Convert','Position',[310 20 65 20],'Tag','UIControl');
handles.PushConvert(2)= uicontrol(gcf,'Style','pushbutton','String','Convert -->','Position',[385 20 65 20],'Tag','UIControl');

handles.PushTrans(1)  = uicontrol(gcf,'Style','pushbutton','String','A','Position',[350 170 20 20],'Tag','UIControl');
handles.PushTrans(2)  = uicontrol(gcf,'Style','pushbutton','String','B','Position',[370 170 20 20],'Tag','UIControl');

handles.CSName{1}     = 'Amersfoort / RD New';
handles.CSName{2}     = 'WGS 84';

handles.CSType{1}     = 'xy';
handles.CSType{2}     = 'geo';

handles.XYNr{1}       = strmatch(handles.CSName{1},handles.StrProj,'exact');
handles.XYNr{2}       = handles.XYNr{1};
handles.GeoNr{1}      = strmatch(handles.CSName{2},handles.StrGeo,'exact');
handles.GeoNr{2}      = handles.GeoNr{1};

handles.CSCode(1)     = handles.ProjCode(handles.XYNr{1});
handles.CSCode(2)     = handles.GeoCode(handles.GeoNr{2});

handles.ConversionOK=1;
handles.TransformationOK=1;

handles.OPT = FindCSOptions(handles.OPT,handles.EPSG,'CS1.code',handles.CSCode(1),'CS1.type',handles.CSType{1},'CS2.code',handles.CSCode(2),'CS2.type',handles.CSType{2});

set(handles.SelectCS(1),'Value',handles.XYNr{1});
set(handles.SelectCS(2),'Value',handles.GeoNr{2});

set(handles.TextCS(1),'String',['code : ' num2str(handles.OPT.CS1.code)]);
set(handles.TextCS(2),'String',['code : ' num2str(handles.OPT.CS2.code)]);

handles.CS(1)=handles.CSProj(handles.XYNr{1});
handles.CS(2)=handles.CSGeo(handles.GeoNr{2});

handles.OPT = ConvertCoordinatesFindDatumTransOpt(handles.OPT,handles.EPSG);

set(handles.SelectCS(1),     'CallBack',{@SelectCS_CallBack,1});
set(handles.SelectCS(2),     'CallBack',{@SelectCS_CallBack,2});
set(handles.PushFindCS(1),   'CallBack',{@PushFindCS_CallBack,1});
set(handles.PushFindCS(2),   'CallBack',{@PushFindCS_CallBack,2});
set(handles.ToggleXY(1),     'CallBack',{@ToggleXY_CallBack,1});
set(handles.ToggleXY(2),     'CallBack',{@ToggleXY_CallBack,2});
set(handles.ToggleGeo(1),    'CallBack',{@ToggleGeo_CallBack,1});
set(handles.ToggleGeo(2),    'CallBack',{@ToggleGeo_CallBack,2});
set(handles.SelectDatumTransformationMethod,'CallBack',{@SelectDatumTransformationMethod_CallBack});
set(handles.PushConvert(1),  'CallBack',{@PushConvert_CallBack,2});
set(handles.PushConvert(2),  'CallBack',{@PushConvert_CallBack,1});
set(handles.PushTrans(1),    'CallBack',{@PushTrans_CallBack,1});
set(handles.PushTrans(2),    'CallBack',{@PushTrans_CallBack,2});

handles=RefreshInput(handles,1);
handles=RefreshInput(handles,2);
handles=RefreshDatumTransformation(handles);

guidata(gcf,handles);

%%
function handles=RefreshInput(handles,ii)

OPT=handles.OPT;

if ii==1
    CS=OPT.CS1;
    proj_conv=OPT.proj_conv1;
else
    CS=OPT.CS2;
    proj_conv=OPT.proj_conv2;
end

set(handles.TextDatum(ii),'String',['Datum : ' CS.datum.name]);
set(handles.TextEllipsoid(ii),'String',['Ellipsoid : ' CS.ellips.name]);

if strcmpi(CS.type,'projected')

    % Projection
    set(handles.TextCoordinateOperation(ii),'String',['Operation : ' proj_conv.method.name]);
    set(handles.TextCoordinateOperation(ii),'Visible','on');

    n=length(proj_conv.param.codes);
    
    pars=[];
    
    switch proj_conv.method.code
        case{9801} % Lambert Conic Conformal (1SP)
            pars{1}='Latitude of natural origin';
            pars{2}='Longitude of natural origin';
            pars{3}='False easting';
            pars{4}='False northing';
            pars{5}='Scale factor at natural origin';
        case{9802,9803}
            pars{1}='Longitude of false origin';
            pars{2}='Easting at false origin';
            pars{3}='Latitude of false origin';
            pars{4}='Northing at false origin';
            pars{5}='Latitude of 1st standard parallel';
            pars{6}='Latitude of 2nd standard parallel';
        case{9807,9808,9809}
            pars{1}='Longitude of natural origin';
            pars{2}='Latitude of natural origin';
            pars{3}='False easting';
            pars{4}='False northing';
            pars{5}='Scale factor at natural origin';
        case{9812}
            pars{1}='False easting';
            pars{2}='False northing';
            pars{3}='Longitude of projection centre';
            pars{4}='Latitude of projection centre';
            pars{5}='Azimuth of initial line';
            pars{6}='Angle from Rectified to Skew Grid';
            pars{7}='Scale factor on initial line';
        case{9815}
            pars{1}='Easting at projection centre';
            pars{2}='Northing at projection centre';
            pars{3}='Longitude of projection centre';
            pars{4}='Latitude of projection centre';
            pars{5}='Azimuth of initial line';
            pars{6}='Angle from Rectified to Skew Grid';
            pars{7}='Scale factor on initial line';           
        case{9818}
            pars{1}='Longitude of natural origin';
            pars{2}='Latitude of natural origin';
            pars{3}='False easting';
            pars{4}='False northing';
        otherwise
            for j=1:length(proj_conv.param.codes)
                pars{j} = proj_conv.param.name{j};
            end
    end

    for k=1:n
        jj=strmatch(lower(pars{k}),lower(proj_conv.param.name),'exact');
        flds{k}=proj_conv.param.name{jj};
        units{k}=proj_conv.param.UoM.name{jj};
        units{k}=ConvertUnitString(units{k});
        val(k)=proj_conv.param.value(jj);
    end

    for k=1:n
        set(handles.TextConversionParameters(ii,k),'String',flds{k});
        if ~strcmp(units{k},'deg')
            set(handles.EditConversionParameters(ii,k),'String',num2str(val(k),'%0.9g'));
        else
            dms=d2dms(val(k));
            degstr=[num2str(dms.dg) ' ' num2str(dms.mn) ''' ' num2str(dms.sc) '"'];
            set(handles.EditConversionParameters(ii,k),'String',degstr);
        end
        set(handles.TextConversionUnits(ii,k),'String',units{k});
        set(handles.TextConversionParameters(ii,k),'Visible','on');
        set(handles.EditConversionParameters(ii,k),'Visible','on');
        set(handles.TextConversionUnits(ii,k),'Visible','on');
    end
    for k=n+1:7
        set(handles.TextConversionParameters(ii,k),'Visible','off');
        set(handles.EditConversionParameters(ii,k),'Visible','off');
        set(handles.TextConversionUnits(ii,k),'Visible','off');
    end

    % Check if conversion method is available
    switch proj_conv.method.code
        case{9801,9802,9803,9807,9808,9809,9812,9815}
            handles.ConversionOK=1;
        otherwise
            % Conversion method not available
            handles.ConversionOK=0;
            set(handles.TextCoordinateOperation(ii),'String',['Operation : ' proj_conv.method.name ' - NOT YET AVAILABLE !']);
    end
    
else
    set(handles.TextCoordinateOperation(ii),'Visible','off');
    set(handles.TextConversionParameters(ii,:),'Visible','off');
    set(handles.EditConversionParameters(ii,:),'Visible','off');
    set(handles.TextConversionUnits(ii,:),'Visible','off');
end

%%
function handles=RefreshDatumTransformation(handles)

if ~ischar(handles.OPT.datum_trans) || strcmpi(handles.OPT.datum_trans,'no direct transformation available')

         if ~isfield(handles.OPT,'datum_trans_from_WGS84') %only exists when tranforming via WGS 84
             handles.DoubleTransformation=0;
             idoub=0;
         else
             handles.DoubleTransformation=1;
             idoub=1;
         end

         handles.ActiveTransformationMethod=1;

         handles.Trans1=[];
         handles.Trans2=[];

         if isfield(handles.OPT.datum_trans,'name')
             handles.Trans1=strmatch(handles.OPT.datum_trans.name{1},handles.OPT.datum_trans.alt_name,'exact');
             handles.Trans2=1;
             handles.Trans1=handles.Trans1(1);
             handles.Trans2=handles.Trans2(1);
         else
             if isfield(handles.OPT.datum_trans_to_WGS84,'name') && isfield(handles.OPT.datum_trans_from_WGS84,'name')
                 handles.Trans1=strmatch(handles.OPT.datum_trans_to_WGS84.name,handles.OPT.datum_trans_to_WGS84.alt_name,'exact');
                 handles.Trans2=strmatch(handles.OPT.datum_trans_from_WGS84.name,handles.OPT.datum_trans_from_WGS84.alt_name,'exact');
                 handles.Trans1=handles.Trans1(1);
                 handles.Trans2=handles.Trans2(1);
             end
         end
         
         set(handles.PushTrans,'Visible','on');
         set(handles.PushTrans(1),'Enable','on');
         
         if idoub
             set(handles.PushTrans(2),'Enable','on');
         else
             set(handles.PushTrans(2),'Enable','off');
         end

         handles.TransformationOK=1;

         RefreshDatumTransformationOptions(handles);
         handles=RefreshDatumTransformationParameters(handles);

         set(handles.TextDatumTransformationCode,'Visible','on');

else
    if strcmpi(handles.OPT.datum_trans,'no transformation required')
        set(handles.TextTransformationMethod,'String','No datum transformation required','Visible','on');
        set(handles.TextDatumTransformationCode,'Visible','off');
        handles.TransformationOK=1;
    else
        set(handles.TextTransformationMethod,'String','No datum transformation method available !','Visible','on');
        set(handles.TextDatumTransformationCode,'Visible','off');
        handles.TransformationOK=0;
    end
    set(handles.TextTransformationParameters,'Visible','off');
    set(handles.EditTransformationParameters,'Visible','off');
    set(handles.TextTransformationUnits,'Visible','off');
    set(handles.SelectDatumTransformationMethod,'Visible','off');
    set(handles.PushTrans,'Visible','off');
end

%%
function SelectCS_CallBack(hObject,eventdata,ii)
handles=guidata(gcf);
i=get(hObject,'Value');
handles=SelectCS(handles,i,ii);
guidata(gcf,handles);

%%
function ToggleXY_CallBack(hObject,eventdata,ii)
handles=guidata(gcf);
if get(hObject,'Value')
    handles.CSType{ii}='xy';
    i=handles.XYNr{ii};
    handles.CS(ii)=handles.CSProj(i);
    set(handles.SelectCS(ii),'Value',i,'String',handles.StrProj);
    set(handles.ToggleGeo(ii),'Value',0);
    set(handles.TextX(ii),'String','x');
    set(handles.TextY(ii),'String','y');
    handles=SelectCS(handles,i,ii);
%     handles=RefreshInput(handles,ii);
%     handles=RefreshDatumTransformation(handles);
    guidata(gcf,handles);
else
    set(hObject,'Value',1);
end

%%
function ToggleGeo_CallBack(hObject,eventdata,ii)
handles=guidata(gcf);
if get(hObject,'Value')
    handles.CSType{ii}='geo';
    i=handles.GeoNr{ii};
    handles.CS(ii)=handles.CSGeo(i);
    set(handles.SelectCS(ii),'Value',i,'String',handles.StrGeo);
    set(handles.ToggleXY(ii),'Value',0);
    set(handles.TextX(ii),'String','lon');
    set(handles.TextY(ii),'String','lat');
    handles=SelectCS(handles,i,ii);
%     handles=RefreshInput(handles,ii);
%     handles=RefreshDatumTransformation(handles);
    guidata(gcf,handles);
else
    set(hObject,'Value',1);
end

%%
function PushConvert_CallBack(hObject,eventdata,ii)
handles=guidata(gcf);
if ii==1
    i1=1;
    i2=2;
else
    i1=2;
    i2=1;
    if handles.DoubleTransformation
    else
    end
end
x1=str2double(get(handles.EditX(i1),'String'));
y1=str2double(get(handles.EditY(i1),'String'));
strs=get(handles.SelectCS(i1),'String');
k=get(handles.SelectCS(i1),'Value');
cs1=strs{k};
tp1=handles.CSType{i1};
cs1code=handles.CSCode(i1);
strs=get(handles.SelectCS(i2),'String');
k=get(handles.SelectCS(i2),'Value');
cs2=strs{k};
tp2=handles.CSType{i2};
cs2code=handles.CSCode(i2);

if ~isempty(x1) && ~isempty(y1)
    if ~isfield(handles.OPT,'datum_trans_from_WGS84')
%         [x2,y2]=convertCoordinates(x1,y1,handles.EPSG,'CS1.name',cs1,'CS1.type',tp1,'CS2.name',cs2,'CS2.type',tp2,'datum_trans',handles.OPT.datum_trans);
        [x2,y2]=convertCoordinates(x1,y1,handles.EPSG,'CS1.code',cs1code,'CS2.code',cs2code,'datum_trans',handles.OPT.datum_trans);
    else
%         [x2,y2]=convertCoordinates(x1,y1,handles.EPSG,'CS1.name',cs1,'CS1.type',tp1,'CS2.name',cs2,'CS2.type',tp2,...
%             'datum_trans_from_WGS84.code',handles.OPT.datum_trans_from_WGS84.code,'datum_trans_to_WGS84.code',handles.OPT.datum_trans_to_WGS84.code);
        [x2,y2]=convertCoordinates(x1,y1,handles.EPSG,'CS1.code',cs1code,'CS2.code',cs2code,...
            'datum_trans_from_WGS84.code',handles.OPT.datum_trans_from_WGS84.code,'datum_trans_to_WGS84.code',handles.OPT.datum_trans_to_WGS84.code);
    end
    set(handles.EditX(i2),'String',num2str(x2,'%0.9g'));
    set(handles.EditY(i2),'String',num2str(y2,'%0.9g'));
end

%%
function PushFindCS_CallBack(hObject,eventdata,ii)
handles=guidata(gcf);
if strcmpi(handles.CSType{ii},'geo')
    strs=handles.StrGeo;
    codes=handles.GeoCode;
else
    strs=handles.StrProj;
    codes=handles.ProjCode;
end
k=findCoordinateSystem(strs,codes);

if ~isempty(k)
    set(handles.SelectCS(ii),'Value',k);
    handles=SelectCS(handles,k,ii);
end

guidata(gcf,handles);

%%
function RefreshDatumTransformationOptions(handles)

if handles.ActiveTransformationMethod==1
    if ~isfield(handles.OPT,'datum_trans_from_WGS84')
        dtstr='datum_trans';       
    else
        dtstr='datum_trans_to_WGS84';       
    end
else
    dtstr='datum_trans_from_WGS84';       
end

set(handles.SelectDatumTransformationMethod,'String',handles.OPT.(dtstr).alt_name);
if handles.ActiveTransformationMethod==1
    set(handles.SelectDatumTransformationMethod,'Value',handles.Trans1);
else
    set(handles.SelectDatumTransformationMethod,'Value',handles.Trans2);
end
set(handles.SelectDatumTransformationMethod,'Visible','on');

%%
function handles=RefreshDatumTransformationParameters(handles)

if handles.ActiveTransformationMethod==1
    if ~isfield(handles.OPT,'datum_trans_from_WGS84')
        dtstr='datum_trans';       
    else
        dtstr='datum_trans_from_WGS84';       
    end
else
    dtstr='datum_trans_to_WGS84';       
end

set(handles.TextDatumTransformationCode,'String',['code : ' num2str(handles.OPT.(dtstr).code)]);

datum_trans=handles.OPT.(dtstr);

params=datum_trans.params;


set(handles.TextTransformationMethod,'String',['Datum Transformation Method : ' datum_trans.method_name],'Visible','on');

% Check if transformation method is available
switch datum_trans.method_name
    case{'Geocentric translations','Position Vector 7-param. transformation','Coordinate Frame rotation','Molodensky-Badekas 10-parameter transformation'}
        handles.TransformationOK=1;
    otherwise
        % Conversion method not available
        handles.TransformationOK=0;
        set(handles.TextTransformationMethod,'String',['Datum Transformation Method : ' datum_trans.method_name ' - NOT YET AVAILABLE !'],'Visible','on');
end

switch datum_trans.method_name
    case{'Geocentric translations'}
        pars{1}='X-axis translation';
        pars{2}='Y-axis translation';
        pars{3}='Z-axis translation';
    case{'Position Vector 7-param. transformation','Coordinate Frame rotation'}
        pars{1}='X-axis translation';
        pars{2}='Y-axis translation';
        pars{3}='Z-axis translation';
        pars{4}='X-axis rotation';
        pars{5}='Y-axis rotation';
        pars{6}='Z-axis rotation';
        pars{7}='Scale difference';
    otherwise
        for j=1:length(datum_trans.params)
            pars{j} = datum_trans.params.name{j};
        end
end

n=length(pars);

if isfield(params.UoM,'sourceN')
    for k=1:n
        jj=strmatch(lower(pars{k}),lower(params.name),'exact');
        flds{k}=params.name{jj};
        units{k}=params.UoM.sourceN{jj};
        units{k}=ConvertUnitString(units{jj});
        val(k)=params.value(jj);
    end

    for k=1:n
        set(handles.TextTransformationParameters(k),'String',flds{k});
        if ~strcmp(units{k},'deg')
            set(handles.EditTransformationParameters(k),'String',num2str(val(k),'%0.9g'));
        else
            dms=rad2dms(pi*val(k)/180);
            degstr=[num2str(dms(1)) ' ' num2str(dms(2)) ''' ' num2str(dms(3)) '"'];
            set(handles.EditTransformationParameters(k),'String',degstr);
        end
        set(handles.TextTransformationUnits(k),'String',units{k});
        set(handles.EditTransformationParameters(k),'Visible','on');
        set(handles.TextTransformationParameters(k),'Visible','on');
        set(handles.TextTransformationUnits(k),'Visible','on');
    end
    for k=n+1:9
        set(handles.TextTransformationParameters(k),'Visible','off');
        set(handles.EditTransformationParameters(k),'Visible','off');
        set(handles.TextTransformationUnits(k),'Visible','off');
    end

else
    for k=1:9
        set(handles.TextTransformationParameters(k),'Visible','off');
        set(handles.EditTransformationParameters(k),'Visible','off');
        set(handles.TextTransformationUnits(k),'Visible','off');
    end
    handles.TransformationOK=0;
end

%%
function handles=SelectCS(handles,i,ii)

if strcmp(handles.CSType{ii},'xy')
    handles.XYNr{ii}=i;
    handles.CSName{ii}=handles.StrProj{i};
    handles.CSType{ii}='xy';
    handles.CSCode(ii)=handles.ProjCode(i);
else
    handles.CSName{ii}=handles.StrGeo{i};
    handles.GeoNr{ii}=i;
    handles.CSType{ii}='geo';
    handles.CSCode(ii)=handles.GeoCode(i);
end

handles.OPT = FindCSOptions(handles.OPT,handles.EPSG,'CS1.code',handles.CSCode(1),'CS1.type',handles.CSType{1},'CS2.code',handles.CSCode(2),'CS2.type',handles.CSType{2});
handles.OPT = ConvertCoordinatesFindDatumTransOpt(handles.OPT,handles.EPSG);

set(handles.TextCS(1),'String',['code : ' num2str(handles.OPT.CS1.code)]);
set(handles.TextCS(2),'String',['code : ' num2str(handles.OPT.CS2.code)]);

handles=RefreshInput(handles,ii);
handles=RefreshDatumTransformation(handles);

if handles.ConversionOK==1 && handles.TransformationOK==1
    EnableConversion(handles);
else
    DisableConversion(handles);
end


%%
function SelectDatumTransformationMethod_CallBack(hObject,eventdata)
handles=guidata(gcf);

ii=get(hObject,'Value');
    
if handles.ActiveTransformationMethod==1
    if ~isfield(handles.OPT,'datum_trans_to_WGS84')
        datum_trans='datum_trans';       
    else
        datum_trans='datum_trans_to_WGS84';       
    end
    handles.Trans1=ii;
else
    datum_trans='datum_trans_from_WGS84';       
    handles.Trans2=ii;
end

handles.OPT.(datum_trans).name=handles.OPT.(datum_trans).alt_name{ii};
handles.OPT.(datum_trans).code=handles.OPT.(datum_trans).alt_code(ii);
handles.OPT.(datum_trans).params = ConvertCoordinatesFindDatumTransParams(handles.OPT.(datum_trans).code,handles.EPSG);
handles=RefreshDatumTransformationParameters(handles);

if handles.ConversionOK==1 && handles.TransformationOK==1
    EnableConversion(handles);
else
    DisableConversion(handles);
end

guidata(gcf,handles);

%%
function PushTrans_CallBack(hObject,eventdata,ii)
handles=guidata(gcf);
handles.ActiveTransformationMethod=ii;
RefreshDatumTransformationOptions(handles);
RefreshDatumTransformationParameters(handles);
guidata(gcf,handles);

%%
function FileConvert_CallBack(hObject,eventdata,ii)
handles=guidata(gcf);
handles=superTransFileConvert(handles,ii);
guidata(gcf,handles);

%%
function EnableConversion(handles)
set(handles.PushConvert,'Enable','on');
h=findobj(gcf,'Label','Convert A --> B');
set(h,'Enable','on');
h=findobj(gcf,'Label','Convert B --> A');
set(h,'Enable','on');

%%
function DisableConversion(handles)
set(handles.PushConvert,'Enable','off');
h=findobj(gcf,'Label','Convert A --> B');
set(h,'Enable','off');
h=findobj(gcf,'Label','Convert B --> A');
set(h,'Enable','off');

function MenuInput_CallBack(hObject,eventdata)
function MenuOutput_CallBack(hObject,eventdata)
function ManageDatums_CallBack(hObject,eventdata)
function ManageCoordinateSystems_CallBack(hObject,eventdata)

%%
function About_CallBack(hObject,eventdata);

aboutPath = ShowPath;

fid=fopen([aboutPath filesep 'supertrans_about.txt']);
aboutText=fread(fid,'char');
aboutText(aboutText==13)=[];
aboutText = char(aboutText');

if ~isdeployed
    revnumb = '????';
    [tf str] = system(['svn info ' fileparts(which('SuperTrans.m'))]);
    str = strread(str,'%s','delimiter',char(10));
    id = strncmp(str,'Revision:',8);
    if any(id)
        revnumb = strcat(str{id}(min(strfind(str{id},':'))+1:end));
    end
    aboutText = regexprep(aboutText,{'\$revision','\$year','\$month'},{revnumb,datestr(now,'mmmm'),datestr(now,'yyyy')});
end

h = msgbox(aboutText,'About SuperTrans','modal');
uiwait(h);
  

function [thePath] = ShowPath()
% Show EXE path:
if isdeployed % Stand-alone mode.
    [status, result] = system('set PATH');
    thePath = char(regexpi(result, 'Path=(.*?);', 'tokens', 'once'));
else % Running from MATLAB.
    [macroFolder, baseFileName, ext] = fileparts(mfilename('fullpath'));
    thePath = macroFolder;
    % thePath = pwd;
end