# put this where the mp4 file is
# run it with "every 15 mp4name"
# this requires mplayer to be on your path
# https://sourceforge.net/projects/mplayerwin/

set inc=%~f1
set inp=%~f2
mkdir %f2%-extracted
cd %f2%-extracted
mplayer -vo png -vf framestep=%inc% %inp%