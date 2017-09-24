function panModeCallback(fitFigure, src, ~)
% panModeCallback Pan mode callback
%
%   panModeCallback(fitFigure, SRC, EVENT) is the callback to the pan menu
%   item and toolbar button click.

%   Copyright 2011 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:57:54 $

sftoolgui.sfpan3d(fitFigure, sftoolgui.util.getMenuToggleToolState(src));
end