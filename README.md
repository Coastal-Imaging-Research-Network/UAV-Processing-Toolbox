# UAV-Processing-Codes
Codes, documentation and discussion for the use of small drones for Argus-like sampling.

This repository is intended as a home for the exchange of ideas and code for the exploitation of video data from small drones for doing Argus-like data analysis (or any analysis). The initial repository was developed as a systematic way of dealing with image data from a Phantom III Professional collected during the 2015 bathyDuck field experiment. The experiment, as well as all of the developed methods are described in a (draft) publication and a UAV processing readme document, both contained in the wiki part of this repository.

The primary issue in UAV data exploitation is stabilization and geolocation of collected imagery. This depends on the degree of wander and jitter in the camera location and pointing angles, things that are quite (but not completely) stable in the Phantom. The paper and code suggest one reasonable way to solve these image geometry problems for the usual cases where there is very limited ground control.

Suggestions of improvements are welcome. This toolbox has not yet been tested by other users, so I am sure we will find bugs and local assumptions. Please send suggestions to Rob Holman (holman@coas.oregonstate.edu).
