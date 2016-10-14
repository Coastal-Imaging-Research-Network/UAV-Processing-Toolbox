function finalImages = makeFinalImages(images)
%   finalImages = makeFinalImages(images)
%
% takes an accumated images file and quickly calculates the timex, variance
% and other images

finalImages.dn = images.dn(1);
N = repmat(images.N,[1 1 3]);
finalImages.x = images.x;
finalImages.y = images.y;
finalImages.timex = uint8(images.sumI./N);
finalImages.bright = uint8(images.bright);
finalImages.dark = uint8(images.dark);
finalImages.N = images.N;