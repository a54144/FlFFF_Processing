classdef(Sealed) LightTheme
    % LightTheme   Colors and colormap for the "light" theme.
    
    %   Copyright 2011 The MathWorks, Inc.
    %   $Revision: 1.1.8.2 $    $Date: 2012/08/20 23:57:20 $
    
    properties(Constant)
        % Blue   The shade of blue for the "light" theme
        Blue   = [ 18, 104, 179]/255;
        
        % Red   The shade of red for the "light" theme
        Red    = [237,  36,  38]/255;
        
        % Green   The shade of green for the "light" theme
        Green  = [155, 190,  61]/255;
        
        % Purple   The shade of purple for the "light" theme
        Purple = [123,  45, 116]/255;
        
        % Yellow   The shade of yellow for the "light" theme
        Yellow = [255, 199,   0]/255;
        
        % Azure   The shade of azure for the "light" theme
        Azure  = [ 77, 190, 238]/255;
    end
    
    methods(Access = private)
        function l = LightTheme()
            % LightTheme   Construction of this class is not allowed!
        end
    end
    
    methods(Static)
        function map = map( numRows )
            % map   The colormap for the "light" theme.
            %
            %   sftoolgui.util.LightTheme.map( M ) is an M-by-3 matrix containing a "light"
            %   colormap.
            %
            %   See also: jet, copper, colormap
            if ~nargin
                numRows = 66;
            end
            
            colors = [
                sftoolgui.util.LightTheme.Red
                sftoolgui.util.LightTheme.Purple
                sftoolgui.util.LightTheme.Blue
                sftoolgui.util.LightTheme.Azure
                sftoolgui.util.LightTheme.Green
                sftoolgui.util.LightTheme.Yellow
                ];
            map = pchip( 1:6, colors.', linspace( 1, 6, numRows ) ).';
        end
    end
end
