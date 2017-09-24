classdef(Abstract) Client < curvefit.Handle
%Client Abstract client for use in Surface Fitting Tool.

%   Copyright 2008-2012 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $    $Date: 2012/08/20 23:56:35 $
    
    
    properties(SetAccess = 'protected', GetAccess = 'protected')
        % JavaPanel --  The Java version of this panel.
        JavaPanel;
        JavaClient;
    end
    
    properties(SetAccess = 'protected', GetAccess = 'public')
        % Name -- The name of the panel - this should not be translated
        Name;
    end
    
    methods
        function addClient( obj, dt, dtl )
            % ADDCLIENT -- Add the panel to the desktop
            %     ADDCLIENT( HPANEL, DT, DTL ) adds the panel HPANEL to the
            %     MATLAB desktop DT in the position DTL (DTLocation)
            %
            % TODO: Is this the right place to be positioning the panel?
            % Then we position the client in the desktop
            %
            % 'Name' is actually controlled by setClientName and setTitle
            % in the JavaClient
            javaMethodEDT( 'addClient', dt, obj.JavaClient, obj.Name, true, dtl, true );
        end
    end
    
end
