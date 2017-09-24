function toggleLegendState(fitFigure, ~, ~)
%toggleLegendState Toggle legend state
%
%   toggleLegendState(fitFigure, SOURCE, EVENT) is the callback to the
%   Legend menu item and a toolbar button click.

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:58:05 $

toggleProperty(fitFigure, 'LegendOn');
end