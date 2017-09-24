function b = stringLiteral( a )
% STRINGLITERAL   Convert a string to a string literal for use in code
%
%   B = STRINGLITERAL( A ) converts the string A into the string
%   literal B. B will be valid for insertion in MATLAB code.

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:57:18 $

% Replace any single quote with double quotes
b = strrep( a, '''', '''''' );

end
