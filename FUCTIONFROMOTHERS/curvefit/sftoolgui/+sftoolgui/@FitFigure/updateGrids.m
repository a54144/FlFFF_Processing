function updateGrids(fitFigure)
%updateGrids Update all FitFigure plot panels' grids  
%
%   updateGrids is called to update all FitFigure plot panels' grids

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:58:11 $

updateGrid(fitFigure.HResidualsPanel);
updateGrid(fitFigure.HSurfacePanel);
updateGrid(fitFigure.HContourPanel);
end