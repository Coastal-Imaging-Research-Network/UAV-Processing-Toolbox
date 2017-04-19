clear variables;close all;
flist=dir('*.F');
for i=1:length(flist)
    eval(['mex ' flist(i).name]);
end
