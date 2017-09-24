function this = fitNameUpdated( this )
%fitNameUpdated FitFigure callback to Fitdev's FitNameUpdated event

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:57:49 $

set(this.Handle, 'Name', this.HFitdev.FitName);
updateDisplayNames(this.HResidualsPanel);
updateDisplayNames(this.HSurfacePanel);
updateDisplayNames(this.HContourPanel);
end