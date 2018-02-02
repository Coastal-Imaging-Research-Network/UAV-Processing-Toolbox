% Create inputs file that can be read by the GUI
% Dataset 1
%% 1. Files and paths
mainPath = 'C:\Users\z5030440\Documents\Git\UAV-Processing-Toolbox\demoGUI\dataset1';

inputs.stationStr = 'MavicC';
inputs.pnIn = fullfile(mainPath,'inputs','frames');
inputs.pncx = fullfile(mainPath,'outputs');
inputs.frameFn = 'narrabeenFrames';
inputs.gcpFn = fullfile(mainPath,'inputs','gcpFileNarrabeen.mat');
inputs.instsFn = fullfile(mainPath,'inputs','InstsFileNarrabeen.m');
inputs.snapshotFn = fullfile(mainPath,'inputs','snapshotNarrabeen.jpg');

%% 2. Date
inputs.dateVect = datevec(now); % is extracted after from snapshot EXIF data
inputs.GMT = '0';               % is extracted after from snapshot EXIF data
inputs.dn0 = datenum(inputs.dateVect) - str2double(inputs.GMT)/24;
inputs.dayFn = argusDay(matlab2Epoch(inputs.dn0));

%% 3. Argus local coordinate system
inputs.ArgusCoordsys.X0 = 342505.207;   % argus local origin X
inputs.ArgusCoordsys.Y0 = 6266731.449;  % argus local origin Y
inputs.ArgusCoordsys.Z0 = 0;            % always mean sea level
inputs.ArgusCoordsys.rot = 0;           % argus rotation angle in degrees
inputs.ArgusCoordsys.EPSG = 28356;      % EPSG code of the local coordsys

%% 4. Camera parameters
% Extrinsic camera parameters
inputs.knownFlags = [0 0 0 0 0 0]; % 1 for constrained, 0 for unconstrained
                                   % order is [ xCam yCam zCam Azimuth Tilt Roll]
bs = [0 0 0 0 0 0 ];                      
inputs.beta0 = bs(find(~inputs.knownFlags));
inputs.knowns = bs(find(inputs.knownFlags));

% Intrinsic camera parameters
inputs.cameraName = 'MavicR';
inputs.cameraRes = [3840 2160];
inputs.FOV = 100; % if not sure, leave 100 degrees (only used to plot horizon on image)

%% 5. Rectification settings
% the length of gcpList and value of nRefs must be >= length(beta0)/2
inputs.gcpList = [1 2 3 4];   % use these gcps for solving the camera extrinsic params
inputs.nRefs = 4;             % number of ref points for stabilization

inputs.rectxy = [-100 0.5 1000 -100 0.5 1000];  % rectification limits in Argus coordinates
inputs.rectz = 0;                               % rectification z-level

% Fixed settings (do not change unless you know what you're doing!
inputs.doImageProducts = 1;    % usually 1.
inputs.showFoundRefPoints = 0; % to display ref points as check
inputs.dt = 0.5/(24*3600);     % delta_t (s) converted to datenums
