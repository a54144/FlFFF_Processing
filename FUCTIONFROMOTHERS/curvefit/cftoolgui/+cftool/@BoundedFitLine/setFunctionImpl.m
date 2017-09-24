function varargout = setFunctionImpl(~, ~)
% setFunctionImpl -- Implementation of set method for Function property
%
%   setFunctionImpl(hObj, newValue)
%
%   The Function property is read-only. Hence this method will throw an error.

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $    $Date: 2012/08/20 23:53:03 $

error(message('curvefit:cftool:BoundedFitLine:CannotSetFunction'));

end
