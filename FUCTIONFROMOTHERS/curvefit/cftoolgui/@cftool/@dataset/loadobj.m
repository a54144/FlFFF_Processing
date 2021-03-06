function ds = loadobj(ds)
%LOADOBJ Load filter for cftoo.dataset objects
%
%   DS = LOADOBJ(DS)

%   Copyright 2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:53:09 $ 

NONE = cfswitchyard( 'cfGetNoneString' );

% If the weights are named NONE but there are actually weights, then we need to
% give the weights a name
if ~isempty( ds.weight ) && isequal( ds.weightname, NONE )
    ds.weightname = 'w';
end


end
