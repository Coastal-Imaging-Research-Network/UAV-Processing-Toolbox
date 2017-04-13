function camExt = getExtrinsicParam(snapshotFn, epsgcode)

% Read exif from Snapshot (exiftool)
exifdata = getexif(snapshotFn);

% Get camera GPS coordinates
latString = extract_exifField(exifdata, 'GPSLatitude ');
lonString = extract_exifField(exifdata, 'GPSLongitude ');
altString = extract_exifField(exifdata, 'GPSAltitude ');

hemisphereSN = extract_exifField(exifdata, 'GPSLatitudeRef ');
hemisphereEW = extract_exifField(exifdata, 'GPSLongitudeRef ');

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
camPitch = str2double(extract_exifField(exifdata, 'CameraPitch '));
camRoll = str2double(extract_exifField(exifdata, 'CameraRoll '));
camYaw = str2double(extract_exifField(exifdata, 'CameraYaw '));
% Convert Pitch to Tilt
camTilt = 90 + camPitch;

camExt = struct('camX',camX,'camY',camY,'camZ',camZ,...
    'camPitch',camPitch,'camRoll',camRoll,'camYaw',camYaw,...
    'camTilt',camTilt);

end