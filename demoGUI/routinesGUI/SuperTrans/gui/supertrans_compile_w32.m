delete('bin\*');
mkdir bin;

if isempty(which('makenewwindow'))
    run('F:\Repositories\OeTools\oetsettings.m');
end

% remove annoying startup.m in wafo dir from path
rmpath('F:\Repositories\McTools\mc_applications\mc_wave\wafo\docs\');

fid=fopen('complist','wt');
fprintf(fid,'%s\n','-a');
fprintf(fid,'%s\n','EPSG.mat');

% Add general routines
flist=dir('..\general');
test = dir('..\general\*_test.m');
for i=1:length(flist)
        fname=flist(i).name;
        switch fname
            case [{'.','..','.svn'} {test(:).name}]
                otherwise
                    fprintf(fid,'%s\n',fname);
        end
end

% Add conversion_m routines
flist=dir('..\conversion_m');
test = dir('..\conversion_m\*_test.m');
for i=1:length(flist)
        fname=flist(i).name;
        switch fname
            case [{'.','..','.svn'} {test(:).name}]
                otherwise
                    fprintf(fid,'%s\n',fname);
        end
end

% Add conversion routines
flist=dir('..\conversion');
test = dir('..\conversion\*_test.m');
for i=1:length(flist)
        fname=flist(i).name;
        switch fname
            case [{'.','..','.svn','convertCoordinates_test.url','convertcoordinates_test.gif','convertCoordinate_errorMessages.txt'} {test(:).name}]
                otherwise
                    fprintf(fid,'%s\n',fname);
        end
end

% Add gui-routines
flist=dir('.');
test = dir('*_test.m');
for i=1:length(flist)
        fname=flist(i).name;
        switch fname
            case [{'.','..','.svn','supertrans_about.txt','bin','complist','supertrans_compile_w32.m','SuperTrans.m'} {test(:).name}]
                otherwise
                    fprintf(fid,'%s\n',fname);
        end
end

fclose(fid);

% try
%    fid=fopen('supertransicon.rc','wt');
%    fprintf(fid,'%s\n','ConApp ICON supertrans.ico');
%    fclose(fid);
%    system(['"' matlabroot '\sys\lcc\bin\lrc" /i "' pwd '\supertransicon.rc"']);
% end
 
mcc -m -d bin SuperTrans.m -B complist %-M supertransicon.res 

delete('supertransicon.rc');
delete('supertransicon.res');

dos(['copy ' which('supertrans_about.txt') ' bin']);
revnumb = '????';
if isappdata(0,'revisionnumber')
    revnumb = num2str(getappdata(0,'revisionnumber'));
else
    try
        [tf str] = system(['svn info ' fileparts(which('supertrans.m'))]);
        str = strread(str,'%s','delimiter',char(10));
        id = strncmp(str,'Revision:',8);
        if any(id)
            revnumb = strcat(str{id}(min(strfind(str{id},':'))+1:end));
        end
    catch me
        % don't mind
    end
end
strfrep(fullfile('bin','supertrans_about.txt'),{'$revision','$year','$month'},{revnumb,datestr(now,'mmmm'),datestr(now,'yyyy')});

delete('complist');