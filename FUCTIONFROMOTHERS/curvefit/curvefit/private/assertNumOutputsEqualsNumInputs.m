function assertNumOutputsEqualsNumInputs( numInputs, numOutputs )
% assertNumOutputsEqualsNumInputs  Throw an error that "Number of output
% arguments must equal number of input arguments" if the two input arguments are
% not the same
%
%   assertNumOutputsEqualsNumInputs( numInputs, numOutputs )
%
%   See also: prepareFittingData

%   Copyright 2011 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $    $Date: 2012/08/20 23:55:36 $

if  numInputs ~= numOutputs
    error(message('curvefit:prepareFittingData:numOutputsMustEqualNumInputs'));
end
end
