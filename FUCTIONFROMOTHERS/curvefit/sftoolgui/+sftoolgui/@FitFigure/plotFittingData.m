function plotFittingData(hFitFigure)
%plotFittingData Plot FitFigure fitting data lines
%
% plotFittingData(hFitFigure) plots hFitFigure fitting data lines.

%   Copyright 2008-2011 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:57:56 $

hFitdev = hFitFigure.HFitdev;

previewValues =  sftoolgui.util.previewValues(hFitdev.FittingData);

clearFittingDataLine(hFitFigure.HSurfacePanel);
clearFittingDataLine(hFitFigure.HContourPanel);

% Plot the fitting data if all specified data have the same number of
% elements.
if areNumSpecifiedElementsEqual(hFitdev.FittingData)
    plotDataLineWithExclusions(hFitFigure.HSurfacePanel, ...
        previewValues, hFitdev.Exclusions, hFitdev.FittingData.Name);
    plotDataLineWithExclusions(hFitFigure.HContourPanel, ...
        previewValues, hFitdev.Exclusions, hFitdev.FittingData.Name);
    plotDataLineWithExclusions(hFitFigure.HResidualsPanel);
end

% Update legends
updateLegends(hFitFigure);
end

