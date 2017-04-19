function camExt = getExtrinsicParam(snapshotFn, epsgcode)
%getExtrinsicParam      returns the extrinsic camera parameters
%
%
%   This function reads the exif of a snapshot, parses the fields
%   corresponding to the camera extrinsic parameters (X,Y,Z,Roll,Pitch,Yaw)
%   Note that it converts the coordinates into the coordinate system
%   indicated by the input EPSG code using the SuperTrans library.
%   
%   
%
%   Usage:  camExt = getExtrinsicParam(snapshotFn, epsgcode)
%   
%           where:    camExt is a structure containing 6 fields (X,Y,Z,
%                     Roll,Pitch,Yaw)
%                     snapshotFn = string containing the pathname and
%                     filename of the snapshot
%                     epsgcode = integer containing the EPSG code of the
%                     local coordinate system
%                     
%    KV WRL 04.2017                 
%  

% Read exif from Snapshot (exiftool)
exifdata = getexif(snapshotFn);

% Get camera GPS coordinates
latString = findField(exifdata, 'GPSLatitude ');
lonString = findField(exifdata, 'GPSLongitude ');
altString = findField(exifdata, 'GPSAltitude ');

hemisphereSN = findField(exifdata, 'GPSLatitudeRef ');
hemisphereEW = findField(exifdata, 'GPSLongitudeRef ');

[latDeg remain] = strtok(latString);
latDeg = str2double(latDeg);
[tmp remain] = strtok(remain);
[latMin remain] = strtok(remain);
latMin = str2double(strrep(latMin,'''',''));
[latSec remain] = strtok(remain);
latSec = str2double(strrep(latSec,'"',''));

latitude = dms2degrees([latDeg latMin latSec]);
if strcmp(hemisphereSN, ' South')
    latitude = -latitude;
end

[lonDeg remain] = strtok(lonString);
lonDeg = str2double(lonDeg);
[tmp remain] = strtok(remain);
[lonMin remain] = strtok(remain);
lonMin = str2double(strrep(lonMin,'''',''));
[lonSec remain] = strtok(remain);
lonSec = str2double(strrep(lonSec,'"',''));

longitude = dms2degrees([lonDeg lonMin lonSec]);
if strcmp(hemisphereEW, ' West')
    longitude = -longitude;
end

% Convert lat/lon to coordsys defined by epsgcode
latlongepsg = 4326;
xyepsg = epsgcode;
[camX, camY, ~] = convertCoordinates(longitude, latitude,'CS1.code', latlongepsg, 'CS2.code', xyepsg);

% Get altitude above sea level
[camZ remain] = strtok(altString);
camZ = str2double(camZ);

% Get camera attitude
camPitch = str2double(findField(exifdata, 'CameraPitch '));
camRoll = str2double(findField(exifdata, 'CameraRoll '));
camYaw = str2double(findField(exifdata, 'CameraYaw '));
% Convert Pitch to Tilt
camTilt = 90 + camPitch;

camExt = struct('camX',camX,'camY',camY,'camZ',camZ,...
    'camPitch',camPitch,'camRoll',camRoll,'camYaw',camYaw,...
    'camTilt',camTilt);

end