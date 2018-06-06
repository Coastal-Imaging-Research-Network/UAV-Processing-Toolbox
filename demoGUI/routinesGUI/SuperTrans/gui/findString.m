function foundStringNr=findString(strs)

handles.SearchWindow    = MakeNewWindow_st('Find',[295 320],'modal');
bgc = get(gcf,'Color');

handles.ListCS     = uicontrol(gcf,'Style','listbox','String',{''},'Position', [ 20 100 255 200],'BackgroundColor',[1 1 1]);
handles.TextString = uicontrol(gcf,'Style','text','string','search :','Position', [ 20 66 50 20],'BackgroundColor',bgc,'HorizontalAlignment','left');
handles.EditString = uicontrol(gcf,'Style','edit','String','','Position', [ 70 70 205 20],'BackgroundColor',[1 1 1],'HorizontalAlignment','left');
handles.PushCancel = uicontrol(gcf,'Style','pushbutton','String','Cancel','Position', [ 170 20 50 20]);
handles.PushOK     = uicontrol(gcf,'Style','pushbutton','String','OK','Position', [ 225 20 50 20]);

set(handles.EditString,     'CallBack',{@EditString_CallBack});
set(handles.ListCS,         'CallBack',{@ListCS_CallBack});
set(handles.PushCancel,     'CallBack',{@PushCancel_CallBack});
set(handles.PushOK,         'CallBack',{@PushOK_CallBack});

handles.Strings=strs;

handles.foundStringNr=[];

guidata(gcf,handles);

uiwait;

handles=guidata(gcf);

if ~isempty(handles.foundStringNr)
    foundStringNr=handles.foundStringNr;
else
    foundStringNr=[];
end

close(gcf);

%%
function EditString_CallBack(hObject,eventdata)

handles=guidata(gcf);
str=get(hObject,'String');

fnd=strfind(lower(handles.Strings),lower(str));
fnd = ~cellfun('isempty',fnd);
iind=find(fnd>0);

strs={''};
%handles.Code=[];
%handles.FoundCodes=[];
if ~isempty(iind)
    for i=1:length(iind)
        strs{i}=handles.Strings{iind(i)};
%        handles.FoundCodes(i)=handles.Codes(iind(i));
    end
    set(handles.ListCS,'String',strs);
    handles.foundStingNr=iind(1);
%    handles.Code=handles.Codes(iind(1));
end
guidata(gcf,handles);

%%
function ListCS_CallBack(hObject,eventdata)
handles=guidata(gcf);
strs=get(handles.ListCS,'String');
foundString=strs{get(hObject,'Value')};
handles.foundStringNr=strmatch(foundString,handles.Strings,'exact');
%handles.Code=handles.FoundCodes(get(hObject,'Value'));
guidata(gcf,handles);

%%
function PushCancel_CallBack(hObject,eventdata)
%handles=guidata(gcf);
%handles.Code=[];
%guidata(gcf,handles);
uiresume;

%%
function PushOK_CallBack(hObject,eventdata)
uiresume;
