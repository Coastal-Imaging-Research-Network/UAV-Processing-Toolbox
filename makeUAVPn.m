function in = makeUAVPn(in)
%   UAVinputs = makeUAVPn(UAVInputs)
%
% start to create a consistent structure of inputs for processing a UAV
% data collection.  UAVinputs is a structure that will contain all the
% input information and will be stored with the results in cx for record
% keeping.  UAVInputs as input to this function must have fields 
% 'stationStr' and 'dateVect'.  To this will added fields 
%   'ArgusDayFn'    the argus folder name, 
%   'pnIn'          the expect full pathname for the input frames
%   'pncx'          the full pathname for the cx output directory

% Below (commented out) is the normal location for CIL product storage
% under /ftp/pub.  For the demo we will store it locally.  However, the
% user should develop a better storage strategy for real data.  Also, note
% that a successful run will leave a 'meta' file in this directory.  If
% someone else tries running the demo this will be found and geometries
% will not be computed for the second person.

% dn0 = datenum(in.dateVect);    % GMT time of first frame
% in.dayFn = argusDay(matlab2Epoch(dn0));
% in.pncx = ['/ftp/pub/' in.stationStr '/' num2str(in.dateVect(1)) ...
%             '/cx/' in.dayFn '/'];    
in.dayFn = 'demoResults';
in.pncx = './demoMovies/demoOutput/';
        
% Below (commented out) is the normal frame location for CIL work
% It has been replaced temporarily by the pathname for the demo clips.  You
% should definitely NOT store your data in the toolbox, so you need to
% change this for your system.

%in.pnIn = ['/scratch/temp/holman/' in.stationStr '/' num2str(in.dateVect(1)) '/'];

in.pnIn = './demoMovies/';       % local demo storage location