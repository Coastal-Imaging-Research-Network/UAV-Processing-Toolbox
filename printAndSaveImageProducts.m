function printAndSaveImageProducts(finalImages, cxPn, info)
%   printAndSaveImageProducts(finalImages, cxPn, info)
%
% print snap, timex, bright and dark images to figures 10: 13.  Then save
% them in the normal Argus format and save finalImages as a mat file
% info contains information about the argus station and camera
e0 = matlab2Epoch(finalImages.dn);
info.time = e0+1;      % put images 1 second after stacks for ease of order.
figure(10); clf
imagesc(finalImages.snap); 
xlabel('x (m)'); ylabel('y (m)'); title(['Snap for ' datestr(finalImages.dn)])
axis image; grid on
info.type = 'snap';
info.format = 'png';
fn = argusFilename(info);
eval(['print -dpng ' cxPn fn])

% and save the image products
info.type = 'imageProducts';
info.format = 'mat';
imageFn = argusFilename(info);
eval(['save ' cxPn imageFn ' finalImages']) % matlab version

figure(11); clf
imagesc(finalImages.x,finalImages.y,finalImages.timex);
xlabel('x (m)'); ylabel('y (m)'); title(['Timex for ' datestr(finalImages.dn)])
axis xy;axis image; grid on
info.type = 'timex';
info.format = 'png';
fn = argusFilename(info);
eval(['print -dpng ' cxPn fn])

figure(12); clf
imagesc(finalImages.x,finalImages.y,finalImages.bright);
xlabel('x (m)'); ylabel('y (m)'); title(['Bright for ' datestr(finalImages.dn)])
axis xy;axis image; grid on
info.type = 'bright';
info.format = 'png';
fn = argusFilename(info);
eval(['print -dpng ' cxPn fn])

figure(13); clf
imagesc(finalImages.x,finalImages.y,finalImages.dark);
xlabel('x (m)'); ylabel('y (m)'); title(['Dark for ' datestr(finalImages.dn)])
axis xy;axis image; grid on
info.type = 'dark';
info.format = 'png';
fn = argusFilename(info);
eval(['print -dpng ' cxPn fn])
