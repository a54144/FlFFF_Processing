classdef(Sealed) MarkerStylist < curvefit.Handle
    % MarkerStylist   Sets the marker style of lines for CFTOOL
    
    %   Copyright 2012 The MathWorks, Inc.
    %   $Revision: 1.1.10.1 $  $Date: 2012/08/20 23:57:21 $
    
    properties(Constant, GetAccess = private)
        % Properties   The properties of the different types of marker than can be set.
        Properties = iProperties();
    end
    
    methods(Access = private)
        function stylist = MarkerStylist()
            % MarkerStylist   Private constructor for sftoolgui.util.MarkerStylist
            %
            % Use the static style() method to apply a style a line or other graphic.
            %
            % See also: style.
        end
    end
    
    methods(Static)
        function style( aGraphic, aStyle )
            % style   Style a graphic with a given style
            %
            % Syntax:
            %   sftoolgui.util.MarkerStylist.style( aGraphic, 'inclusion' );
            %   sftoolgui.util.MarkerStylist.style( aGraphic, 'exclusion' );
            %   sftoolgui.util.MarkerStylist.style( aGraphic, 'validation' );
            %
            % Inputs:
            %   aGraphic -- a graphic that has markers, e.g., a line or a stem.
            stylist = sftoolgui.util.MarkerStylist();
            set( aGraphic, stylist.Properties.(aStyle) )
        end
    end
end

function properties = iProperties()
properties = struct( ...
    'inclusion', iInclusionProperties(), ...
    'exclusion', iExclusionProperties(), ...
    'validation', iValidationProperties() );
end

function properties = iInclusionProperties()
% iInclusionProperties   Marker properties for "inclusion" lines
properties = struct( ...
    'Marker', 'o', ...
    'MarkerFaceColor', 'k', ...
    'MarkerEdgeColor', 'k', ...
    'MarkerSize', 3 );
end

function properties = iExclusionProperties()
% iExclusionProperties   Marker properties for "exclusion" lines
properties = struct( ...
    'Marker', 'x', ...
    'MarkerEdgeColor', 'r', ...
    'MarkerSize', 6, ...
    'LineWidth', 1.5  );
end

function properties = iValidationProperties()
% iValidationProperties   Marker properties for "validation" lines
properties = struct( ...
    'Marker', 'o', ...
    'MarkerFaceColor', 'w', ...
    'MarkerEdgeColor', sftoolgui.util.LightTheme.Green, ...
    'MarkerSize', 4  );
end
