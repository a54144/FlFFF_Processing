function varargout = getBoundLinesImpl(hObj, ~)
% getBoundLinesImpl -- Implementation of get method for BoundLines property
%
%   getBoundLinesImpl(hObj, storedValue)

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:52:56 $ 

varargout{1} = [hObj.BoundedLineLowerHandle, hObj.BoundedLineUpperHandle];

end