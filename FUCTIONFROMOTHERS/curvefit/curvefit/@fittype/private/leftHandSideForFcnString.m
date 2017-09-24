function lhs = leftHandSideForFcnString(variable, args)
% iLeftHandSideForFcnString -- Make the left hand side of a function string,
% e.g., 'sf(x, y)', 'cf(a, b, x)'.
%
%   LHS = LEFTHANDSIDEFORFCNSTRING(VARIABLE, ARGS)

%   Copyright 2008-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:55:15 $ 

args = cellstr( args );

arglist = sprintf( ',%s', args{:} );
lhs = sprintf( '%s(%s)', variable, arglist(2:end) );

end
