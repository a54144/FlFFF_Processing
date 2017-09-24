function tf = isAssociatedFit( this, fit )
%isAssociatedFit determines whether or not FIT is the associated fit.

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:57:52 $
    tf = (fit == this.HFitdev);
end

