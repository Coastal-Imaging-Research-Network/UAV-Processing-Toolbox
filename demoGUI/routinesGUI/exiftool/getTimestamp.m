function [t GMT] = getTimestamp(snapshotFn)
%getTimestamp      returns the date and time in which the snapshot was taken
%
%   This function parses the exif string and returns the date and time in which the
%   snapshot was taken as a datevec and also the GMT for that time.
%   
%   
%   Usage:  [t GMT] = getTimestamp(snapshotFn)
%   
%           where:    t = datevec containing the date and time
%                     GMT = int containing the GMT 
%                     snapshotFn = string containing the pathname and
%                     filename of the snapshot
%
%    KV WRL 04.2017  
%

% Read exif from Snapshot (exiftool)
exifdata = getexif(snapshotFn);

% Extract date + time from DateTimeOriginal
timeString = findField(exifdata, 'DateTimeOriginal');
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

% Get GMT from FileModifyDate
timeString = findField(exifdata, 'FileModifyDate');
[year remain] = strtok(timeString, ':');
temp(1) = str2double(year);
[month remain] = strtok(remain, ':');
temp(2) = str2double(month);
[day remain] = strtok(remain, ':');
temp(3) = str2double(day(1:2));
[day hours] = strtok(day);
temp(4) = str2double(hours);
[minutes remain] = strtok(remain, ':');
temp(5) = str2double(minutes);
[seconds remain] = strtok(remain, ':');
temp(6) = str2double(seconds(1:2));
GMT = seconds(3:end);

end