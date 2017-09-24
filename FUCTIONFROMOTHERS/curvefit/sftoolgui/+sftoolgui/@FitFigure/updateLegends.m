function updateLegends(this)
%updateLegends Update all FitFigure plot panels' legends
%
%   updateLegends is called to update all FitFigure plot panels' legends

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:58:13 $

updateLegend(this.HResidualsPanel, this.LegendOn);
updateLegend(this.HSurfacePanel, this.LegendOn);
updateLegend(this.HContourPanel, this.LegendOn);
end