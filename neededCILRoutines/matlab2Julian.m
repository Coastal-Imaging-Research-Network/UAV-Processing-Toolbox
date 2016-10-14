function julian = matlab2Julian(yyyy, mm, dd, hr, min, sec)

% Usage:
%
%  julian = matlab2Julian(yyyy, mm, dd, hr, min, sec)
%  or
%  julian = matlab2Julian(date_vec)
%  or
%  julian = matlab2Julian(datenum)
%  or
%  julian = matlab2Julian(datestring)
%
%	where date_vec is a 1x6 vector from the call datevec
%             datenum is a Matlab Datenum
%             datestring is a string understandable by datenum
%
%  Returns the Julian day for any human time.  
%
%  DANGER: WARNING: input times are assumed to be GMT.
%
%  WARNING: DANGER: If the year is less than 38, we assume 2000's, if
%   less than 100 1900's. Dissavow all decadence of the Y2K issue and
%   use four digit years! Show your disdain! 
%  

% convert input into a datenum
% if one input parameter, either datevec or datenum or string
if nargin == 1
	% look for a string
	if ischar(yyyy)
		in = datenum(yyyy);
	% this is a datevec
	elseif length(yyyy) == 6
		if yyyy(1) < 38
			yyyy(1) = yyyy(1) + 2000;
		elseif yyyy(1) < 100
			yyyy(1) = yyyy(1) + 1900;
		end
		in = datenum( yyyy(1), yyyy(2), yyyy(3), ...
			      yyyy(4), yyyy(5), yyyy(6) );
	% else it is a datenum
	elseif length(yyyy) == 1
		in = yyyy;
	else
		error('invalid datenum or datevec input')
	end
% look for abbreviated form "yy mm dd"
elseif nargin == 3
	if yyyy < 38
		yyyy = yyyy + 2000;
	elseif yyyy < 100
		yyyy = yyyy + 1900;
	end
	in = datenum(yyyy, mm, dd);
% now look for full yymmddhhmmss
elseif nargin == 6
	if yyyy < 38
		yyyy = yyyy + 2000;
	elseif yyyy < 100
		yyyy = yyyy + 1900;
	end
	in = datenum(yyyy, mm, dd, hr, min, sec);
else
	error( 'invalid input to function');
end

% get back a year from our input datenum
year = str2num(datestr(in,10));

% get the datenum for 1/1/year 0:0:0
epoch = datenum( year, 1, 1, 0, 0, 0 );

julian = fix(in - epoch) + 1;

%
% Copyright by Oregon State University, 2002
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: matlab2Julian.m 196 2016-06-02 20:47:36Z stanley $
%
% $Log: matlab2Julian.m,v $
% Revision 1.11  2004/03/25 16:55:39  stanley
% auto insert keywords
%
%
%key time 
%comment  Converts Matlab time to Julian day number 
%
