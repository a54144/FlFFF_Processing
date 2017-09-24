function toggleGridState(fitFigure, ~, ~)
%toggleGridState Toggle grid state
%
%   toggleGridState(fitFigure, SOURCE, EVENT) is the callback to Grid menu
%   item and toolbar button click.

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:58:04 $

toggleProperty(fitFigure, 'GridState');
end