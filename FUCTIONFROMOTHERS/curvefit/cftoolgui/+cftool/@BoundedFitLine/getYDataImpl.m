function varargout = getYDataImpl(hObj, ~)
% getYDataImpl -- Implementation of get method for YData property
%
%   getYDataImpl(hObj, storedValue) is the value of the YData property for the
%   BoundedFitLine object hObj. The storedValue is ignored.

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:53:01 $

[~,varargout{1}] = hObj.calcXYData();

end
