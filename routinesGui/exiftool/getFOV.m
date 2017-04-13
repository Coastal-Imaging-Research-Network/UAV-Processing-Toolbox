function [FOV] = getFOV(snapshotFn)

% Read exif from Snapshot (exiftool)
exifdata = getexif(snapshotFn);

% Extract FOV (field-of-view) from exif
FOVString = extract_exifField(exifdata, 'FOV');
[FOV, remain] = strtok(FOVString);
FOV = str2double(FOV);

end