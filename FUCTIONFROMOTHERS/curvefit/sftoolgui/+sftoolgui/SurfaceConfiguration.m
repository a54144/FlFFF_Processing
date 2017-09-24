classdef SurfaceConfiguration < sftoolgui.Configuration
    %SURFACECONFIGURATION configuration file for sftool surface plot 
    %
    %   SFTOOLGUI.SURFACESCONFIGURATION
    %
    %   Copyright 2008-2011 The MathWorks, Inc.
    %   $Revision: 1.1.6.3 $    $Date: 2012/08/20 23:56:52 $

    properties(SetAccess = 'private', GetAccess = 'private')
         Version = 1;
    end

    properties(SetAccess = 'public', GetAccess = 'public')
         Visible = 'on';
         PredictionLevel = 0;
    end
    
    methods
          function this = SurfaceConfiguration()
          end
    end
end
