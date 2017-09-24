function updateFitTypeValues ( this )
%updateFitTypeValues clears plots and updates results, information and
%legends.

%   Copyright 2008-2011 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $    $Date: 2012/08/20 23:58:09 $

updateResults(this.HResultsPanel, ' ');
clearSurface(this.HSurfacePanel);
clearSurface(this.HContourPanel);
clearSurface(this.HResidualsPanel);
updateInformationPanel(this);
updateLegends(this);
end
