classdef EditFitPanel < sftoolgui.Panel & curvefit.ListenerTarget
    % EditFitPanel   Panel for editing fits in SFTOOL

    %   Copyright 2008-2012 The MathWorks, Inc.
    
    properties (SetAccess = private)
        HFitdev
        FitFigure
    end
    
    properties(Access = private)
        JavaPanel
        JavaContainer
        JavaPanelHeight = [];
    end
    
    properties(Access=private, Constant)
        % Margin  Gap to apply around the java component
        Margin = 5;
    end
    
    methods
        function this = EditFitPanel(parentFig, hFitdev, fUUID, fitFigure)
            this = this@sftoolgui.Panel(parentFig);
            
            fittingNames = iCellArrayOfNames(hFitdev.FittingData);
            validationNames = iCellArrayOfNames(hFitdev.ValidationData);
            
            this.JavaPanel = javaObjectEDT( 'com.mathworks.toolbox.curvefit.surfacefitting.SFEditFitPanel', ...
                hFitdev.FitName, ...
                fUUID);

            this.HFitdev = hFitdev;
            this.FitFigure = fitFigure;
            
            % Update data panels
            javaMethodEDT('updateDataPanels', this.JavaPanel, ...
                hFitdev.FitName, ...
                fittingNames, ...
                validationNames);
            
            % Set autofit checkbox.
            javaMethodEDT('setAutoFit', this.JavaPanel, ...
                hFitdev.AutoFitEnabled);
            
            % Enable Fit Button
            javaMethodEDT('enableFitButton', this.JavaPanel, ...
            isFittingDataValid(hFitdev) && ~hFitdev.AutoFitEnabled);
            
            % Update parameters.
            setParameters(this, hFitdev);
            
            % Get the models
            twoDModel = javaMethodEDT('getTwoDModel', this.JavaPanel);
            threeDModel = javaMethodEDT('getThreeDModel', this.JavaPanel);
            
            % Set curve fittype
            [curveType, curveOptions] = getCurveDefinition(this.HFitdev);
            iSetFittype(twoDModel, curveType, curveOptions, this.HFitdev.CustomEquation);
            
            % Set surface fittype
            [surfaceType, surfaceOptions] = getSurfaceDefinition(this.HFitdev);
            iSetFittype(threeDModel, surfaceType, surfaceOptions, this.HFitdev.CustomEquation);
            
            % This call will make sure the correct model (curve or surface)
            % is displayed.
            dimensionChangedAction(this);
            
            this.createListener( this.JavaPanel, 'fitFit', @(s, e) this.fitAction( e ) );
            this.createListener( this.JavaPanel, 'updateFittingData', @(s, e) this.updateFittingDataAction( e ) );
            this.createListener( this.JavaPanel, 'updateValidationData', @(s, e) this.updateValidationDataAction( e ) );
            this.createListener( this.JavaPanel, 'updateFitName', @(s, e) this.updateFitNameAction( e ) );
            this.createListener( this.JavaPanel, 'updateAutoFit', @(s, e) this.updateAutoFitAction( e ) );
            this.createListener( twoDModel, 'fittypeChanged', @this.twoDFittypeChangedAction );
            this.createListener( threeDModel, 'fittypeChanged', @this.threeDFittypeChangedAction );
            this.createListener( twoDModel, 'fitOptionChanged', @this.twoDFitOptionChangedAction );
            this.createListener( threeDModel, 'fitOptionChanged', @this.threeDFitOptionChangedAction );
            
            % Stop button needs to be able to interrupt other callbacks
            this.storeListener(...
                curvefit.gui.event.interruptListener( this.JavaPanel, 'cancelFit', @(s, e) this.cancelFitAction( e ) ) ...
                );

            % Set up Fitdev listeners
            this.createListener(this.HFitdev, 'FittingStarted', @this.fittingStarted );
            this.createListener(this.HFitdev, 'FitCreated', @this.fitCreated );
            this.createListener(this.HFitdev, 'FitUpdated', @this.fitUpdated );
            this.createListener(this.HFitdev, 'FittingCompleted', @this.fittingCompleted );
            
            this.createListener(this.HFitdev, 'FittingDataUpdated', @(s, e) this.fittingDataUpdated() );
            this.createListener(this.HFitdev, 'ValidationDataUpdated', @(s, e) this.validationDataUpdated() );
            this.createListener(this.HFitdev, 'DimensionChanged', @(s, e) this.dimensionChangedAction() );
            this.createListener(this.HFitdev, 'CoefficientOptionsUpdated', @this.coefficientOptionUpdatedAction );
            this.createListener(this.HFitdev, 'FitTypeFitValuesUpdated', @(s, e) this.fitTypeFitValuesUpdatedAction ( e ) );
            
            % Add the java component to the uipanel
            [~, this.JavaContainer] = javacomponent(this.JavaPanel, [0 0 10 10], this.HUIPanel);
            set(this.JavaContainer, 'Units', 'pixels');
            
            this.layoutPanel()
        end

        function delete(this)
            javaMethodEDT('cleanup', this.JavaPanel);
        end

        function deletePanel(this)
            delete(this);
        end
        
        function updateValidationMessage(this, message, fitState)
            javaMethodEDT('updateValidationInfo', this.JavaPanel, ...
                message, fitState);
        end
        
        function H = getPreferredHeight(this)
        %getPreferredHeight Return the preferred height
        %
        %  getPreferredHeight(panel) returns the height that the
        %  EditFitPanel would prefer to be.
            
            if isempty(this.JavaPanelHeight)
                % Get the java panel's preferred size and cache the height
                % value
                fittingPanelSize = javaMethodEDT('getPreferredSize', this.JavaPanel);
                this.JavaPanelHeight = fittingPanelSize.height;
            end
            H = this.JavaPanelHeight + 2*this.Margin + 2*sftoolgui.util.getPanelBorderWidth(this.HUIPanel);
        end
        
        function showValidationDialog(this)
        %showValidationDialog Display the validation data selection dialog
        %
        %  showValidationDialog(panel) displays the validation data
        %  selection dialog.
        
            javaMethodEDT('showValidationDataDialog', this.JavaPanel);
        end
    end
    
    methods(Access = protected)
        function layoutPanel(this)
            % Pass on call to the superclass
            layoutPanel@sftoolgui.Panel(this);
            
            if ~isempty(this.JavaContainer)
                innerpos = this.InnerPosition; 
                margin = this.Margin;
                
                % Add a margin around the java component
                pos = innerpos + [margin margin -2*margin -2*margin];
                
                % Clip the position rectangle to be within innerpos
                pos = sftoolgui.util.clipPosition(innerpos, pos);
                
                % Apply correction
                pos = sftoolgui.util.adjustControlPosition(this.JavaContainer, pos);

                set(this.JavaContainer, 'Position', pos);
            end
        end
    end
    
    methods(Access = private)
        function fitAction(this, ~)
            %fitAction -- Start fitting when the Fit button is pressed
            %   fitAction(this, evt)
            fit(this.HFitdev);
        end
        
        function cancelFitAction(~, ~)
            %cancelFitAction -- Cancel fitting
            %
            %   cancelFitAction(this, evt)
            cfInterrupt( 'set', true );
        end
        
        function updateFittingDataAction (this, evt )
            updateFittingData(this.HFitdev, evt);
        end
        
        function updateValidationDataAction (this, evt )
            updateValidationData(this.HFitdev, evt);
        end
        
        function updateFitNameAction (this, evt )
            try
                this.HFitdev.FitName = char (evt.getFitName);
            catch me
                %Tell the user we were unable to set the name they
                %requested
                msg = sprintf('%s %s', me.message, getString(message('curvefit:sftoolgui:RestoringOldName')));
                uiwait(errordlg(msg,getString(message('curvefit:sftoolgui:InvalidFitName')),'modal'));
                % Restore old name to JavaPanel
                javaMethodEDT('setFitName', this.JavaPanel, this.HFitdev.FitName);
            end
        end
        
        function updateAutoFitAction (this, evt )
            updateAutoFit(this.HFitdev, evt.getAutoFitState);
                      
            % When the autofit button is checked or unchecked, the enable
            % state of the Fit Button might need to change
            javaMethodEDT('enableFitButton', this.JavaPanel, ...
                isFittingDataValid(this.HFitdev) && ~evt.getAutoFitState);
        end
        
        function twoDFitOptionChangedAction (this, ~, evt)
            % function twoDFitOptionChangedAction (this, src, evt)
            % twoDFitOptionChangedAction is the callback for GUI changes
            % to fitOptions for curves. Create fitOptions for curves and
            % pass on the information to Fitdev.
            ft = getCurveDefinition(this.HFitdev);
            opts = iCreateFitOptions(ft, evt);
            updateCurveFitOptions(this.HFitdev, opts);
        end
        
        function threeDFitOptionChangedAction (this, ~, evt)
            % function threeDFitOptionChangedAction (this, src, evt)
            % threeDFitOptionChangedAction is the callback for GUI changes
            % to fitOptions for surfaces. Create fitOptions for surfaces
            % and pass on the information to Fitdev.
            ft = getSurfaceDefinition(this.HFitdev);
            opts = iCreateFitOptions(ft, evt);
            updateSurfaceFitOptions(this.HFitdev, opts);
        end
        
        function twoDFittypeChangedAction(this, ~, evt)
            %function twoDFittypeChangedAction(this, src, evt)
            % twoDFittypeChangedAction is the callback for GUI curve
            % fittype changes. Create a new curve fittype and fitOptions
            % and pass the information to Fitdev.
            [ft, opts, customEquation, errorStr] = iCreateCurveFittype(evt);
            updateCurveFittype(this.HFitdev, ft, opts, customEquation, errorStr);
        end
        
        function threeDFittypeChangedAction(this, ~, evt)
            %function threeDFittypeChangedAction(this, src, evt)
            % threeDFittypeChangedAction is the callback for GUI surface
            % fittype changes. Create a new surface fittype and fitOptions
            % and pass the information to Fitdev.
            [ft, opts, customEquation, errorStr] = iCreateSurfaceFittype(evt);
            updateSurfaceFittype(this.HFitdev, ft, opts, customEquation, errorStr);
        end
        
        function coefficientOptionUpdatedAction(this, ~, evt)
            %function coefficientOptionUpdatedAction(this, src, evt)
            % coefficientOptionUpdatedAction updates the coefficients table
            [type, options] = getCurrentDefinition(evt.HFitdev);
            if isprop(options, 'StartPoint')
                startpoint = options.StartPoint;
            else
                startpoint = [];
            end
            if isprop(options, 'Lower')
                lower = options.Lower;
            else
                lower = [];
            end
            if isprop(options, 'Upper')
                upper = options.Upper;
            else
                upper = [];
            end
            javaMethodEDT('setCoefficientsTable', ...
                getJavaFittypeModel(this, evt.HFitdev), ...
                sftoolgui.util.javaFittypeCategory(type, ''), ...
                coeffnames(type), ...
                startpoint, lower, upper);
        end
        
        function fittingStarted( this, ~, ~ )
            % fittingStarted    Callback for when fitting is started
            cfInterrupt( 'set', false );
            javaMethodEDT( 'enableFitButton',  this.JavaPanel, false );
            javaMethodEDT( 'enableStopButton', this.JavaPanel, true );
        end

        function fitCreated( this, ~, ~ )
            % fitCreated    Callback for when a fit is created
            %
            % Once a fit has been created, fitting can no longer be interrupted
            
            % Disable the "stop" button
            javaMethodEDT( 'enableStopButton', this.JavaPanel, false );
            
            % Restore the interrupt state so as not to interfere with command-line operation
            cfInterrupt( 'set', false );
        end
        
        function fitUpdated( this, ~, evt )
            % fitUpdated   Callback for when a fit in a Fitdev is updated
            
            % Set parameters which may have been changed by the fit.
            setParameters( this, evt.HFitdev );
        end

        function fittingCompleted(this, ~, ~)
            % fittingCompleted    Callback for when fitting is complete
            
            % Possibly enable the "fit" button
            this.updateFitButtonEnable();
        end

        function fittingDataUpdated (this)
            % fittingDataUpdated   Action for when fitting data is updated
            
            [xName, yName, zName, wName] = getNames(this.HFitdev.FittingData);
            javaMethodEDT('setFittingDataNames', this.JavaPanel, xName, yName, zName, wName );
            
            this.updateFitButtonEnable();
            
            setParameters(this, this.HFitdev);
        end
        
        function dimensionChangedAction(this)
            javaMethodEDT('changeDimension', this.JavaPanel, ...
                isCurve(this.HFitdev));
        end

        function fitTypeFitValuesUpdatedAction (this, evt)
            setParameters(this, evt.HFitdev);
        end
        
        function setParameters(this, hFitdev)
            % setParameters will update the GUI parameters
            [type, options] = getCurrentDefinition(hFitdev);
            
            javaMethodEDT('setParameters', ...
                getJavaFittypeModel(this, hFitdev), ...
                sftoolgui.util.javaFittypeCategory(type, ''), ...
                iCreateParametersObject(hFitdev, options));
        end
        
        function validationDataUpdated(this)
            
            [xName, yName, zName, wName] = getNames(this.HFitdev.ValidationData);
            
            javaMethodEDT('setValidationDataNames', this.JavaPanel, ...
                xName, yName, zName, wName );
        end
        
        function updateFitButtonEnable(this)
            % updateFitButtonEnable   Update the "Enable" state of the Fit button based on
            % the auto-fit state and the validity of the fitting data.
            %
            % The fit button should be Enabled (Enable=true) if there is valid fitting data
            % and the auto-fit is off.
            enable = isFittingDataValid( this.HFitdev ) && ~this.HFitdev.AutoFitEnabled;
            javaMethodEDT( 'enableFitButton', this.JavaPanel, enable );
        end

        function javaFittypeModel = getJavaFittypeModel(this, hFitdev)
            % getJavaFittypeModel gets the TwoD or ThreeD model based on Fitdev's
            % isCurve method.
            if isCurve(hFitdev)
                javaFittypeModel =  javaMethodEDT('getTwoDModel', this.JavaPanel);
            else
                javaFittypeModel = javaMethodEDT('getThreeDModel', this.JavaPanel);
            end
        end
    end
end

function parametersObject = iCreateParametersObject(hFitdev, options)
% iCreateParametersObject will create a java parameterObject
% Currently only smoothing spline has parameters
if strcmpi(options.Method, 'SmoothingSpline')
    output = hFitdev.Output;
    if iHasOutputParamP(output)
        outputSmoothingParameter = output.p;
    else
        % Set outputSmoothingParameter -1 indicate invalid value
        outputSmoothingParameter = -1;
    end
    if isFittingDataValid(hFitdev)
        [~, y] = getValues(hFitdev.FittingData);
        numberOfPoints = numel(y);
    else
        numberOfPoints = 0;
    end
    % Create smoothing spline parameters
    parametersObject = javaObjectEDT( 'com.mathworks.toolbox.curvefit.surfacefitting.SmoothingSplineParameters', ...
        outputSmoothingParameter, numberOfPoints);
else
    % Create default parameters
    parametersObject = javaObjectEDT( 'com.mathworks.toolbox.curvefit.surfacefitting.Parameters');
end
end

function tf = iHasOutputParamP(output)
% iHasOutputParam returns true if output is a struct that contains a
% non-empty 'p' field.
tf = isstruct(output) && isfield(output, 'p') && ~isempty(output.p);
end

function iSetFittype(fittypeModel, type, options, customEquation)
% iSetFittype calls the java FittypeModel setFittype method with all
% information that might need updating.
fittypeStr = sftoolgui.util.javaFittypeCategory(type, customEquation);
javaMethodEDT('setFittype', fittypeModel, ...
    fittypeStr, ...
    sftoolgui.util.getQualifier(type), ...
    sftoolgui.util.javaNameValuePairs(type, options), ...
    coeffnames(type), ...
    iGetStartpoint(options), ...
    iGetLower(options), ...
    iGetUpper(options), ...
    iGetDepVarName(type), ...
    iGetIndVarName(type));
end

function depVarName = iGetDepVarName(type)
% Returns a java String containing the dependent variable name
depVarName = java.lang.String(dependnames(type));
end

function indVarsJava = iGetIndVarName(type)
% Returns a java String containing the dependent variable name
indVarsMATLAB = indepnames(type);
indVarsJava = javaArray('java.lang.String', length(indVarsMATLAB));
for ii = 1:length(indVarsJava)
    indVarsJava(ii) = java.lang.String(indVarsMATLAB{ii});
end
end

function names = iCellArrayOfNames(data)
% iCellArrayOfNames returns the names of the data variables in a cell array
[xName, yName, zName, wName] = getNames(data);
names = {xName, yName, zName, wName};
end

function args = iCellFromJavaNVP( javaNameValuePairs )
%Convert Java name value pairs into a cell array
m = size( javaNameValuePairs, 1 );
args = cell( 1, m );
for i=1:m
    args{i} = eval( javaNameValuePairs(i,:) );
end
end

function [ft, opts, customEquation, errorStr] = iCreateCurveFittype(evt)
% iCreateCurveFittype creates a curve fittype
[fitTypeName, qualifier, nameValueArgs, startpoint, lower, upper, ind, dep] = iEventValues(evt);
[ft, opts, customEquation, errorStr] = sftoolgui.util.createNewCurveFittype(fitTypeName, qualifier, nameValueArgs, startpoint, lower, upper, ind, dep);
end

function [ft, opts, customEquation, errorStr] = iCreateSurfaceFittype(evt)
% iCreateSurfaceFittype creates a surface fittype
[fitTypeName, qualifier, nameValueArgs, startpoint, lower, upper, ind, dep] = iEventValues(evt);
[ft, opts, customEquation, errorStr] = sftoolgui.util.createNewSurfaceFittype(fitTypeName, qualifier, nameValueArgs, startpoint, lower, upper, ind, dep);
end

function opts = iCreateFitOptions(ft, evt)
% iCreateFitOptions creates fitOptions for both curves and surfaces
[~, ~, nameValueArgs, startpoint, lower, upper] = iEventValues(evt);
opts = sftoolgui.util.createFitOptions(ft, nameValueArgs, startpoint, lower, upper);
end

function [fitTypeName, qualifier, nameValueArgs, startpoint, lower, upper, ind, dep] = iEventValues(evt)
% iEventValues gets values from the fitOptionChanged event.
fitTypeName = char(evt.getFitTypeStr);
qualifier = char(evt.getQualifier);
nameValueArgs =  iCellFromJavaNVP( evt.getAdditionalNameValuePairs );
startpoint = evt.getStartpoint;
lower = evt.getLower;
upper = evt.getUpper;
ind = cell(evt.getIndependentVariables);
dep = char(evt.getDependentVariable);
end

function sp = iGetStartpoint( options )
% Get the startpoint if it is defined.
if isprop(options, 'StartPoint')
    sp = options.StartPoint;
else
    sp = [];
end
end

function lb = iGetLower( options )
% Get the lower bounds if it is defined.
if isprop(options, 'Lower')
    lb = options.Lower;
else
    lb = [];
end
end

function ub = iGetUpper( options )
% Get the upper bounds if it is defined.
if isprop(options, 'Upper')
    ub = options.Upper;
else
    ub = [];
end
end
