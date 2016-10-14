function R = angles2R(a,t,s)

% R = angles2R(a,t,s)
% Makes rotation matrix from input azimuth, tilt, and swing (roll)
% From p 612 of Wolf, 1983
%

R(1,1) = cos(a) * cos(s) + sin(a) * cos(t) * sin(s);
R(1,2) = -cos(s) * sin(a) + sin(s) * cos(t) * cos(a);
R(1,3) = sin(s) * sin(t);
R(2,1) = -sin(s) * cos(a) + cos(s) * cos(t) * sin(a);
R(2,2) = sin(s) * sin(a) + cos(s) * cos(t) * cos(a);
R(2,3) = cos(s) * sin(t);
R(3,1) = sin(t) * sin(a);
R(3,2) = sin(t) * cos(a);
R(3,3) = -cos(t);

%
% Copyright by Oregon State University, 2002
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: angles2R.m 196 2016-06-02 20:47:36Z stanley $
%
% $Log: angles2R.m,v $
% Revision 1.1  2004/08/18 20:16:42  stanley
% Initial revision
%
%
%key geometry 
%comment  Makes rotation matrix from angles 
%
