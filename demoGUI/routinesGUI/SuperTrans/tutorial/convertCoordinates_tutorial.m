%% Coordinate conversion
% this tutorial deals with coordinate conversion, using the OpenEarthTools
% function convertCoordinates

%% Example of application
% We need to tell convertCoordinates what the input coordinate system is,
% and what the output coordinate system is (CS1 and CS2). We can do so by
% entering the name, type and /or EPSG reference code using keyword value
% pairs. An example below:

x = 165e3;
y = 420e3;
[lon,lat] = convertCoordinates(x,y,'CS1.name','Amersfoort / RD New',...
    'CS2.code',4326)

%%
% CS1.name refers to the name of Coordinate System 1. Coordinate System 2
% is identified by a code: 4326. Alternatively, also the name (WGS 84) of
% the second coordinate system can be entered:
try
[lon,lat] = convertCoordinates(x,y,'CS1.name','Amersfoort / RD New',...
    'CS2.name','WGS 84');
catch
    err = lasterror;
    disp(err.message)
end
%%
% Because the name 'WGS 84' does not refer to a unique coordinate system,
% an error message is returned. From the message we can see that there are
% three systems known by that name. we want to convert coordinates to
% geographic 2D. If we also specify the type, this leads to a unique
% coordinate system. 

[lon,lat] = convertCoordinates(x,y,'CS1.name','Amersfoort / RD New',...
    'CS2.name','WGS 84','CS2.type','Geographic 2D')

%% Finding the name or code of a coordinate system
% If convertCoordinates cannot find an exact match for the coordinate system
% name, it returns an error message with approximate matches. This is
% useful if you do not know the exact code or name of a coordinate system.
% Make sure to enter a name that does not match any entry, as for instance
% 'amersfoo'.

try
[lon,lat] = convertCoordinates(x,y,'CS1.name','amersfoo',...
    'CS2.code',4326)
catch
    err = lasterror;
    disp(err.message)
end
%%
% Apparently there are five coordinate systems who's name contains
% 'amersfoo'. Amersfoort / RD New has the code 28992. 

[lon,lat] = convertCoordinates(x,y,'CS1.code',28992,'CS2.code',4326)

%% Speeding up the routine in batch mode
% The slowest part of the routine is reading the EPSG database. If the
% routine is called several times in a batch mode, it is faste to load the
% data only once, and the pass it to the function. Compare the following
% options.

% without preloading EPSG
tic 
for ii = 1:10
    [lon,lat] = convertCoordinates(x,y,'CS1.code',28992,'CS2.code',4326);
end
toc

%%

% with preloading EPSG
tic 
EPSG = load('EPSG');
for ii = 1:10
    [lon,lat] = convertCoordinates(x,y,EPSG,'CS1.code',28992,'CS2.code',4326);
end
toc

%% Evaluating the output
% To evaluate the output, call the funtion with OPT:

[lon,lat,OPT] = convertCoordinates(x,y,EPSG,'CS1.code',28992,'CS2.code',4326);
disp(OPT);

%%
% From the OPT structure, all relevant parameters and conversion options can
% be retrieved. This can be done with the Array editor, or (easier), by
% using the OET function var2evalstr.

var2evalstr(OPT)

%%
% The contents of the OPT structure depends on the conversions 
% and transformations performed. Consider this example (of a very unlikely
% coordinate conversion)

[x,y,OPT] = convertCoordinates(1,1,EPSG,...
    'CS1.name','IRENET95 / Irish Transverse Mercator',...
    'CS2.name','NAD27 / Alberta 3TM ref merid 111 W');
disp(OPT)

%%
% * CS1 identifies the input coordinate system
% * Proj_conv1 contains the transformation parameters from Cartesian
% coordinate system 1 to a geodetic (lat/lon) system
% * Apparently no direct transformation is available from the GRS 1980
% ellipsoid of coordinate system 1 ('OPT.CS1.ellips.name') to that of CS2
% (Clarke 1866). Therefore the coordinates are first transformed from the
% GRS 1980 to the WGS 84 ellipsoid, and only then to Clarke 1866
% * Finally the coordinates are converted to the NAD27 coordinate reference
% system

%% Multiple conversion options
% For some coordinate conversions, more than one routine is available. And
% example is the RD to WGS 84 conversion. We can evaluate the available
% methods from the OPT structure.
[lon1,lat1,OPT] = convertCoordinates(1e5,5e5,EPSG,'CS1.code',28992,'CS2.code',4326);
var2evalstr(OPT.datum_trans)

%%
% By default convertCoordinates chooses the newest non-deprecated method.
% (It is assumed that the method with the highest code is the newest).
% This can be overridden by defining a datum_trans.code:

[lon2,lat2,OPT] = convertCoordinates(1e5,5e5,EPSG,'CS1.code',28992,'CS2.code',4326,...
    'datum_trans.code',1672);
lat1-lat2
