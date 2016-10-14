function [beta6DOF,refPoints] = initUAVAnalysis(I, gcp, in, meta)
%   [beta6DOF,refPoints] = initUAVAnalysis(I, gcps, input, meta)
%
% Initialize a UAV movie analysis using the first (or any) frame.
% Displays the frame and asks user to ginput the locations of points
% specified in gcpUseList whose locations and id are in gcps.  The
% nonlinear fit is seeded with 6 dof beta0 = [xyzCam azimuth tilt, roll]
% with angles in radians.  Returns the best fit geometry beta6 dof.
% Stage 2 is the creation of nRefPoints reference points, each expressed in 
% a structure
% NOTE - lcp, NU and NV are passed in meta but are made global for nlinfit.  

global globs        % this is only used for output to findUVnDOF
globs = meta.globals;

% break out gcp locations
nGcps = length(in.gcpList);
x = [gcp(in.gcpList).x];
y = [gcp(in.gcpList).y];
z = [gcp(in.gcpList).z];
xyz = [x' y' z'];

% digitize the gcps and find best fit geometry
figure(1); clf
imagesc(I);
disp(['computing geometry using ' num2str(nGcps) ' control points'])
for i = 1: nGcps
    disp(['Digitize ' gcp(in.gcpList(i)).name])
    UV(i,:) = ginput(1);     
end
beta = nlinfit(xyz,[UV(:,1); UV(:,2)],'findUVnDOF',in.beta0);

% plot results
hold on
plot(UV(:,1),UV(:,2),'g*')
UV2 = findUVnDOF(beta,xyz,globs);
UV2 = reshape(UV2,[],2);
plot(UV2(:,1),UV2(:,2),'ro')

% now identify nRefPoints reference points
disp(' ')
disp('Pick small bright reference points.  Ensure that the first is the ')
disp('most isolated from nearby bright objects and give an adequate buffer')
disp('to allow for inter-frame aim point wander.')
disp(' ')
foo = input('Hit CR to replot image and continue - ');
figure(1);clf
imagesc(I)
Ig = rgb2gray(I);
disp('PICK FIRST POINT WITH LARGE BOUNDING BOX')
clear refPoints
beta6DOF = nan(1,6);
beta6DOF(find(globs.knownFlags)) = globs.knowns;
beta6DOF(find(~globs.knownFlags)) = beta;

for i = 1: in.nRefs
    disp(['pick top left and bottom right corner of point ' ...
        num2str(i) ' of ' num2str(in.nRefs)])
    c = ginput(2);
    [refPoints(i).Ur,refPoints(i).Vr, refPoints(i).thresh] = ...
        findCOMRefObjFirstPass(Ig, c);
    refPoints(i).dUV = round(diff(c)/2);
    refPoints(i).xyz = findXYZ6dof(refPoints(i).Ur, refPoints(i).Vr, in.zRefs, ...
        beta6DOF, meta.globals.lcp);
end

