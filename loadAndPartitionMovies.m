% loadAndPartitionMovies
%
% takes a file from somewhere on source disk, then makes the appropriate
% directory in ftp5, copies the mp4 there using a proper name, then breaks
% out the frames somewhere useful.
%
% NOTE - This is VERY specific to CIL organization.  You will need to make
% you own version based on your organization.

sta = 'Aerielle';
sourcePn = '/media/LaCie/bathyDuckDataCollects/100815/1008151014GrazeAngleTests/';
sourceFn = 'DJI_0004.MP4';
dayNm = '281_Oct.08/';
info.time = matlab2Epoch(datenum(2015,10,08,10,18,0));
c1Pn = ['/ftp/pub5/' sta '/2015/c1/'];
cxPn = ['/ftp/pub5/' sta '/2015/cx/'];
tempPn = ['/scratch/temp/holman/' sourceFn(1:end-4)];

info.station = sta;
info.camera = '1';
info.type = 'movie';
info.format = 'mp4';
afn = argusFilename(info);

eval(['!mkdir ' c1Pn dayNm]);    % make c1 day directory
eval(['!mkdir ' cxPn dayNm]);    % and also cx
eval(['!cp ' sourcePn sourceFn ' ' c1Pn dayNm afn])
p = pwd;
eval(['cd ' sourcePn])
eval(['!every 15 ' sourceFn ' ' tempPn])
eval(['cd ' p])
