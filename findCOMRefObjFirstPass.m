function [Ur,Vr, thresh] = findCOMRefObjFirstPass(I, c)
%   [URef, VRef, thresh] = findCOMRefObjFirstPass(I,corners)
%
% given a gray shade image, I, find the intensities in a box defined by
% URef and VRef pixels in a box.
% then find the center of mass (COM) of a bright feature (currently defined
% by a user entered threshold chosen by looking at the blow up image.

thresh = [200: 255];  % test for best threshold (bright)
c = round(c);
u = c(1,1):c(2,1);      % grab small window around control point.
v = c(1,2):c(2,2);
[U,V]=meshgrid(u,v);
i = I(v,u);

% now identify a good choice for intensity threshold
cont = 1;
while ~isempty(cont)
    figure(10); clf
    colormap(jet)
    subplot(121); imagesc(u,v,i); colorbar
    thresh = input('enter a threshold to isolate the target - ');

    Ur = mean(U(i>thresh));
    Vr = mean(V(i>thresh));
    hold on; plot(Ur,Vr, 'w*')
    figure(10);subplot(122)
    imagesc(u,v,i>thresh)
    hold on; plot(Ur,Vr,'w*')
    cont = input('Enter <cr> to accept, 0 to try again - ');
end
close(10)
