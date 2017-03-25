function time = epochtime(offset);

% usage: time = epochtime( offset );
%
%  returns a double containing the current UNIX epochtime as used in
%  the argus file names.
%  'offset' is an optional offset in minutes from GMT. For example, Pacific
%  Daylight Time is -480. 
%
%  NOTE: if you do not have an offset, then you will get an epoch time
%  based on PACIFIC STANDARD time -- not correct.
%

%  this is a mex file on UNIX. the OS keeps track of this for us. We
%  have to kludge for Windows. We get the "clock" time and measure time
%  from 1 jan 70.

if nargin==0
    offset = -480;
    if( exist('argusOpt') == 2)
        offset = argusOpt('timeoffset');
    end
end

here = now;
then = datenum('1-jan-1970 0:0:0');

time = (here-then)*86400 - (offset * 60);

