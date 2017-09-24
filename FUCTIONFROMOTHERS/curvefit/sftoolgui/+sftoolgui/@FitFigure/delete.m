function delete(this)
%delete Destroy an sftoolgui.FitFigure
%
%  delete(obj) destroys an instance of an sftoolgui.FitFigure.

%   Copyright 2012 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $    $Date: 2012/08/20 23:57:47 $

% Inform the fits manager that the figure is closing
if isvalid(this.HSFTool)
    config = this.Configuration;
    config.Visible = 'off';
    this.HSFTool.HFitsManager.closeFit(this.FitUUID, config);
end

% Destroy the fitting panel: this is required to clean up listeners in Java
deletePanel(this.HFittingPanel);
