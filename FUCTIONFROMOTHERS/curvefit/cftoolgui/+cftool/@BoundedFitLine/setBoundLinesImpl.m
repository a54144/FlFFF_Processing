function varargout = setBoundLinesImpl(~, ~)
% setBoundLinesImpl -- Implementation of set method for BoundLines property
%
%   setBoundLinesImpl(hObj, newValue)
%
%   The BoundLinesproperty is read-only. Hence this method will throw an error.

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $    $Date: 2012/08/20 23:53:02 $

error(message('curvefit:cftool:BoundedFitLine:CannotSetBoundLines'));

end
