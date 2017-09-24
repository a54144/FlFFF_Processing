function obj = loadobj(input)
% loadobj   Load filter for SFIT

%   Copyright 2011 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2012/08/20 23:55:24 $

if isstruct( input )
    warning( message( 'curvefit:sfit:loadobj:CannotLoadStructure' ) );
    obj = sfit();
else
    obj = fittype.loadobj( input );
end

% Ensure any surface interpolants are correctly represented
if iIsSurfaceInterpolant( obj )
    aFactory = curvefit.model.SurfaceInterpolantFactory( 'ErrorThrower', curvefit.attention.Warning );
    obj.fCoeffValues{1} = aFactory.load( obj.fCoeffValues{1} );
end
end

function tf = iIsSurfaceInterpolant( obj )
% iIsSurfaceInterpolant   True for SFIT objects that are surface interpolants.
tf = numindep( obj ) == 2 && ...
    ismember( type( obj ), {'linearinterp', 'nearestinterp', 'cubicinterp', 'biharmonicinterp'} );
end
