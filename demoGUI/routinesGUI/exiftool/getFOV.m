function FOV = getFOV(snapshotFn)
%getFOV      returns the value of the FOV extracted from a snapshot
%
%   This function parses the exif string and returns the value of the
%   Field-of-View (FOV) of the camera.
%   
%
%   Usage:  FOV = getFOV(snapshotFn)
%   
%           where:    FOV = double containing the value of the field of
%                     view in degrees
%                     snapshotFn = string containing the pathname and
%                     filename of the snapshot
%
%    KV WRL 04.2017                 
%    

% Read exif from Snapshot (exiftool)
exifdata = getexif(snapshotFn);

% Extract FOV (field-of-view) from exif
FOVString = findField(exifdata, 'FOV');
[FOV, remain] = strtok(FOVString);
FOV = str2double(FOV);

end