function [varargout] = convertRdCoordinates(x1,y1,varargin)
%% check if EPSG codes are given

if odd(length(varargin))
    EPSG = varargin{1};
    varargin(1)=[];
else
    EPSG = load('EPSG');
end

OPT.mode = 'rd2etrs89';

if nargin==0
    varargout = {OPT};
    return
end


[OPT, Set, Default] = setproperty(OPT, varargin{:});

switch OPT.mode
    case {'etrs2rd','etrs892rd'}
        [RDx,RDy,OPT2] = convertCoordinates(x1,y1,EPSG,...
            'CS1.name', 'ETRS89','CS1.type','geographic 2D','CS2.code',28992);
        [x_shift,y_shift] = rd_correction_shift(RDx,RDy);
        varargout{1} = RDx-x_shift;
        varargout{2} = RDy-y_shift;
    case {'rd2etrs89','rd2etrs'}
        [x_shift,y_shift] = rd_correction_shift(x1,y1);
        RDx = x1+x_shift;
        RDy = y1+y_shift;
        
        [varargout{1},varargout{2},OPT2] = convertCoordinates(RDx,RDy,EPSG,...
            'CS2.name', 'ETRS89','CS2.type','geographic 2D','CS1.code',28992);
        
end
varargout{3} = mergestructs(OPT,OPT2);
