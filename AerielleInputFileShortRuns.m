% Demo input file for UAV processing.
% The user is responsible for correcting content for each new analysis

% 1.  Paths, names and time stamp info:
inputs.stationStr = 'Aerielle';  
inputs.dateVect = [2015 10 08 10+4 57 0];       % date/time of first frame
inputs.dt = 0.5/(24*3600);           % delta t (s) converted to datenums
inputs.frameFn = '201510081057AzMovie';            % root of frames folder name
inputs.gcpFn = '/ftp/pub/Aerielle/2015/cx/281_Oct.08/gcp20151008.mat';
inputs.instsFn = '/home/holman/ruby/research/UAVTesting/bathyDuck2015/makeInstsShortRuns';            % instrument m-file location

% 2.  Geometry solution Inputs:
% The six extrinsic variables, the camera location and viewing angles
% in the order [ xCam yCam zCam Azimuth Tilt Roll].
% Some may be known and some unknown.  Enter 1 in knownFlags for known
% variable.  For example, knownFlags = [1 1 0 0 0 1] means that camX and
% camY and roll are known so should not be solved for.  
% Enter values for all parameters below.  If the variable is known, the
% routine will use this data.  If not, this will be the seed for the
% nonlinear search.
inputs.knownFlags = [0 0 0 0 0 1];
lat = dms2degrees([36 10 54.36]);           % data from exiftool.
long = dms2degrees([-75 44 56.60]);        
[x,y] = ll2Argus('argus02b',lat,long);      % convert to local coords
inputs.xyCam = [x y];
inputs.zCam = 64;             % based on last data run                
inputs.azTilt = [0 70] / 180*pi;          % first guess
inputs.roll = 0 / 180*pi; 

% 3.  GCP info
% the length of gcpList and value of nRefs must be >= length(beta0)/2
inputs.gcpList = [11 12 32 28];      % use these gcps for init beta soln
inputs.nRefs = 4;                    % number of ref points for stabilization
inputs.zRefs = 7;                    % assumed z level of ref points

% 4.  Processing parameters
inputs.doImageProducts = 1;                    % usually 1.
inputs.showFoundRefPoints = 0;                 % to display ref points as check
inputs.rectxy = [50 0.5 500 400 0.5 1000];     % rectification specs
inputs.rectz = 0;                              % rectification z-level

% residual calculations - NO USER INPUT HERE
inputs = makeUAVPn(inputs);             % make the path to find init-file
inputs.dn0 = datenum(inputs.dateVect);
bs = [inputs.xyCam inputs.zCam inputs.azTilt inputs.roll];  % fullvector
inputs.beta0 = bs(find(~inputs.knownFlags));
inputs.knowns = bs(find(inputs.knownFlags));


