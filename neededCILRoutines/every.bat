@rem put this where the mp4 file is
@rem  run it with "every 15 mp4name"
@rem  this requires mplayer to be on your path
@rem    https://sourceforge.net/projects/mplayerwin/

set inc=%~f1
set inp=%~f2
mkdir %inp%-extracted
cd %inp%-extracted
mplayer -vo png -vf framestep=%inc% %inp%

