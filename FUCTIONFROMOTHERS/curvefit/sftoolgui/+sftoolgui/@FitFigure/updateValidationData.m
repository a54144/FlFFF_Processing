function updateValidationData( this )
%updateValidationData updates plots and messages when validation data changes. 

%   Copyright 2008-2011 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $    $Date: 2012/08/20 23:58:16 $

hFitdev = this.HFitdev;
updateValidationMessage(this.HFittingPanel, ...
    getMessageString(hFitdev.ValidationData), ...
    getMessageLevel(hFitdev.ValidationData));
resetToDataLimits(this);
plotValidationData(this);
updateResultsArea(this);
end
