function updateExclusions( this )
% updateExclusions  Callback for when exclusions change.
%
%    When exclusions change, we need to plot the fitting data.

%   Copyright 2011-2012 The MathWorks, Inc.
%   $Revision: 1.1.8.4 $    $Date: 2012/08/20 23:58:07 $

% For the ExclusionsUpdated event, i.e., when exclusions have been updated, we
% want to do the same things as when fitting data has been updated

plotFittingData(this);
end
