function varargout=landboundary_da(cmd,varargin),
% LANDBOUNDARY File operations for land boundaries
%
%     XY=LANDBOUNDARY('read',FileName)
%     [X,Y]=LANDBOUNDARY('read',FileName)
%        Reads the specified file.
%
%     LANDBOUNDARY('write',FileName,XY)
%     LANDBOUNDARY('write',FileName,X,Y)
%        Writes a the landboundary to file. X,Y should either
%        contain NaN separated line segments or X,Y cell arrays
%        containing the line segments.
%     LANDBOUNDARY(...,'-1')
%        Doesn't write line segments of length 1.
%     LANDBOUNDARY(...,'dosplit')
%        Saves line segments as separate TEKAL blocks instead
%        of saving them as one long line interrupted by missing
%        values. This approach is suited for spline files.
%     FIS=LANDBOUNDARY('write',...)
%        Returns a file info structure for reading with TEKAL.

% (c) Copyright Delft Hydraulics, 1999.
%     Created by H.R.A. Jagers, University of Twente / Delft Hydraulics.

if nargout>0,
   varargout=cell(1,nargout);
end;
if nargin==0,
   return;
end;
switch cmd,
   case 'read',
      Out=Local_read_file(varargin{:});
      if nargout==1,
         varargout{1}=Out;
      elseif nargout>1,
         varargout{1}=Out(:,1);
         varargout{2}=Out(:,2);
      end;
   case 'write',
      Out=Local_write_file(varargin{:});
      if nargout>0,
         varargout{1}=Out;
      end;
   otherwise,
      uiwait(msgbox('unknown command','modal'));
end;


function Data=Local_read_file(filename);
Data=[];
if nargin==0,
   [fn,fp]=uigetfile('*.ldb');
   if ~ischar(fn),
      return;
   end;
   filename=[fp fn];
end;

T=tekal('open',filename);

lasterr('')
try
   Sz=cat(1,T.Field.Size);
   if ~all(Sz(:,2)==Sz(1,2))
      error('The number of columns in the files is not constant.')
   end
   Sz=[sum(Sz(:,1))+size(Sz,1)-1 Sz(1,2)];
   offset=0;
   Data=repmat(NaN,Sz);
   for i=1:length(T.Field)
      Data(offset+(1:T.Field(i).Size(1)),:)=tekal('read',T,i);
      offset=offset+T.Field(i).Size(1)+1;
   end
   Data((Data(:,1)==999.999)&(Data(:,2)==999.999),:)=NaN; % 
catch
   fprintf(1,'ERROR: Error extracting landboundary from tekal file:\n%s\n',lasterr);
end


function TklFileInfo=Local_write_file(filename,varargin);

if nargin==1,
   Data=filename;
   [fn,fp]=uiputfile('*.*');
   if ~ischar(fn),
      TklFileInfo=[];
      return;
   end;
   filename=[fp fn];
end;

j=0;
RemoveLengthOne=0;
XYSep=0;
DoSplit=0;
for i=1:nargin-1
   if ischar(varargin{i}) & strcmp(varargin{i},'-1')
      RemoveLengthOne=1;
   elseif ischar(varargin{i}) & strcmp(lower(varargin{i}),'dosplit')
      DoSplit=1;
   elseif (isnumeric(varargin{i}) | iscell(varargin{i})) & j==0
      Data1=varargin{i};
      j=j+1;
   elseif (isnumeric(varargin{i}) | iscell(varargin{i})) & j==1
      Data2=varargin{i};
      XYSep=1; % x and y supplied separately?
   else
      error(sprintf('Invalid input argument %i',i+2))
   end
end

if ~iscell(Data1) % convert to column vectors
   if XYSep
      Data1=Data1(:);
      Data2=Data2(:);
   else
      if size(Data1,2)~=2 % [x;y] supplied
         Data1=transpose(Data1);
      end
   end
end

if iscell(Data1),
   j=0;
   for i=1:length(Data1),
      if XYSep
         Length=length(Data1{i}(:));
      else
         if size(Data1{i},2)~=2
            Data1{i}=transpose(Data1{i});
         end  
         Length=size(Data1{i},1);
      end
      if ~(isempty(Data1{i}) | (RemoveLengthOne & Length==1)), % remove lines of length 0 (and optionally 1)
         j=j+1;
         T.Field(j).Name = sprintf('%4i',j);
         T.Field(j).Size = [Length 2];
         if XYSep
            T.Field(j).Data = [Data1{i}(:) Data2{i}(:)];
         else
            T.Field(j).Data = Data1{i};
         end
      end;
   end;
else,
   I=[0; find(isnan(Data1(:,1))); size(Data1,1)+1];
   if ~DoSplit
      I=[0;size(Data1,1)+1];
      Data1(isnan(Data1))=999.999;
      if XYSep
         Data2(isnan(Data2))=999.999;
      end
   end
   j=0;
   for i=1:(length(I)-1),
      if I(i+1)>(I(i)+1+RemoveLengthOne), % remove lines of length 0  (and optionally 1)
         j=j+1;
         T.Field(j).Name = sprintf('%4i',j);
         T.Field(j).Size = [I(i+1)-I(i)-1 2];
         if XYSep
            T.Field(j).Data = [Data1((I(i)+1):(I(i+1)-1)) Data2((I(i)+1):(I(i+1)-1))];
         else
            T.Field(j).Data = Data1((I(i)+1):(I(i+1)-1),:);
         end
      end;
   end;
end;

TklFileInfo=tekal('write',filename,T);
