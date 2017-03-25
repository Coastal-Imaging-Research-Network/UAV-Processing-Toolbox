function yesno = inImage( U, V, Ulimit, Vlimit, flag );

% usage: yesno = inImage( U, V, Ulimit, Vlimit, flag );
%    or: yesno = inImage( U, V, Ip, flag );
%
%  Determine if a requested UV pixel location is inside the image
%  boudary. The image size is contained either in Ulimit, Vlimit,
%  which are scalars, or in Ip, which is an IP struct as used in
%  Geomtool. 
%
%  U and V must be arrays of the same size. Yesno will be an array of
%  the same size as U and V. A one means the corresponding UV is in
%  the image.
%
%  If the optional flag value contains the string 'full', the image
%  limits are applied literally. Otherwise, the image is assumed to be
%  a typical Argus image where the top and bottom ten lines contain
%  text info and are not considered in the image.
%
%  If the only parameters passed are U and V, the image is assumed
%  to be 640x480 and the top and bottom ten lines are outside the image.
%

% error
if ((nargin < 2) | (nargin > 5))
	error('invalid call to inImage, get help!');
end

% another error
if ~all(size(U) == size(V))
	error('U and V not same size');
end

% first, test for two input case, assume Ulimit, Vlimit and flag
if nargin == 2
	Ulimit = 640;
	Vlimit = 480;
	myflag = '';
% for three inputs, allow only U, V, and IP struct
elseif (nargin == 3)
	if isstruct(Ulimit)
		Vlimit = Ulimit.height;
		Ulimit = Ulimit.width;
		myflag = '';
	else
		error('Three argument call to inImage needs IP struct');
	end
% four inputs means either no flag or ip struct
elseif (nargin == 4)
	% flag is there, must be IP previous
	if ischar(Vlimit)
		if isstruct(Ulimit)
			myflag = Vlimit;
			Vlimit = Ulimit.height;
			Ulimit = Ulimit.width;
		else
			error('Call to inImage needs IP struct or UVlimits');
		end
	else
		myflag = '';
	end
elseif nargin == 5
	myflag = flag;
end

% done with input, make output.
Uhigh = ones(size(U))*Ulimit;
Ulow = ones(size(U));
Vhigh = ones(size(V))*Vlimit;
Vlow = ones(size(U));

if (ischar(myflag))
	if (strmatch('full',myflag,'exact'))
	elseif isempty(myflag)
		Vlow = Vlow + 10;
		Vhigh = Vhigh - 10;
	else
		error(['unknown flag: ' myflag]);
	end
end

yes = find( (U >= Ulow) & (U <= Uhigh) & (V >= Vlow) & (V <= Vhigh));
yesno = zeros(size(U));
yesno(yes) = ones(size(yes));


%
%   Copyright (C) 2017  Coastal Imaging Research Network
%                       and Oregon State University

%    This program is free software: you can redistribute it and/or  
%    modify it under the terms of the GNU General Public License as 
%    published by the Free Software Foundation, version 3 of the 
%    License.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see
%                                <http://www.gnu.org/licenses/>.

% CIRN: https://coastal-imaging-research-network.github.io/
% CIL:  http://cil-www.coas.oregonstate.edu
%
%key UAVProcessingToolbox
%

