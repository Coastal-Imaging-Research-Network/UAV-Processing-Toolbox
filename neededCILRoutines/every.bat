@rem Program to extract frames from a video
@rem 	(save this program where the video file is located)
@rem
@rem Input:
@rem 	N = interval number of frames to extract/save
@rem	videoFilename = name of the video file
@rem
@rem  Usage: every N videoFilename
@rem
@rem  Note: Requires mplayer.exe to be on your system path
@rem    https://sourceforge.net/projects/mplayerwin/

set inc=%1
set inp=%~f2
mkdir %inp%-extracted
cd %inp%-extracted
mplayer -vo png -vf framestep=%inc% %inp%
