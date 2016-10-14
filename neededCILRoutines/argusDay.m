function day = argusDay(i)

%  argusDay -- create the argus "day" string
%
%   day = argusDay( I ) builds the day based on the
%   data found in I. I is either a double or string containing
%   the epoch time, or a struct with the field 'time'. 
%
%   The struct may contain other fields, which will be ignored.
%   A struct from parseFilename may be used as input to this
%   function.
%
%   Example: day = argusDay( 900000000 );
%            day = argusDay( '900000000' );
%            i.time = 900000000; day = argusDay( i );
%            day = '190_Jul.09';
%
%   $Id: argusDay.m 196 2016-06-02 20:47:36Z stanley $ 
%   $Log: argusDay.m,v $
%   Revision 1.12  2004/03/25 16:55:23  stanley
%   auto insert keywords
%

if isstruct(i)
	if ischar(i.time)
		when = str2num(i.time);
	else
		when = i.time;
	end
elseif ischar( i ) 
	when = str2num(i);
else
	when = i;
end

% oh bummer, cannot use ctime, ctime thinks in TZ
%timestr = ctime(i.time);
d = datevec(epoch2Matlab(when));
dmon = datestr(epoch2Matlab(when), 3);
jul = matlab2Julian( d );

day = sprintf('%03d_%s.%02d', jul, dmon, d(3) ); 
%
% Copyright by Oregon State University, 2002
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: argusDay.m 196 2016-06-02 20:47:36Z stanley $
%
% $Log: argusDay.m,v $
% Revision 1.12  2004/03/25 16:55:23  stanley
% auto insert keywords
%
%
%key time 
%comment  Creates the julian day argus directory name  
%
