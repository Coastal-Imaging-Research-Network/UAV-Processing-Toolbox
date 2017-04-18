function [t GMT] = getTimestamp(snapshotFn)

% Read exif from Snapshot (exiftool)
exifdata = getexif(snapshotFn);

% Extract date + time + GMT at which file was modified
timeString = findField(exifdata, 'FileModifyDate');
[year remain] = strtok(timeString, ':');
t(1) = str2double(year);
[month remain] = strtok(remain, ':');
t(2) = str2double(month);
[day remain] = strtok(remain, ':');
t(3) = str2double(day(1:2));
[day hours] = strtok(day);
t(4) = str2double(hours);
[minutes remain] = strtok(remain, ':');
t(5) = str2double(minutes);
[seconds remain] = strtok(remain, ':');
t(6) = str2double(seconds(1:2));

GMT = seconds(3:end);

end