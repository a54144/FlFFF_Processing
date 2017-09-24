classdef MCode < curvefit.Handle
    %MCODE   The MCode object represents code generated from a SFTOOL session
    %
    %   OBJ = MCODE
    
    %   Copyright 2008-2012 The MathWorks, Inc.

    properties(Access = 'private', Constant = true)
        % FitVariableTokens -- Tokens that can be used in code but that will be
        % replaced by the corresponding variable for the fit.
        FitVariableTokens = {'<x-name>', '<y-name>', '<z-name>', '<w-name>', '<xv-name>', '<yv-name>', '<zv-name>'};
    end
    properties(SetAccess = 'private', GetAccess = 'private')
        % FitResult -- variable name for the fit object(s) that get returned by the
        % generated code
        FitResult = 'fitresult';
        
        % GOFVariable -- variable name for the goodness-of-fit (GOF) structure
        % that gets returned by the generated code
        GOFVariable = 'gof';
        
        % Inputs -- List of inputs to the generated code
        Inputs = {};
        
        % FitVariables -- Indices into Inputs for the of the variables for each fit
        FitVariables;
        
        % HelpComments -- Text of the comment "help" block of the code
        HelpComments = '';
        
        % FitBlocks -- Cell-array of cell-strings.
        %
        %   FitBlocks{n} is a cell-array of strings and represents the code that
        %   fits and plots the n-th fit in the session.
        FitBlocks = {}
        
        % VariableTokens -- Cell-array of strings
        VariableTokens = {}
        % Variables -- Cell-array of strings
        Variables = {}
        
        % FunctionNames -- Cell-array of strings
        %
        %   List of all functions the generated code will call.
        FunctionNames = {};
    end
    
    methods
        function h = MCode
            h.FitVariables = zeros( 0, length( h.FitVariableTokens ) );
            
            % Declare all the variables that will be used for fitting
            addVariable( h, '<x-input>', 'xData' );
            addVariable( h, '<y-input>', 'yData' );
            addVariable( h, '<z-output>', 'zData' );
            addVariable( h, '<weights>', 'weights' );
            % ... and validation
            addVariable( h, '<validation-x>', 'xValidation' );
            addVariable( h, '<validation-y>', 'yValidation' );
            addVariable( h, '<validation-z>', 'zValidation' );
        end
        
        function startNewFit( h )
            % STARTNEWFIT   Notify MCode object of start of new fit
            h.FitBlocks{end+1} = {};
            h.FitVariables(end+1,:) = 0;
        end
        
        function setFitVariable( h, variable, name )
            % setFitVariable   Set a variable for this fit
            %
            %   setFitVariable( h, '<x-name>', name )
            %   setFitVariable( h, '<y-name>', name )
            %   setFitVariable( h, '<z-name>', name )
            %   setFitVariable( h, '<weights>', name )
            [tf, tokenLocation] = ismember( variable,  h.FitVariableTokens );
            if tf
                addInput( h, name );
                [~, inputLocation] = ismember( name, h.Inputs );
                h.FitVariables(end,tokenLocation) = inputLocation;
            else
                error(message('curvefit:sftoolgui:MCode:InvalidFitVariable'));
            end
        end
        
        function addVariable( h, token, name )
            % ADDVARIABLE   Register a variable to the generated code
            if ismember( token, h.VariableTokens )
                % do nothing
            else
                h.VariableTokens{end+1} = token;
                h.Variables{end+1}      = name;
            end
        end
        
        function addHelpComment( h, comment )
            % ADDHELPCOMMENT   Register a line in the help comments
            %
            %   See also: addFitComment
            h.HelpComments = sprintf( '%s\n%s', h.HelpComments, comment );
        end
        
        function addFitComment( h, comment )
            % ADDFITCOMMENT  Add a comment line to the code for fitting a surface
            %
            %   ADDFITCOMMENT( H, COMMENT ) adds the comment, COMMENT, to the
            %   MATLAB Code to be generated, H. COMMENT should be a char array
            %   representing a single line, i.e., it should not a '\n' in it.
            %
            %   A comment character followed by a space, '% ', is prepended to
            %   the comment before it is written to the file.
            %
            %   The COMMENT should be translated before passing into this
            %   method, e.g.,
            %       addFitComment( mcode, xlate( 'This is my comment' ) )
            %
            %   See also: addHelpComment
            h.FitBlocks{end}{end+1} = iMakeComment( comment );
        end
        
        function addCellHeader( h, line )
            % ADDCELLHEADER  Add a cell header to the code for fitting a surface 
            %
            %   ADDCELLHEADER( H, COMMENT ) adds the line, LINE, to the MATLAB
            %   Code to be generated, H, and makes it into a cell header. LINE
            %   should be a char array representing a single line, i.e., it
            %   should not a '\n' in it.
            %
            %   The cell-header markup followed by a space, '%% ', is prepended
            %   to the line before it is written to the file.
            h.FitBlocks{end}{end+1} = iMakeCellHeader( line );
        end
        
        function addBlankLine( h )
            % ADDBLANKLINE  Add a blank line into code
            %
            %  ADDBLANKLINE( H ) adds an empty line in the MATLAB code to be 
            %  generated, H.
            h.FitBlocks{end}{end+1} = '';
        end
        
        function addFitCode( h, code )
            % ADDFITCODE   Add a code for fitting a surface to MCode object
            %
            %   ADDFITCODE( H, CODE ) adds the code, CODE, to the MATLAB Code to
            %   be generated H. CODE should be a char array representing one of
            %   more lines. Separate multiple lines with a new line character,
            %   i.e., sprintf( '\n' ).
            %
            %   The code can include various tokens. In the generated code,
            %   these tokens will be replaced by appropriate variables name. The
            %   allowed tokens and their meanings are:
            %
            %       <fo>    fit object
            %       <gof>   goodness-of-fit
            %       <x-name> name of the x variable
            %       <y-name> name of the y variable
            %       <z-name> name of the z variable
            %       <w>     weights
            %
            %   Note that in the generated code, each of these variables may
            %   vary with each fit.
            h.FitBlocks{end}{end+1} = code;
        end
        
        function addFunctionCall( h, varargin )
            % addFunctionCall   Add a function call to generated code.
            %
            % To add a call to the function f, i.e., to generate code like "f();"
            %     h.addFunctionCall( 'f' );
            %
            % To specify input arguments, pass extra arguments after the function name, e.g.,
            %     h.addFunctionCall( 'f', 'x' ) --> "f( x );"
            %     h.addFunctionCall( 'f', 'a', '''a string''' ) --> "f( a, 'a string' );"
            %
            % To specify output arguments, use the string equals, '=', as one input. Anything
            % before the equal is an output. The string after is the function name and
            % anything use is inputs, e.g.,
            %     h.addFunctionCall( 'y', '=', 'f', 'x' ) --> "y = f(x);"
            %     h.addFunctionCall( 'y', '=', 'f', 'a', 'b' ) --> "y = f( a, b );"
            %     h.addFunctionCall( 'x', 'y', '=', 'f', 'a', 'b' ) --> "[x, y] = f( a, b );"
            %
            % Tokens can be used for variable names, e.g.,
            %     h.addFunctionCall( '<fo>, '<gof>', '=' 'fit', '<x-name>', '<y-name>', '''poly1''' ) 
                        
            % Find the equals sign in the input arguments
            equalsIndex = iFindEqualsSign( varargin{:} );
	
            % Anything before the equals sign is an output
            outputs = varargin(1:equalsIndex-1);
            % The argument just after the equals sign is the function name
            functionName = varargin{equalsIndex+1};
            % Everything after the function name is an input argument.
            inputs = varargin(equalsIndex+2:end);

            % Generate a string that represents the MATLAB code for a function call
            inputList = iJoin( inputs );
            outputList = iLeftHandSide( outputs );
            code = sprintf( '%s%s( %s );', outputList, functionName, inputList );
            % Add the code to the block for the current fit
            h.addFitCode( code );
            
            % Record this function as one that is used in the generated code
            h.FunctionNames{end+1} = functionName;
        end
        
        function hFunction = writeTo( h, hFunction )
            % writeTo   Write an MCode object to a codegen.coderoutine object
            nFits = length( h.FitBlocks );
            
            % Set the names of the output and temporary variables
            finalizeVariables( h );

            % Add header information
            % -- name the function.
            if nFits == 1
                hFunction.Name = 'createFit';
            else
                hFunction.Name = 'createFits';
            end
            % -- register input arguments
            h.addArgumentsIn( hFunction );
            % -- register output arguments
            hFunction.addArgout( h.FitResult );
            hFunction.addArgout( h.GOFVariable );
            % -- add help comments at top of file
            hFunction.Comment = generateHelpComment( h );
            hFunction.SeeAlsoList = {'fit', 'cfit', 'sfit'};

            % Add code to initialize output arguments
            if nFits > 1
            hFunction.addText( iMakeCellHeader( getString(message('curvefit:sftoolgui:Initialization')) ) );
            hFunction.addText( '' ); % blank line
                hFunction.addText( iMakeComment( getString(message('curvefit:sftoolgui:InitializeArraysToStoreFitsAndGoodnessoffit')) ) );
                hFunction.addText( sprintf( '%s = cell( %d, 1 );', h.FitResult, nFits ) );
                hFunction.addText( sprintf( '%s = struct( ''sse'', cell( %d, 1 ), ...', h.GOFVariable, nFits ) );
                hFunction.addText( '''rsquare'', [], ''dfe'', [], ''adjrsquare'', [], ''rmse'', [] );' );
            end
            
            % Add code for fitting and plotting
            % -- get names of output variables as they change for each fit
            if nFits == 1
                fitObjectName = @(i) h.FitResult;
                gofName       = @(i) h.GOFVariable;
            else
                fitObjectName = @(i) sprintf( '%s{%d}', h.FitResult, i );
                gofName       = @(i) sprintf( '%s(%d)', h.GOFVariable, i );
            end
            % -- add fitting and plotting code for each fit in turn
            for i = 1:nFits
                hFunction.addText( '' );
                for j = 1:length( h.FitBlocks{i} )
                    thisLine = h.FitBlocks{i}{j};
                    thisLine = strrep( thisLine, '<fo>', fitObjectName( i ) );
                    thisLine = strrep( thisLine, '<gof>', gofName( i ) );
                    thisLine = replaceTokens( h, thisLine, i );
                    hFunction.addText( thisLine );
                end
            end
            hFunction.addText( '' );
        end
    end
    
    methods(Access = 'private' )
        function finalizeVariables( h )
            % finalizeVariables
            %
            % This method ensures that the variable names do not clash with any
            % of the inputs or any other variables that have been registered
            allNames = h.FunctionNames;
            
            % Variable names should not clash with function names
            h.Inputs = genvarname( h.Inputs, allNames );
            allNames = [allNames, h.Inputs];
            
            % FitResult
            h.FitResult = genvarname( h.FitResult, allNames );
            allNames{end+1} = h.FitResult;
            
            % Goodness of fit
            h.GOFVariable = genvarname( h.GOFVariable, allNames );
            allNames{end+1} = h.GOFVariable;
            
            % Temporary Variables
            h.Variables = genvarname( h.Variables, allNames );
        end
        
        function line = replaceTokens( h, line, fitIndex )
            % Replace tokens in a line of code
            for i = 1:length( h.FitVariableTokens )
                index = h.FitVariables(fitIndex,i);
                if index > 0
                    thisInput = h.Inputs{index};
                    line = strrep( line, h.FitVariableTokens{i}, thisInput );
                end
            end
            for i = 1:length( h.Variables )
                line = strrep( line, h.VariableTokens{i}, h.Variables{i} );
            end
        end
        
        function comments = generateHelpComment( h )
            % generateHelpComment -- Generate the help comment that gets
            % inserted at the top of file.
            nFits = length( h.FitBlocks );
            if nFits == 1
                line1 = getString(message('curvefit:sftoolgui:CreateAFit'));
                output1 = getString(message('curvefit:sftoolgui:Output')); 
                output2 = sprintf('    %s', getString(message('curvefit:sftoolgui:AFitObjectRepresentingTheFit', h.FitResult )));
                output3 = sprintf('    %s', getString(message('curvefit:sftoolgui:StructureWithGoodnessofFitInfo', h.GOFVariable )));
            else
                line1 = getString(message('curvefit:sftoolgui:CreateFits'));
                output1 = getString(message('curvefit:sftoolgui:Output'));
                output2 = sprintf('    %s', getString(message('curvefit:sftoolgui:ACellarrayOfFitObjectsRepresentingTheFits', h.FitResult )));
                output3 = sprintf('    %s', getString(message('curvefit:sftoolgui:StructureArrayWithGoodnessofFitInfo', h.GOFVariable )));
            end
            comments = sprintf( '%s\n%s\n%s\n%s\n%s', line1, h.HelpComments, output1, output2, output3 );
        end
        
        function addInput( h, input )
            % ADDINPUT   Register an input to the generated code
            if ismember( input, h.Inputs )
                % do nothing
            else
                h.Inputs{end+1} = input;
            end
        end
        
        function addArgumentsIn( h, hFunction )
            % addArgumentsIn   Add names of input arguments to a codegen.coderoutine
            for i = 1:length( h.Inputs )
                hFunction.addArgin( h.Inputs{i} );
            end
        end
    end
end

function comment = iMakeComment( text )
% iMakeComment -- Make a comment from a piece of text
%
% The purpose of this routine is to make translation easier. It may be called as
% follows: 
%   addText( hFunction, iMakeComment( xlate( 'my comment' ) ) )
% where hFunction us a codegen.coderoutine.
%
% The comment character plus a space, '% ' will be added to the TEXT to make the
% comment
comment = sprintf( '%% %s', text );
end

function cellHeader = iMakeCellHeader( text )
% iMakeComment -- Make a cell header from a piece of text
%
% The cell break symbol plus a space, '%% ' will be added to the TEXT to make
% the cell header.
cellHeader = sprintf( '%%%% %s', text );
end

function str = iJoin( cellstr )
% iJoin   Join elements of a cell-string into a comma-separated list
str = sprintf( '%s, ', cellstr{:} );
str(end-1:end) = '';
end

function code = iLeftHandSide( outputs )
% iLeftHandSide   A string that is the correct left hand side (including equals)
% for a given cell-string of output names.
switch length( outputs )
    case 0
        code = '';
    case 1
        code = sprintf( '%s = ', outputs{1} );
    otherwise % many outputs
        code = sprintf( '[%s] = ', iJoin( outputs ) );
end
end

function index = iFindEqualsSign( varargin )
% iFindEqualsSign   The index of the an equals sign, '=', in a cell-array of
% strings.
%
% If the an equal sign is not present, then index = 0 is returned.
[tf, index] = ismember( '=', varargin );
if ~any( tf )
    index = 0;
end
end
