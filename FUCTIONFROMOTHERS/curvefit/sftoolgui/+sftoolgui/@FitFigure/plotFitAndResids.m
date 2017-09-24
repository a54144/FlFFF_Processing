function plotFitAndResids(this)
%plotFitAndResids Update FitFigure plot panels and their positions

%   Copyright 2008-2011 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $    $Date: 2012/08/20 23:57:55 $

if strcmp(this.HSurfacePanel.Visible, 'on')
    plotSurface(this.HSurfacePanel);
end
if strcmp(this.HContourPanel.Visible, 'on')
    plotSurface(this.HContourPanel);
end
if strcmp(this.HResidualsPanel.Visible, 'on')
    plotResiduals(this.HResidualsPanel);
end
end