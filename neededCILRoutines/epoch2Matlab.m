function dnum = epoch2Matlab( epoch )

% Usage:
%
%    dnum = epoch2Matlab( epoch )
%
%   convert a UNIX epoch time as used in the Argus system into a Matlab
%   datenum. You can convert the datenum to whatever you want.
%
%   WARNING: DANGER: UNIX epoch times are all GMT based, and the datenum
%   returned from this routine is GMT. 
%

% get reference time
unixEpoch = datenum( 1970, 1, 1, 0, 0, 0 );

% how much later than reference time is input?
offset = double(epoch) / (24*3600);

% add and return
dnum = unixEpoch + offset;

%
% Copyright by Oregon State University, 2002
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: epoch2Matlab.m 6 2016-02-11 00:46:00Z  $
%
% $Log: epoch2Matlab.m,v $
% Revision 1.12  2006/04/28 19:50:59  stanley
% changed datenum, doubled epoch.
%
% Revision 1.11  2004/03/25 16:55:25  stanley
% auto insert keywords
%
%
%key time 
%comment  Converts epoch time to Matlab datenum 
%
