% sample an example Aerielle movie.  Set this up as generic for other
% movies 

% The important things are:
%   - the init material below.  Stored as a structure so I can preserve
%       records for each UAV analysis.
%   - a gcp file from a current survey
%   - 

clear
close all

addpath(genpath('.')) % adds folder dependencies 

% required USER INPUT material.  Adapt to each collection
demoInputFile;      % this file contains all of the required inputs.

% create cx directory and load instruments
if ~exist(inputs.pncx)
    mkdir(inputs.pncx)
end

inds = strfind(inputs.instsFn, filesep);
if isempty(inds)
    eval(['insts = ' inputs.instsFn ';']);
else
    p = pwd; eval(['cd ' inputs.instsFn(1:inds(end))])
    eval(['insts = ' inputs.instsFn(inds(end)+1:end) ';']);
    eval(['cd ' p]); clear p
end
clear inds

for i = 1: length(insts)        % save inst info as part of stacks
    stack(i).inst = insts(i);
end
load(inputs.gcpFn);             % load gcps

% find the input folders (may be more than one)
e0 = matlab2Epoch(inputs.dn0);
dum=[inputs.pnIn filesep inputs.frameFn,'*'];
clipFns = dir(dum);
NClips = length(clipFns);
for i = 1: NClips
    fns{i} = dir([inputs.pnIn filesep clipFns(i).name filesep '*png']);
     if isempty(fns{i})
         fns{i} = dir([inputs.pnIn filesep clipFns(i).name filesep '*jpg']);
     end
    Nf(i) = length(fns{i});
end
nt = sum(Nf);
dn = datenum(inputs.dateVect) + ([1:nt]-1)*inputs.dt;

% read the first frame and display.  Do a manual geometry on it if needed.
I = imread([inputs.pnIn filesep clipFns(1).name filesep fns{1}(1).name]);
[NV, NU, NC] = size(I);
Ig = rgb2gray(I);           % for later sampling.
meta.showFoundRefPoints = inputs.showFoundRefPoints; % easy way to pass.

% Because nlinfit requires globals, we set up a variable globals (under 
% metadata) that contains the lcp as well as the flags and values for
% known geometry variables (eg if we know the camera roll).  To minimize
% the use of globals we pass this explicitly except for nlinfit uses when
% we declare it to be global within the calling subroutine.
meta.globals.lcp = makeLCPP3(inputs.stationStr,NU,NV);
meta.globals.knownFlags = inputs.knownFlags;
meta.globals.knowns = inputs.knowns;   
clear NU NV NC 

% When geometries are solved for each frame in turn, the results are saved
% in a metadata file in the cx folder for this day.  First search to see if
% such a folder already exists, in which we don't have to re-do all of the
% geometries.  Allow a few second slop in time (look for first 9 out of 10
% digits in epoch time.

bar = num2str(e0);
foo = dir([inputs.pncx bar(1:9) '*meta*']);
% report the use of an old metadata file, ask for ok
if ~isempty(foo)
    yn = input(['Found old metadata file ' foo(1).name '\n' ...
        'Hit return to continue or anything else to start over...'], ...
        's');
    if ~isempty(yn)
        foo = [];
    end
end
if ~isempty(foo)
    oldGeoms = 1;           % flag that old geoms exist and load
    load([inputs.pncx filesep foo(1).name]); 
    betas = meta.betas;
else
    % if no metafile is found, I initialize one
    oldGeoms = 0;
    betas = nan(nt,6);              % we will save all the betas
    [betas(1,:),meta.refPoints] = initUAVAnalysis(I, gcp, inputs, meta);
end

% set up instruments and stacks - always do this.
insts = fillInsts(insts,betas(1,:),meta);

%%
showInsts(I,insts,betas(1,:),meta.globals);     % plot them to make sure sensible
% if you don't see what you hoped to see, stop and re-create instruments.
foo = input('Hit Ctrl-C if instruments not proper in Figure 3, otherwise <Enter> ');
% save the info in the stacks structure.
for i = 1: length(insts)
    stack(i).inst = insts(i);
    stack(i).dn = dn;
    stack(i).xyzAll = insts(i).xyzAll;
    nPix = size(insts(i).xyzAll,1);
    stack(i).data = nan(nt,nPix,1);        % initialize data
end
xlabel('x (m)'); ylabel('y (m)'); title('Demo Run Time Exposure')

% now save metadata if it wasn't already there
if  oldGeoms==0
    info.time = e0; info.station = inputs.stationStr; info.camera = 'x';
    info.type = 'meta'; info.format = 'mat';
    metaFn = argusFilename(info);
    meta.gcpFn = inputs.gcpFn; meta.gcpList = inputs.gcpList;
    meta.betas = betas;
    eval(['save ' inputs.pncx filesep metaFn ' meta'])
end

% if I have only ONE beta, then I'm working with a new meta file, must do
% geometries. reuse oldGeoms flag for this
if isnan(betas(2,1))
    oldGeoms = 0;
elseif max(find(~isnan(betas(:,1))))<sum(Nf)
    disp(['Have only ' num2str(max(find(~isnan(betas(:,1))))) ' geometries ' ...
        'for ' num2str(sum(Nf)) ' images. Proceeding ...' ] );
end

% Now sample the frames, starting with the first. 
data = sampleDJIFrame(insts, Ig, betas(1,:), meta.globals); % fill first frame
for i = 1: length(data)
    stack(i).data(1,:) = data(i).I';
end
if inputs.doImageProducts
    images.xy = inputs.rectxy;   
    images.z = inputs.rectz;
    images = buildRectProducts(dn(1), images, I, betas(1,:), meta.globals); % initial frame init
end

tic;
nTic = 5;
cnt = 1;        % incremental frame count
fprintf(1, 'Beginning frame processing ...\n');
lastToc = toc;
failFlag = 0;

for clip = 1: NClips    % this is only relevant if you have multiple clips
    nStart = 1; 
    if clip==1
        nStart = 2;
    end
    for i = nStart: Nf(clip) % eventually the length of fns
        cnt = cnt+1;
        if( mod(cnt,nTic) == 0 )
            tottoc = toc;
            pftoc = (tottoc-lastToc)/nTic;
            lastToc = tottoc;
            left = (sum(Nf)-cnt)*toc/cnt;
            leftm = floor(left/60);
            lefts = floor(left-leftm*60);
            fprintf(1, 'frames: %4d/%d total time: %6.1fs per frame: %.2fs remaining time: %2d:%02d\r', ...
                cnt, sum(Nf), tottoc, pftoc, leftm, lefts );
        end;
        
        % read a new frame and find the new geometry, betas, and save in
        % matrix.  Then sample both the stacks and build the image
        % products, if needed.
        I = imread([inputs.pnIn filesep clipFns(clip).name filesep fns{clip}(i).name]);
        Ig = double(rgb2gray(I));
        if ~oldGeoms
            [beta1,~,~,failFlag] = ...
                findNewBeta(Ig,betas(cnt-1,~meta.globals.knownFlags), meta);
            if failFlag         % deal with end of useable run
                break
            else
                betas(cnt,:) = beta1;
            end
        end
        % protect from running out of betas while images still exist
        % with old meta file.
        if isnan(betas(cnt,1))
            break;
        end
        data = sampleDJIFrame(insts, Ig, betas(cnt,:), meta.globals);
        for j = 1: length(data)
            stack(j).data(cnt,:) = data(j).I';
        end
        if inputs.doImageProducts
            images = buildRectProducts(dn(cnt), images, double(I), ...
                betas(cnt,:), meta.globals);
        end
    end
end
if inputs.doImageProducts
    finalImages = makeFinalImages(images);
end

% now save metadata
info.time = e0; info.station = inputs.stationStr; info.camera = 'x';
info.type = 'meta'; info.format = 'mat';
metaFn = argusFilename(info);
meta.gcpFn = inputs.gcpFn; meta.gcpList = inputs.gcpList;
meta.betas = betas;
eval(['save ' inputs.pncx metaFn ' meta'])

% and now the instrument data.  NOTE, data are now called foo!
foo = stack;
for i = 1: length(insts)
    info.type = insts(i).shortName;
    stackFn = argusFilename(info);
    stack = foo(i);
    eval(['save ' inputs.pncx stackFn ' stack'])
end

% print the image products to pngs and save a matlab version
finalImages.snap = imread([inputs.pnIn filesep clipFns(1).name filesep fns{1}(1).name]);
if inputs.doImageProducts
    printAndSaveImageProducts(finalImages, inputs.pncx,info);
end

% final test for full run. warn if not
if failFlag
    warning( ['Loss of lock on base reference point at frame ' num2str(cnt) ]);
elseif( sum(Nf) ~= max(find(~isnan(betas(:,1)))) )
    warning( ['Fewer geometry solutions than than input images. Possible ' ...
        'failure in geoometry solution at frame ' num2str(cnt) ' or ' ...
        'failure to lock on base reference point in previous run.'] );
end

%
%   Copyright (C) 2017  Coastal Imaging Research Network
%                       and Oregon State University

%    This program is free software: you can redistribute it and/or  
%    modify it under the terms of the GNU General Public License as 
%    published by the Free Software Foundation, version 3 of the 
%    License.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see
%                                <http://www.gnu.org/licenses/>.

% CIRN: https://coastal-imaging-research-network.github.io/
% CIL:  http://cil-www.coas.oregonstate.edu
%
%key UAVProcessingToolbox
%

