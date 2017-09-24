classdef DefaultViewAngle < curvefit.Handle
    %DefaultViewAngle stores default view angles
    %
    %   DefaultViewAngle stores the default view angles for curve and
    %   surface data.
    
    %   Copyright 2011 The MathWorks, Inc.
    %   $Revision: 1.1.8.3 $    $Date: 2012/08/20 23:57:19 $
    
    properties (Constant);
        % Default2DViewAngle-- default view angle when curve data is specified
        TwoD = [0, 90];
        % Default3DViewAngle-- default view angle when curve data is not specified
        ThreeD = [-37.5, 30];
    end
end
