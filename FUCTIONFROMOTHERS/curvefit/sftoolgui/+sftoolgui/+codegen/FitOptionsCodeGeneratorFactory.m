classdef( Sealed ) FitOptionsCodeGeneratorFactory < curvefit.Handle
    % FitOptionsCodeGeneratorFactory   Factory for Fit Options code generators
    
    %   Copyright 2012 The MathWorks, Inc.
    
    methods
        function focg = create( ~, options )
            % create   Create a fit options code generator for a given set of fit options.
            %
            % Syntax:
            %   factory = sftoolgui.codegen.FitOptionsFactory();
            %   focg = factory.create( options );
            
            if iIsDefaultFitOptions( options )
                focg = sftoolgui.codegen.FitOptionsArguments( options );
            else
                focg = sftoolgui.codegen.FitOptionsObjectCode( options );
            end
        end
    end
end

function tf = iIsDefaultFitOptions( aFitOptions )

defaultOptions = fitoptions( 'Method', aFitOptions.Method );

% Two sets of fit options are the same if all corresponding properties have the
% same value.
tf = isequal( get( aFitOptions ), get( defaultOptions ) );
end
