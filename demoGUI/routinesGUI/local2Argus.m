function [xyzArg] = local2Argus(xyzLocal, argusOrigin, argusRotation)
%local2Argus      converts local coordinates to Argus coordinates
%
%   This function converts local coordinates into argus coordinates. Argus
%   coordinates are defined as cross-shore/long-shore (x/y). To perform
%   this conversion, the argus origin in local coordinates and the rotation
%   angle are required. The local coordinate system has to be a map
%   projection (Eastings/Northings).
%   
%
%   Usage:  xyzArgus=local2Argus(xyzLocal,argusOrigin,argusRotation)
%   
%           where:    xyzArg = [x y z]    (in argus coords)
%                     xyzLocal = [x y z]    (in local coords)
%                     argusOrigin = [x y z] (argus origin in local coords)
%                     argusRotation = rot   (rotation angle to get from
%                     argus east to local east, positive couter-clockwise
%                     in degrees)
%
%    KV WRL 04.2017                 
%   
    
    % Rotation angle to get from local east to argus east, positive counter-clockwise
    phi = deg2rad(-argusRotation);
    
    % Rotation matrix
    rotM = [cos(phi) sin(phi); -sin(phi) cos(phi)];
    
    % First translate origin
    coordTR = xyzLocal(:, [1 2]) - [argusOrigin(1) argusOrigin(2)];
    
    % Then rotate all points
    xyzArg = [(rotM*coordTR')' xyzLocal(:, 3) - argusOrigin(3)];
        
    end

