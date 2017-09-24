function cfSurface = Surface(hAxes, varargin)
% Surface    Factory function for surfaces
%
%   curvefit.gui.Surface( anAxes, ... ) is a surface whose parent is anAxes. 

%   Copyright 2011 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2012/08/20 23:54:23 $

% if axes is a handle graphics object,
if curvefit.isHandlegraphics(hAxes)
    % then, use surface
    cfSurface = surface( 'Parent', hAxes, varargin{:} );
else
    % else, use a primitive surface
    cfSurface = primitiveSurface( hAxes, varargin{:} );
end
