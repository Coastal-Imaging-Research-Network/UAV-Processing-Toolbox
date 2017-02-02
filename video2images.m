% This is an example of how to use matlab to resample a MP4 video file at a
% specified sampling rate to save individual images or gather frames for
% further analysis (e.g. timex). 
%
% SRHarrison


% USER Input: (make this into a function
 vid = 'F:\CIRN\Video\DJI_0004.MP4'; % The path&filename of original video
 imagesamplerate = 2; % What is the desired frame rate? [frames per second]
 SaveImages = 1;  % Do you want to save individual frames from the video? 1=yes 0=no.
 CollectFrames = 0; % Do you want to collect frames into array and save? 1=yes 0=no.

 
% Construct a VideoReader object associated with the file
 [pathstr,name,ext]=fileparts(vid);
 obj = VideoReader(vid);

 
% obj contains information about the video, e.g.:
 vidHeight = obj.Height; %height of image in pixels
 vidWidth = obj.Width; %width of image in pixels
 vidFrameRate = obj.FrameRate;  % Maybe you should round this to the nearest int.
 
 
% Resample at desired framerate:
 numberOfFrames = floor(obj.Duration / (1/obj.FrameRate)); %Much faster calculation from given values.
 framesToRead = 1: round(vidFrameRate)/imagesamplerate :numberOfFrames; 
   if CollectFrames ==1 % Only do this if you intend to save the resampled frames as an array
    allFrames = zeros(vidHeight, vidWidth, 3, length(framesToRead));  % Preallocate array to store frames.
   end
 %MAIN LOOP:
 for k = 1: length(framesToRead)
    if mod(k,10)==0; disp(k); end % counter to indicate something happening. 
   frameIdx = framesToRead(k);
   currentFrame = read(obj,frameIdx);
   
   if SaveImages == 1   % Save the frames of interest as jpg images
     combinedString = sprintf([name '_' '%05d.jpg'],k-1);
     imwrite(currentFrame,combinedString);  % Save each frame as an image.
   end
 
   if CollectFrames ==1  %Gather the frames of interest into a giant 4D array (RGB and time)
     if k==1
       % cast the all frames matrix appropriately
       allFrames = cast(allFrames, class(currentFrame)); % This step takes long time!
     end
     allFrames(:,:,:,k) = currentFrame;
   end 
 end
   if CollectFrames ==1  % SAVE THE ARRAY.
   % Save the array of frames for future use:
    save([pathstr filesep name '_resampled_at_' num2str(imagesamplerate) 'fps.mat'], 'allFrames')
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

