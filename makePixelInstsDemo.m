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
y = [450 700];
x = [125:25:225];

for ii=1:length(x)
    
    name = ['vbar' num2str(x(ii))];
    tid = PIXMakeVBAR( x(ii), y(1), x(ii), y(2), zmsl, name);
    instID = [instID tid];
    
end

% runup
xshore = 125;
xdune  = 70;
y = 60:50:650;
rot = 0;

for ii=1:length(y)
    [xr, yr, zr] = runupPIXArray( xshore, xdune, y(ii), zmsl, rot );
    name = ['runup' num2str(fix(y(ii)))];
    tid = PIXCreateInstrument( name, 'runup', PIXFixedZ+PIXUniqueOnly );
    PIXAddPoints( tid, xr, yr, zr, name );
    instID = [instID tid];
end

% cBathy, 5 meter points
dx = 5;
dy = 5;
x1 = 80;
x2 = 400;
y1 = 450;
y2 = 900;

tid = PIXCreateInstrument( 'mBW', 'matrix', PIXFixedZ+PIXDeBayerStack );
PIXAddMatrix( tid, x1, y1, x2, y2, zmsl, dx, dy );
instID = [instID tid];

% stability slices
tid = PIXCreateInstrument( 'x300Slice', 'line', PIXFixedZ+PIXUniqueOnly );
PIXAddLine( tid, 300, 500, 300, 540, 7, .1, 'x300Slice' );
instID = [instID tid];
tid = PIXCreateInstrument( 'y517Slice', 'line', PIXFixedZ+PIXUniqueOnly );
PIXAddLine( tid, 100, 520, 115, 520, 7, .1, 'y517Slice' );
instID = [instID tid];


% make a package of all insts
pid = PIXCreatePackage('AerielleDemo', instID);
e = matlab2Epoch(now);

% build the initial r
r = PIXCreateR( pid, e, zmsl, 'uav' );

end

