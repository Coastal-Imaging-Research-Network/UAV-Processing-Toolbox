function yesNo = onScreen(U, V, Umax, Vmax)

% Usage:
%
%  yesNo = onScreen(U, V, UMax, VMax)
%
%  determines if pixel coordinates are located in an image.
%	U - column list of U pixel coords
%	V - column list of V pixel coords, same length
%       UMax,VMax - optional U and V max for image. If not present,
%	      assumes 640 by 480
%       yesNo - vector of logical true where pixel is on screen
%
%  if you do not provide Umax/Vmax, onScreen will leave a 10 pixel
%  border at the top and bottom of the image to avoid Argus text labels
%

if nargin == 2
	Umin = 1;
	Umax = 640;
	% leave a gap for labels at top and bottom of argus images.
	Vmin = 10;	
	Vmax = 470;
else
	Umin = 1;
	Vmin = 1;
end

%  make sure U V are columns of the same length
[n,m] = size(U);
if m > n
	U = U';
end

[n,m] = size(V);
if m > n
	V = V';
end

if (size(U,1) ~= size(V,1))
	error('U and V vectors not the same length')
	return
end

% start with NO
yesNo = zeros(size(U,1),1);

% find where is YES
on = find((U>=Umin) & (U<=Umax) & (V>=Vmin) & (V<=Vmax));

% and return a vector
yesNo(on) = ones(size(on));

%
% Copyright by Oregon State University, 2002
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: onScreen.m 196 2016-06-02 20:47:36Z stanley $
%
% $Log: onScreen.m,v $
% Revision 1.12  2004/03/25 16:55:40  stanley
% auto insert keywords
%
%
%key quality 
%comment  Tests UV coordinates for being in the image 
%
