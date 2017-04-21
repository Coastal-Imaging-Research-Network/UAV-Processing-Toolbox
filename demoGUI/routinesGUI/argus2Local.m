function [xyzLocal] = argus2Local(xyzArg, argusOrigin, argusRotation)
%local2Argus      converts Argus coordinates into local coordinates
%                 
%                 
%   This function converts argus coordinates into local coordinates. Argus
%   coordinates are defined as cross-shore/long-shore (x/y). To perform
%   this conversion, the argus origin in local coordinates and the rotation
%   angle are required. The local coordinate system has to be a map
%   projection (Eastings/Northings).
%   
%
%   Usage:  xyzLocal=argus2Local(xyzArg,argusOrigin,argusRotation)
%   
%           where:    xyzLocal = [x y z]    (in local coords)
%                     xyzArg = [x y z]      (in argus coords)
%                     argusOrigin = [x y z] (argus origin in local coords)
%                     argusRotation = rot   (rotation angle to get from
%                     argus east to local east, positive couter-clockwise
%                     in degrees)
%
%    KV WRL 04.2017                 
%  
    
    % Rotation angle to get from argus east to local east, positive counter-clockwise
    phi = deg2rad(argusRotation);
    
    % Rotation matrix
    rotM = [cos(phi) sin(phi); -sin(phi) cos(phi)];
    
    % First rotate points around Z axis
    XYrot = (rotM*xyzArg(:, [1 2])')';
    
    % Then translate origin
    xyzLocal(:,1) = XYrot(:,1) + argusOrigin(1);
    xyzLocal(:,2) = XYrot(:,2) + argusOrigin(2);
    xyzLocal(:,3) = xyzArg(:,3) + argusOrigin(3);
    
        
    end

