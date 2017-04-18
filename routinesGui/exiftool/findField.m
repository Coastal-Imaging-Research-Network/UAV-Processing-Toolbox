function [s] = findField(exifdata, field)

idx = strfind(exifdata, field) + 33;
carriage_return = strfind( exifdata(idx:end), char(10)); % for PC
s = exifdata(idx : idx + carriage_return(1) - 2);

end