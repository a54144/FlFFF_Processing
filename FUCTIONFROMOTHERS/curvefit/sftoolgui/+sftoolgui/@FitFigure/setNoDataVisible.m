function setNoDataVisible( this )
%setNoDataVisible sets the "No Data" and Plot Panels Visible state.

%   Copyright 2011-2012 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $    $Date: 2012/08/20 23:58:02 $

if isAnyDataSpecified(this.HFitdev)
    % Need to ensure that at least one plot is visible
    iEnsureAtLeastOnePlotVisible( this );
    % When making the plots we need to enable the rotate3d mode.
    iSetRotateAsDefaultMode( this.Handle );
    
    % If data is specified, the plot panels should be visible and the "No Data" panel
    % should be invisible.
    this.HPlotPanel.Visible = 'on';
    this.HNoDataPanel.Visible = 'off';
else
    % If data is not specified, the plot panels should be invisible and the "No Data"
    % panel should be visible.
    this.HPlotPanel.Visible = 'off';
    this.HNoDataPanel.Visible = 'on';
end
end

function iSetRotateAsDefaultMode( aFigure )
% iSetRotateAsDefaultMode   Set rotate3d to be the default mode
if ~hasuimode( aFigure, 'Exploration.Rotate3d' )
    r = rotate3d( aFigure );
    hM = uigetmodemanager(aFigure);
    set(hM,'DefaultUIMode','Exploration.Rotate3d');
    sftoolgui.util.allowLegendDragInRotate3D( aFigure, r );
end
end


function iEnsureAtLeastOnePlotVisible( this )
% iEnsureAtLeastOnePlotVisible   Ensure that at least one plot is visible.

if isequal( this.HSurfacePanel.Visible, 'off' ) ...
        && isequal( this.HResidualsPanel.Visible, 'off' ) ...
        && isequal( this.HContourPanel.Visible, 'off' ) 
    this.HSurfacePanel.Visible = 'on';

    % Tell the world that the visibility of the plots has changed.
    notify( this, 'PlotVisibilityStateChanged' );
end
end
