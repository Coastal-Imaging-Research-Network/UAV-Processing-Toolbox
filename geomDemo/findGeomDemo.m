% Demo input file for UAV processing.
% The user is responsible for correcting content for each new analysis

clear

% 1.  input info for GCP LCP and I data:
inputs.stationStr = 'Aerielle';
inputs.gcpFn = [pwd, filesep, 'demoGCPFile.mat'];
inputs.Ifn = [pwd, filesep, 'exampleSnapP3P.png'];

% 2.  Geometry solution Inputs:
% The six extrinsic variables, the camera location and viewing angles
% in the order [ xCam yCam zCam Azimuth Tilt Roll].
% Some may be known and some unknown.  Enter 1 in knownFlags for known
% variable.  For example, knownFlags = [1 1 0 0 0 1] means that camX and
% camY and roll are known so should not be solved for.  
% Enter values for all parameters below.  If the variable is known, the
% routine will use this data.  If not, this will be the seed for the
% nonlinear search.
inputs.knownFlags = [0 0 0 0 0 0];
inputs.xyCam = [0 600];
inputs.zCam = 100;             % based on last data run                
inputs.azTilt = [95 60] / 180*pi;          % first guess
inputs.roll = 0 / 180*pi; 
betas = [inputs.xyCam inputs.zCam inputs.azTilt inputs.roll];  % fullvector
inputs.beta0 = betas(find(~inputs.knownFlags));
inputs.knowns = betas(find(inputs.knownFlags));

% 3.  Which gcps are visible.  You need to examine your image and determine
% which GCPs can be seen and digitized.  List them in the order that you
% want to digitize them.
inputs.gcpList = [3 2 1 6 7];      % use these gcps for init beta soln

% Because nlinfit requires globals, we set up a variable globals (under 
% metadata) that contains the lcp as well as the flags and values for
% known geometry variables (eg if we know the camera roll).  To minimize
% the use of globals we pass this explicitly except for nlinfit uses when
% we declare it to be global within the calling subroutine.
meta.globals.knownFlags = inputs.knownFlags;
meta.globals.knowns = inputs.knowns;   

% Now load the gcp, lcp and image data
load(inputs.gcpFn);             % load gcps
I = imread(inputs.Ifn);
[NV, NU, NC] = size(I);
meta.globals.lcp = makeLCPP3(inputs.stationStr,NU,NV);

% solve for the geometry, returning all six values in beta
beta = find6DOFGeom(I, gcp, inputs, meta);

% display on image to see quality of fit
x = [gcp(inputs.gcpList).x];
y = [gcp(inputs.gcpList).y];
z = [gcp(inputs.gcpList).z];
xyz = [x' y' z'];
hold on
UV2 = findUVnDOF(beta,xyz,meta.globals);
UV2 = reshape(UV2,[],2);
plot(UV2(:,1),UV2(:,2),'ro')

% display text results cuz this is a demo.
display(['Camera position is ' num2str(beta(1:3))])
display(['Viewing angles are ' num2str(beta(4:6)*180/pi)])
