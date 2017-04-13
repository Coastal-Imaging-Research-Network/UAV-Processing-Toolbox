function D = NTv2_read(fname,varargin)
%NTV2_READ load ascii datafile from Canadian NTv2
%
%  D = NTv2_read(fname)
%
% loads a datafile in the ASCII (*.gsa) or 
% binary (*.gsb) file format of the Canadian 
% "National Transformation version 2" system.
% http://www.geod.nrcan.gc.ca/tools-outils/ntv2_e.php
% http://www.geod.nrcan.gc.ca/pdf/ntv2_guide_e.pdf
%
% The NTv2 National Transformation software can transform 
% coordinates (geographic, UTM or MTM) from one spatial 
% reference system to another using a binary Grid Shift File.
%
% NTv2 is used and available for multiple countries: 
% Australia, Brazil, Canada, France, 
% Germany, Great Brittain, New Zealand:
% http://www.eye4software.com/resources/ntv2/
%
%See also: convertcoordinates

% NUM_OREC 11
% NUM_SREC 11
% NUM_FILE  1
% GS_TYPE SECONDS 
% VERSION NTv2.0  
% SYSTEM_FDHDN90  
% SYSTEM_TETRS89  
% MAJOR_F  6377397.155
% MINOR_F  6356078.963
% MAJOR_T  6378137.000
% MINOR_T  6356752.314
% SUB_NAMEDHDN90  
% PARENT  NONE    
% CREATED 06-11-09
% UPDATED 06-11-09
% S_LAT     169200.000000
% N_LAT     199080.000000
% E_LONG    -56400.000000
% W_LONG    -19800.000000
% LAT_INC      360.000000
% LONG_INC     600.000000
% GS_COUNT  5208
%  -2.749746  7.165792  0.000000  0.000000
% ...
% -6.345754  2.126569  0.000000  0.000000
%END             

OPT.plot   = 0;
OPT.title  = {};

OPT = setproperty(OPT,varargin);

ext = fileext(fname);

if strcmp(ext,'.gsa') 
% ASCII version
   fid = fopen(fname,'r');
   typ = [0 0 0  1 1 1 1  0 0 0 0  1 1 1 1  0 0 0 0 0 0 0];
   for i=1:22
      rec = fgetl(fid);[name,val] = strtok2(rec,typ(i));D.(name) = val;
   end
   raw = fscanf(fid,'%g',[4 D.GS_COUNT]);
   rec = fgetl(fid);
   rec = fgetl(fid);
   fclose(fid);
   
elseif strcmp(ext,'.gsb')
% binary version

   fid = fopen(fname,'r');
   
  [name,val] = gsb_integer(fid);D.(name) = val;
  [name,val] = gsb_integer(fid);D.(name) = val;
  [name,val] = gsb_integer(fid);D.(name) = val;

  [name,val] = gsb_string (fid);D.(name) = val;
  [name,val] = gsb_string (fid);D.(name) = val;
  [name,val] = gsb_string (fid);D.(name) = val;
  [name,val] = gsb_string (fid);D.(name) = val;

  [name,val] = gsb_double (fid);D.(name) = val;
  [name,val] = gsb_double (fid);D.(name) = val;
  [name,val] = gsb_double (fid);D.(name) = val;
  [name,val] = gsb_double (fid);D.(name) = val;

  [name,val] = gsb_string (fid);D.(name) = val;
  [name,val] = gsb_string (fid);D.(name) = val;
  [name,val] = gsb_string (fid);D.(name) = val;
  [name,val] = gsb_string (fid);D.(name) = val;

  [name,val] = gsb_double (fid);D.(name) = val;
  [name,val] = gsb_double (fid);D.(name) = val;
  [name,val] = gsb_double (fid);D.(name) = val;
  [name,val] = gsb_double (fid);D.(name) = val;
  [name,val] = gsb_double (fid);D.(name) = val;
  [name,val] = gsb_double (fid);D.(name) = val;
   
  [name,val] = gsb_integer(fid);D.(name) = val;
  
  [raw]      = fread(fid,[4 D.GS_COUNT],'float');
 
  [rec,val]  = gsb_string (fid);

  fclose(fid);
   
end
   
if ~strcmpi(strtrim(rec),'end')
  error(['expected ''END'' but got ',rec])
end

D.lon    = raw(1,:);
D.lat    = raw(2,:);
D.dlon   = raw(3,:);
D.dlat   = raw(4,:);

D.nrow   = floor ((D.W_LONG - D.E_LONG) / D.LONG_INC + 0.5) + 1;
D.ncol   = floor (( D.N_LAT - D.S_LAT ) / D.LAT_INC  + 0.5) + 1;

D.lon    = reshape(D.lon ,[D.nrow D.ncol]);
D.lat    = reshape(D.lat ,[D.nrow D.ncol]);
D.dlon   = reshape(D.dlon,[D.nrow D.ncol]);
D.dlat   = reshape(D.dlat,[D.nrow D.ncol]);

if OPT.plot
%%
   TMP = figure;
   pcolorcorcen(-D.lon,D.lat,D.dlon,[.5 .5 .5])
   title({mktex(filenameext(fname)),OPT.title})
   hold on
   axislat
   grid on
   tickmap('ll')
   colorbarwithvtext('|dlon|')
   %L = nc2struct('gshhs_c.nc');
   %plot(L.lon,L.lat,'k')
   pausedisp
   try
   close(TMP)
   end

end

% Typ      Byte   Bemerkung
% --------+------+---------
% Integer | 4    | In der binär Version durch 4 NULL-Bytes auf 8 Byte aufgefüllt
% Float   | 4    | IEEE 754
% Double  | 8    | IEEE 754
% String  | 8    | 8 Zeichen, kürzere Zeichenketten werden durch Blanks aufgefüllt
% --------+------+---------

function [name,val] = gsb_integer(fid)
   name = char(fread(fid, 8,'char')');
   name = strtrim(name);
   val  =      fread(fid, 8,'ubit4');
   val  = sum(val(1:4)'.*16.^[0:3]);
   tmp  =      fread(fid, 8,'ubit4');

function [name,val] = gsb_string(fid)
   name = char(fread(fid, 8,'char')');
   name = strtrim(name);
   val  = char(fread(fid, 8,'char')');
   val  = strtrim(val );

function [name,val] = gsb_double(fid)
   name = char(fread(fid, 8,'char')');
   name = strtrim(name);
   val  =      fread(fid, 1,'double');

function [name,val] = strtok2(rec,typ)

   name = strtrim(rec(1:8  ));
   val  = strtrim(rec(9:end));
   
   if typ==0
      num = str2num(val);
      if ~isempty(num)
         val = num;
      end
   end
   