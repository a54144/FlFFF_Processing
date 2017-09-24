function addprop(obj, propname)
%ADDPROP  Add a dynamic property
%
%   addprop(obj,'PropName') adds a property named PropName to OBJ
%
%   Copyright 2011 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:54:24 $ 

if curvefit.isHandlegraphics( obj )
    schema.prop( obj, propname, 'MATLAB array');
else
	p = addprop( obj, propname );
    p.SetObservable = true;
end

end
