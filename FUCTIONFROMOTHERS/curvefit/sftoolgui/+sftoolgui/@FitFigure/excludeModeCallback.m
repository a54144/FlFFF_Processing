function excludeModeCallback(fitFigure, src, ~)
%excludeModeCallback Exclude mode callback
%
%   excludeModeCallback(fitFigure, SRC, EVENT) is the callback to the Exclude
%   outliers menu item and toolbar button click.

%   Copyright 2008-2011 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $    $Date: 2012/08/20 23:57:48 $

sftoolgui.sfExcludeMode(fitFigure, sftoolgui.util.getMenuToggleToolState(src));
end
