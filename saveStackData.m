function saveStackData( inputs, info, stack )

% function saveStackData( inputs, info, stack )
%  uses the information from the stack struct ('r' and 'data')
%  to generate all the .mat files just like a regular Argus stack
%  in .mat format. inputs provides the pncx variable, info is the
%  struct with proto-filename data for argusFilename call.

% get all the unique names from stack.r

uname = unique( stack.r.cams(1).names );

% encoded UV for find.
UVencoded = stack.r.cams(1).U + stack.r.cams(1).V * 10000;

% one T for all data. but what is it? ASSUME -- starts at info.time and
% increments by 0.5 seconds. USER? 
T = 0:size(stack.data,1)-1; 
T = T .* 0.5;   %%% assumption!!!!
T = T + info.time;

for ii = 1:length(uname)
    
    % empty data
        XYZ = []; RAW = []; CAM = [];
        SHUTTER = []; CORRECTED = [];
        GAIN = [];
        WARNING = '';
        
        nind = strmatch( uname{ii}, stack.r.cams(1).names, 'exact' );
        
        XYZ = stack.r.cams(1).XYZ(nind,:);
        RAW = stack.data(:,nind);
        
        CAM = ones(length(nind),1) * stack.r.cams(1).cameraNumber;
        
        CORRECTED = RAW;
        
        info.type = uname{ii};
        name = uname{ii};
        fn = argusFilename(info);
        
        save( [inputs.pncx filesep fn], 'RAW', 'T', 'CAM', 'XYZ', 'GAIN', 'name', '-V7.3' );
        
end
        
        
        

