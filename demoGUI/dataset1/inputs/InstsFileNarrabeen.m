function r = makePixelInstsDemo( )

% Make pixel instruments using pixel toolbox. duplicate of demoInstsFile.

% start by forgetting everything you know
PIXForget;
% and set the station name
PIXSetStation('aerielle');

% sea level
zmsl = 0;

instID = [];

% vbar insts, two y transects 
y = [-100  300];
x = [50 100];
for ii=1:length(x)
    
    name = ['vbar' num2str(x(ii))];
    tid = PIXMakeVBAR( x(ii), y(1), x(ii), y(2), zmsl, name);
    instID = [instID tid];
    
end

% runup
% note: normally for a runup line you want to keep a fixed X and Y.
% This requires knowing the Z for each point on the line. For a fixed
% station you may have done the survey transects or have other information
% that allows you to know that. For a UAV operation, you probably do not,
% Thus this is the "no Z" call.

xshore = 150;
xdune  = 20;
y = [0 100];
rot = 20;

for ii=1:length(y)
    [xr, yr, zr] = runupPIXArray( xshore, xdune, y(ii), zmsl, rot );
    name = ['runup' num2str(fix(y(ii)))];
    tid = PIXCreateInstrument( name, 'runup', PIXFixedZ+PIXUniqueOnly );
    PIXAddPoints( tid, xr, yr, zr, name );
    instID = [instID tid];
end

% cBathy, 5 meter points
dx = 5;
dy = 10;
x1 = -40;
x2 = 600;
y1 = -100;
y2 = 1000;

tid = PIXCreateInstrument( 'mBW', 'matrix', PIXFixedZ+PIXDeBayerStack );
PIXAddMatrix( tid, x1, y1, x2, y2, zmsl, dx, dy );
instID = [instID tid];

% make a package of all insts
pid = PIXCreatePackage('AerielleDemo', instID);
e = matlab2Epoch(now);

% build the initial r
r = PIXCreateR( pid, e, zmsl, 'uav' );

end

