function [s] = findField(exifdata, field)
%findField      finds the value of a field in the exif string
%
%   This function parses the exif string and returns the value of the
%   specified field as a string.
%   
%
%   Usage:  s=findField(exifdata,field)
%   
%           where:    s = value of the field (string)
%                     exifdata = string containing the exifdata
%                     field = string indicating the name of the field
%                     
%    KV WRL 04.2017                 
%         

idx = strfind(exifdata, field) + 33;
carriage_return = strfind( exifdata(idx:end), char(10)); % for PC
s = exifdata(idx : idx + carriage_return(1) - 2);

end