function [Ur,Vr, thresh, zRef] = findCOMRefObjFirstPass(I, bBox, refType)
%   [URef, VRef, thresh] = findCOMRefObjFirstPass(I,corners)
%
% given a gray shade image, I, find the intensities in a box defined by
% URef and VRef pixels in a box.
% then find the center of mass (COM) of a bright feature (currently defined
% by a user entered threshold chosen by looking at the blow up image.

% Last update: KV WRL 04.2017
% - interactive figure with a slider to select the threshold. 
% - refpoint can be 'bright' or 'dark'
% - automatic thresholding algorithm to provide a first guess for the threshold value
% - z-level of each refpoint can be included


% Plot intensities inside bounding box
bBox = round(bBox);
u = bBox(1,1):bBox(2,1);   
v = bBox(1,2):bBox(2,2);
[U,V]=meshgrid(u,v);
i = I(v,u);
% Automatic thresholding (Otsu's Method)
% Select highest threshold for Bright and lowest for Dark
% if not enough intensity levels for 5 classes, try with 3 and 1
thresh = multithresh(i,5);
if isempty(thresh)
   thresh = multithresh(i,3); 
end
if isempty(thresh)
   thresh = multithresh(i,1); 
end

if strcmpi(refType, 'b')
    
    thresh = thresh(end);
    Ur = mean(U(i>thresh));
    Vr = mean(V(i>thresh));
    
elseif strcmpi(refType, 'd')
    
    thresh = thresh(1);
    Ur = mean(U(i<thresh));
    Vr = mean(V(i<thresh));
end

zRef = 0;

% Make gui for selecting the threshold
f = figure(...
    'Name', 'Center of Mass',...
    'Units', 'normalized',...
    'Position', [0,0,0.7,0.7]);
% Move the window to the center of the screen.
movegui(f, 'center')

hVBoxf = uix.VBox(...
    'Parent', f,...
    'Padding', 5,...
    'Spacing', 10);

hHboxAxes = uix.HBox(...
    'Parent', hVBoxf,...
    'Padding', 5,...
    'Spacing', 5);

% Create Axes 1
hAxes1 = axes(...
    'Parent', hHboxAxes,...
    'Tag', 'axes1',...
    'Visible', 'on');
hold on
colormap(jet)
axis(hAxes1, 'image'); 
axis(hAxes1, 'ij');
imagesc(hAxes1,u, v, i);
plot(hAxes1,Ur,Vr, 'w+')
title(hAxes1, 'Intensity map')

% Create Colorbar
hColorbarAxes1 = colorbar(...
    'Parent', hHboxAxes);

% Create Axes 2
hAxes2 = axes(...
    'Parent', hHboxAxes,...
    'Tag', 'axes2',...
    'Visible', 'on');
hold on
colormap(jet)
axis(hAxes2, 'image'); 
axis(hAxes2, 'ij');
imagesc(hAxes2,u,v,i>thresh);
plot(hAxes2,Ur,Vr, 'w+')
title(hAxes2, 'Thresholded map');
% Create slider
hText = uicontrol(...
    'Parent', hVBoxf,...
    'Style', 'text',...
    'String', 'Intensity threshold',...
    'Fontsize', 10,...
    'Fontweight', 'bold');
hHBoxSlider = uix.HBox(...
    'Parent', hVBoxf,...
    'Padding', 5,...
    'Spacing', 0);
hEmpty = uix.Empty('Parent', hHBoxSlider);
hSlider = uicontrol(...
    'Parent', hHBoxSlider,...
    'Tag', 'sliderIntesity',...
    'Style', 'slider',...
    'Min',min(i(:)),...
    'Max',max(i(:)),...
    'Value',thresh,...
    'Callback', {@slider1_CallBack});
hEmpty = uix.Empty('Parent', hHBoxSlider);
% Create text containing slider value
hHBoxThresh = uix.HBox(...
    'Parent', hVBoxf,...
    'Padding', 5,...
    'Spacing', 0);
hEmpty = uix.Empty('Parent', hHBoxThresh);
hTextThresh = uicontrol(...
    'Parent', hHBoxThresh,...
    'Style', 'text',...
    'String', sprintf('%.0f', thresh),...
    'Fontsize', 10,...
    'FontWeight', 'bold');
hEmpty = uix.Empty('Parent', hHBoxThresh);
% Create edit for zRef input
hHBoxZref = uix.HBox(...
    'Parent', hVBoxf,...
    'Padding', 5,...
    'Spacing', 10);
hText = uicontrol(...
    'Parent', hHBoxZref,...
    'Style', 'text',...
    'String', 'Refpoint Z-level',...
    'Fontsize', 9,...
    'FontWeight', 'bold');
hEditZref = uicontrol(...
    'Parent', hHBoxZref,...
    'Style', 'edit',...
    'String', '0',...
    'Fontsize', 8,...
    'FontWeight', 'normal');
hText = uicontrol(...
    'Parent', hHBoxZref,...
    'Style', 'text',...
    'String', '[m above Argus local origin]',...
    'Fontsize', 9,...
    'FontWeight', 'bold');
hEmpty = uix.Empty('Parent', hHBoxZref);
hButtonOk = uicontrol(...
    'Parent', hHBoxZref,...
    'Style', 'pushbutton',...
    'String', 'Ok',...
    'Callback', {@buttonOk_CallBack});

set(hVBoxf, 'Heights', [-1 30 30 40 30])
set(hHBoxSlider, 'Widths', [-1 -3 -1])
set(hHboxAxes, 'Widths', [-8 -1 -8])
set(hHBoxThresh, 'Widths', [-1 40 -1])
set(hHBoxZref, 'Widths', [-1 80 -1 -1 80]);

uiwait(f)

% Identify a good choise for intensity threshold fro bright / dark

    function [Ur, Vr] = slider1_CallBack(hObject, eventdata)
        
        thresh = hSlider.Value;
        hTextThresh.String = sprintf('%.0f', thresh);
        
        if strcmpi(refType, 'b')
            imagesc(hAxes1,u,v,i);
            imagesc(hAxes2,u,v,i>thresh);
            
            Ur = mean(U(i>thresh));
            Vr = mean(V(i>thresh));
            plot(hAxes1,Ur,Vr, 'w+')
            plot(hAxes2,Ur,Vr, 'w+')
            
        elseif strcmpi(refType, 'd')
            imagesc(hAxes1,u,v,i);
            imagesc(hAxes2,u,v,i<thresh);
            
            Ur = mean(U(i<thresh));
            Vr = mean(V(i<thresh));
            plot(hAxes1,Ur,Vr, 'w+')
            plot(hAxes2,Ur,Vr, 'w+')
        end
        
    end

    function buttonOk_CallBack(hObject, eventdata)
        
        zRef = str2double(hEditZref.String);
        
        if isempty(zRef) || isnan(zRef)
            error('You did not enter a number for Refpoint assumed Z-level')
        end
        
        close(f);
        
    end

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

