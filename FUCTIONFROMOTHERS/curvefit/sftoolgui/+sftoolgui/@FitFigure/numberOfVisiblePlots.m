function nVisiblePlots = numberOfVisiblePlots(this)
%numberOfVisiblePlots FitFigure utility
% 
%   numberOfVisiblePlots returns the number of plots whose Visible property
%   is on.

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:57:53 $

nVisiblePlots = 0;
for i=1:length(this.PlotPanels)
    if strcmp(this.PlotPanels{i}.Visible, 'on')
        nVisiblePlots = nVisiblePlots + 1;
    end
end
end