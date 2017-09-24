classdef FitOptionsCodeGenerator < curvefit.Handle
    % FitOptionsCodeGenerator   Classes for generating code for Fit Options
    %
    %   Example
    %       mcode = sftoolgui.codegen.MCode();
    %       factory = sftoolgui.codegen.FitOptionsFactory();
    %
    %       % Create fit options code generator
    %       focg = factory.create( aFitOptions );
    %
    %       % Most options are taken from the fit options. However, 'Normalize',
    %       % 'Exlcude' and 'Weights' must be added as paramter-value pairs.
    %       focg.addParameterValue( 'Normalize', 'on' );
    %       % If the value for an option should be set from a variable in the
    %       % generated code, then the addParameterToken() method should be used to
    %       % add the option.
    %       focg.addParameterToken( 'Weights', '<weights>' );
    %
    %       % Generate code to setup fit options object (possible no-op)
    %       focg.generateSetupCode( mcode );
    %
    %       % Generate code to call FIT function
    %       mcode.addFunctionCall( 'f', 'g', '=', 'fit', 'x', 'y', 'poly1', focg.ExtraFitArguments{:} );
    %
    %   See also: sftoolgui.codegen.FitOptionsFactory, sftoolgui.codegen.MCode.
    
    %   Copyright 2012 The MathWorks, Inc.
    
    properties(SetAccess = 'private', GetAccess = 'public', Dependent)
        % ExtraFitArguments   Cell-array of strings of "extra arguments" that should be
        % passed to the FIT function in generated code.
        ExtraFitArguments
    end
    
    methods
        function arguments = get.ExtraFitArguments( this )
            % get.ExtraFitArguments  Get method for ExtraFitArguments property
            arguments = getExtraFitArguments( this );
        end
    end
    
    methods(Abstract, Access = 'protected')
        % getExtraFitArguments  Implementation of get method for ExtraFitArguments property
        arguments = getExtraFitArguments( this )
    end
    
    methods(Abstract)
        % addParameterValue   Add a parameter-value pair to the list of Fit Options to
        % generate code generated.
        addParameterValue( this, parameter, value )
        
        % addParameterToken   Add a parameter-value pair where the value is a variable token.
        %
        % The parameter-value pair will be added to the list of Fit Options to generate
        % code generated.
        addParameterToken( this, parameter, token )
        
        % generateSetupCode   Generate the code required to setup a Fit Options object.
        %
        % See also: sftoolgui.codegen.MCode
        generateSetupCode( this, mcode )
    end
    
    methods(Access = protected)
        function addFitOptionsAsParameterValues( this, aFitOptions )
            % addFitOptionsAsParameterValues   Adds the names and values of any non-default
            % options fields as parameter-value pairs.
            
            % Get the default values for options
            defaultOptions = fitoptions( 'Method', aFitOptions.Method );
            
            % Get a list of all the possible parameters
            parameters = fieldnames( aFitOptions );
            parameters = setdiff( parameters, 'Method' );
            
            % For any options parameter where the value differs from the default, store the
            % pair.
            for i = 1:length( parameters )
                thisParameter = parameters{i};
                
                thisValue = aFitOptions.(thisParameter);
                defaultValue = defaultOptions.(thisParameter);
                
                if ismember( thisParameter, {'Exclude', 'Normalize', 'Weights'} )
                    % ignore these options -- they should be added as parameter-value pairs
                elseif isequal( defaultValue, thisValue )
                    % no need to store
                else
                    this.addParameterValue( thisParameter, thisValue );
                end
            end
        end
    end
end

