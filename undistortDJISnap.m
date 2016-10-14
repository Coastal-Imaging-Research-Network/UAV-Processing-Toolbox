function I2 = undistortDJISnap(I, whichDJIStr)
%   I2 = undistortDJISnap(I1, whichDJIStr)

[NV,NU,NC] = size(I);
lcp = makeLCPP2(whichDJIStr,NU,NV);
u = 1: NU;
v = 1: NV;
[U,V] = meshgrid(u,v);
[Ud,Vd] = DJIDistort(U(:),V(:),lcp);
foo = interp2(double(squeeze(I(:,:,1))),Ud,Vd);
I2(:,:,1) = reshape(foo, size(U));
foo = interp2(double(squeeze(I(:,:,2))),Ud,Vd);
I2(:,:,2) = reshape(foo,size(U));
foo = interp2(double(squeeze(I(:,:,3))),Ud,Vd);
I2(:,:,3) = reshape(foo,size(U));
I2 = I2/255;