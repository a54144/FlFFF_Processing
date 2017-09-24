classdef ResidualsPanel < sftoolgui.Panel
    %RESIDUALSPANEL A panel used by SFTOOL for residuals
    %
    %   RESIDUALSPANEL (fitFigure, parent)
    
    %   Copyright 2008-2012 The MathWorks, Inc.
    
    properties(SetAccess = 'private', GetAccess = 'public')
        HFitFigure ;
    end
    
    properties(Access = 'private')
        % Created   Flag to indicate if the "graphics" have been created.
        Created = false;
    end
    properties(SetAccess = 'private', GetAccess = 'public')
        HAxes ;
        HResidualsPlot ;
        HResidualsLineForExclude ;
        HValidationDataPlot ;
        HReferencePlot;
        HExclusionPlot;
    end
    methods
        % The "get" methods for the graphics properties are all the same. They first need
        % to ensure that the graphics are created and then return the value of the
        % appropriate property.
        function v = get.HAxes( this )
            createGraphics( this );
            v = this.HAxes;
        end
        function v = get.HResidualsPlot( this )
            createGraphics( this );
            v = this.HResidualsPlot;
        end
        function v = get.HResidualsLineForExclude( this )
            createGraphics( this );
            v = this.HResidualsLineForExclude;
        end
        function v = get.HValidationDataPlot( this )
            createGraphics( this );
            v = this.HValidationDataPlot;
        end
        function v = get.HReferencePlot( this )
            createGraphics( this );
            v = this.HReferencePlot;
        end
        function v = get.HExclusionPlot( this )
            createGraphics( this );
            v = this.HExclusionPlot;
        end
    end
    
    properties(SetAccess = 'private', GetAccess = 'private')
        % AxesViewController is an sftoolgui.AxesViewController
        AxesViewController;
        % AxesViewModel is the sftoolgui.AxesViewModel
        AxesViewModel;
    end
    
    properties (Constant);
        Icon = 'residualSMALL.png';
        % Description is used as the toolbar button tooltip
        Description = getString(message('curvefit:sftoolgui:toolTip_ResidualsPlot'));
        % Name is used as the menu label
        Name = getString(message('curvefit:sftoolgui:menu_ResidualsPlot'));
    end
    
    methods
        function this = ResidualsPanel(fitFigure, parent)
            this = this@sftoolgui.Panel(parent);
            
            this.HFitFigure = fitFigure;
            this.AxesViewModel = fitFigure.AxesViewModel;
            
            this.Tag = 'ResidualUIPanel';
        end
        
        function updateGrid(this)
            set(this.HAxes, 'XGrid', this.HFitFigure.GridState);
            set(this.HAxes, 'YGrid', this.HFitFigure.GridState);
            set(this.HAxes, 'ZGrid', this.HFitFigure.GridState);
        end
        
        function plotDataLineWithExclusions(this)
            updatePlot(this);
        end
        
        function updateLabels(this)
            % updateLabels updates axes labels
            
            [xLabel, yLabel, zLabel] = getDominantLabels(this.HFitFigure.HFitdev);
            
            set( get( this.HAxes, 'XLabel' ), 'String', xLabel);
            set( get( this.HAxes, 'YLabel' ), 'String', yLabel);
            set( get( this.HAxes, 'ZLabel' ), 'String', zLabel);
        end

        function updateLegend(this, state)
            hFitdev = this.HFitFigure.HFitdev;
            fitObject = hFitdev.Fit;
            if state && ~isempty(fitObject)
                curvefit.gui.setLegendable( this.HResidualsPlot, true );
                
                haveValidationData = isValidationDataValid( hFitdev );
                curvefit.gui.setLegendable( this.HValidationDataPlot, haveValidationData );
                
                anyPointsExcluded = ~isempty( hFitdev.Exclusions ) && any( hFitdev.Exclusions );
                curvefit.gui.setLegendable( this.HExclusionPlot, anyPointsExcluded );
            end
            if this.Created
                sftoolgui.util.refreshLegend(this.HAxes, state && ~isempty(fitObject));
            end
        end
        
        function plotResiduals(this)
            updatePlot(this);
            updateLegend(this, this.HFitFigure.LegendOn);
        end
        
        function updateDisplayNames(this)
            hFitdev = this.HFitFigure.HFitdev;
            set(this.HResidualsPlot, 'DisplayName', getString(message('curvefit:sftoolgui:displayName_Residuals', hFitdev.FitName)));
            set(this.HExclusionPlot, 'DisplayName', getString(message('curvefit:sftoolgui:DisplayNameExcluded', hFitdev.FittingData.Name)));
            set(this.HValidationDataPlot, 'DisplayName', getString(message('curvefit:sftoolgui:displayName_ValidationResiduals', hFitdev.FitName)));
        end
        
        function plotValidationData(this)
            updatePlot(this);
            updateLegend(this, this.HFitFigure.LegendOn);
        end
        
        function dataUpdatedAction(this, ~, ~)
            % function dataUpdatedAction(this, source, event)
            updateLabels(this);
        end
        
        function createListeners(this )
                this.createListener( this.HFitFigure.HFitdev, 'FittingDataUpdated', @this.dataUpdatedAction );
                this.createListener( this.HFitFigure.HFitdev, 'ValidationDataUpdated', @this.dataUpdatedAction );
                this.createListener( this.AxesViewModel, 'LimitsChanged', @this.limitsChangedAction );
                this.createListener( this.HFitFigure.HFitdev, 'DimensionChanged',  @this.dimensionChangedAction );
                this.createListener( this.HAxes, 'RequestedLimits', @this.requestedLimitsPostSetAction );
        end
        
        function dimensionChangedAction(this, ~, ~)
            % function dimensionChangedAction(this, src, event)
            % dimensionChangedAction updates the axesViewController's
            % View2D property.
            this.AxesViewController.View2D = ...
                isCurveDataSpecified(this.HFitFigure.HFitdev.FittingData);
        end
        
        function tf = canGenerateCodeForPlot(this)
            % canGenerateCodeForPlot   True if code can be generated
            %
            %    canGenerateCodeForPlot( this ) returns true if code can be
            %    generated for residual plots and false otherwise. Code can
            %    be generated for residuals plots if the panel is visible.
            
            tf = strcmpi( this.Visible, 'on' );
        end
        
        function clearSurface(this)
            % clearSurface clears the plot when the curve or surface fit changes.
            
            setResidualData(this, [], [], []);
            setValidationResidualData(this, [], [], []);
            setExclusionData(this, [], [], []);
            setResidualLineForExclude(this, [], [], []);
        end
        
        function generateMCode( this, mcode )
            % GENERATEMCODE   Generate code for a Residuals Panel
            %
            %    GENERATEMCODE( H, CODE ) generates code for the given
            %    residuals panel, H, and adds it the code object CODE.
            hFitdev = this.HFitFigure.HFitdev;
            
            if isCurveDataSpecified( hFitdev.FittingData )
                cg = sftoolgui.codegen.CurveResidualPlotCodeGenerator();
                
                xValues = getValues( hFitdev.FittingData );
                cg.HasXData = ~isempty( xValues );
            else
                cg = sftoolgui.codegen.SurfaceResidualPlotCodeGenerator();
                [cg.View(1), cg.View(2)] = view( this.HAxes );
            end
            
            cg.FitName            = this.HFitFigure.HFitdev.FitName;
            cg.FittingDataName    = this.HFitFigure.HFitdev.FittingData.Name;
            cg.ValidationDataName = this.HFitFigure.HFitdev.ValidationData.Name;
            cg.HaveLegend         = ~isempty( legend( this.HAxes ) );
            cg.HaveExcludedData   = any( this.HFitFigure.HFitdev.Exclusions );
            cg.HaveValidation     = isValidationDataValid(this.HFitFigure.HFitdev);
            cg.GridState          = this.HFitFigure.GridState;
            generateMCode( cg, mcode );
        end
        
        function printToFigure( this, target )
            % printToFigure   Print a Residuals Panel to a figure
            %
            %   printToFigure( aResidualsPanel, target ) "prints" the contents of a Residuals
            %   Panel to the target (PrintToFigureTarget).
            %
            %   See also: curvefit.gui.PrintToFigureTarget
            target.addAxes( this.HAxes );
            target.add( 'Stem3', this.HResidualsPlot );
            target.add( 'Patch', this.HReferencePlot, 'Legendable', false );
            if any( this.HFitFigure.HFitdev.Exclusions );
                target.add( 'Stem3', this.HExclusionPlot );
            end
            if isValidationDataValid( this.HFitFigure.HFitdev );
                target.add( 'Stem3', this.HValidationDataPlot );
            end
            
            aLegend = legend( this.HAxes );
            if ~isempty( aLegend );
                target.addLegend( aLegend );
            end
        end
    end
    
    methods(Access = 'private')
        function createGraphics( this )
            % createGraphics   Create graphics (axes and children) for ResidualsPanel.
            
            % If the graphics haven't been created ...
            if ~this.Created
                % ... then create them all.
                this.Created = true;
                
                this.HAxes = sftoolgui.util.createAxes( this.HUIPanel, 'sftool residuals axes' );
                set( this.HAxes, 'NextPlot', 'add' );
                
                this.HResidualsLineForExclude = sftoolgui.util.lineForExclusion( this.HAxes, 'ResidualsLineForExclude' );
                
                this.HResidualsPlot      = iCreateResidualsPlot(  this.HAxes );
                this.HExclusionPlot      = iCreateExclusionPlot(  this.HAxes );
                this.HValidationDataPlot = iCreateValidationPlot( this.HAxes );
                
                % Plot the reference plane
                this.HReferencePlot = iCreateReferencePlane( this.HAxes );
                
                % Create an AxesViewController
                this.AxesViewController = sftoolgui.AxesViewController( ....
                    this.HAxes, this.AxesViewModel, ...
                    isCurveDataSpecified( this.HFitFigure.HFitdev.FittingData ) );
                
                % Plot the residuals
                plotResiduals( this );
                
                % Create Listeners
                createListeners(this);
                
                % Update the labels
                updateLabels( this );
                
            end
        end
        
        function requestedLimitsPostSetAction(this, ~, ~)
            % function requestedLimitsPostSetAction(this, source, event)
            % requestedLimitsPostSetAction sets AxesViewModel limits
            limits = get( this.HAxes, 'RequestedLimits' );
            xlim = limits{1};
            ylim = limits{2};
            zlim = limits{3};
            if isCurveDataSpecified( this.HFitFigure.HFitdev.FittingData )
                setLimits(this.AxesViewModel, {xlim}, [], ylim);
            else
                setLimits(this.AxesViewModel, {xlim, ylim}, [], zlim);
            end
        end
        
        function updateReferencePlane(this)
            % updateReferencePlane   Update the reference plan to span the limits of the
            % axes.
            xlim = get( this.HAxes, 'XLim' );
            
            % If curve data is specified ...
            if isCurveDataSpecified( this.HFitFigure.HFitdev.FittingData )
                % ... then we want the "plane" to look like a "line", so set Y to zeros.
                X = xlim;
                Y = zeros( size( X ) );
            else
                % ... For surfaces, we want to plot a reference plane over axes limits
                ylim = get( this.HAxes, 'YLim' );
                
                X = xlim([1,1,2,2,1]);
                Y = ylim([1,2,2,1,1]);
            end
            
            set( this.HReferencePlot, 'XData', X, 'YData', Y, 'ZData', zeros( size( X ) ) );
        end
        
        function updatePlot(this)
            if strcmpi(this.Visible, 'on')
                clearSurface(this);
                hFitdev = this.HFitFigure.HFitdev;
                fitObject = hFitdev.Fit;
                
                [resids, vResids] = getResiduals(hFitdev);
                % Nothing is plotting unless there is a valid fit.
                if ~isempty(fitObject)
                    if isCurveDataSpecified(hFitdev.FittingData)
                        plotCurveResiduals(this, resids, vResids)
                    else
                        plotSurfaceResiduals(this, resids, vResids)
                    end
                end
                updateDisplayNames(this);
            end
        end
        
        function plotCurveResiduals(this, resids, vResids)
            % Plot curve residuals
            hFitdev = this.HFitFigure.HFitdev;
            x = getCurveValues(hFitdev.FittingData);
            exclude = hFitdev.Exclusions;
            
            xInclude = x;
            xInclude(exclude) = NaN;
            yInclude = resids;
            yInclude(exclude) = NaN;
            setResidualData(this, xInclude, yInclude, []);
            
            xExclude = x;
            xExclude(~exclude) = NaN;
            yExclude = resids;
            yExclude(~exclude) = NaN;
            setExclusionData(this, xExclude, yExclude, []);
            
            setResidualLineForExclude(this, x, resids, []);
            
            if ~isempty(vResids)
                vx = getCurveValues(hFitdev.ValidationData);
                setValidationResidualData(this, vx, vResids, []);
            end
        end
        
        function plotSurfaceResiduals(this, resids, vResids)
            % Plot surface residuals
            
            hFitdev = this.HFitFigure.HFitdev;
            [x, y] = getValues(hFitdev.FittingData);
            exclude = hFitdev.Exclusions;
            
            xInclude = x;
            xInclude(exclude) = NaN;
            yInclude = y;
            yInclude(exclude) = NaN;
            residInclude = resids;
            residInclude(exclude) = NaN;
            setResidualData(this, xInclude, yInclude, residInclude);
            
            xExclude = x;
            xExclude(~exclude) = NaN;
            yExclude = y;
            yExclude(~exclude) = NaN;
            residExclude = resids;
            residExclude(~exclude) = NaN;
            setExclusionData(this, xExclude, yExclude, residExclude);
            
            setResidualLineForExclude(this, x, y, resids);
            
            if ~isempty(vResids)
                [vx, vy] = getValues(hFitdev.ValidationData);
                setValidationResidualData(this, vx, vy, vResids);
            end
        end
        
        function setResidualData(this, x, y, z)
            set(this.HResidualsPlot, ...
                'XData', x, ...
                'YData', y, ....
                'ZData', z);
        end
        
        function setExclusionData(this, x, y, z)
            set(this.HExclusionPlot, ...
                'XData', x, ...
                'YData', y, ....
                'ZData', z);
        end
        
        function setResidualLineForExclude(this, x, y, z)
            set(this.HResidualsLineForExclude, ...
                'XData', x, ...
                'YData', y, ....
                'ZData', z);
        end
        
        function setValidationResidualData(this, x, y, z)
            set(this.HValidationDataPlot, ...
                'XData', x, ...
                'YData', y, ...
                'ZData', z);
        end
        
        function limitsChangedAction(this, ~, ~)
            % function limitsChangedAction(this, source, event)
            % limitsChangedAction updates axes limits and the reference
            % plane
            updateLimits(this);
            
            % Save the current limit information
            resetplotview(this.HAxes, 'SaveCurrentViewLimitsOnly');
            
            % update the reference plane
            updateReferencePlane(this);
        end
        
        function updateLimits(this)
            % updateLimits updates the limits with AxesViewModel values.
            
            avm = this.AxesViewModel;
            
            xlim = avm.XInputLimits;
            if isCurveDataSpecified(this.HFitFigure.HFitdev.FittingData)
                ylim = avm.ResidualLimits ;
                zlim = [-1 1];
            else
                ylim = avm.YInputLimits;
                zlim = avm.ResidualLimits ;
            end
            
            set(this.HAxes, 'XLim', xlim, 'YLim', ylim, 'ZLim', zlim);
        end
    end
    
    methods(Access = 'protected')
        function postSetVisible( this )
            % postSetVisible   When the ResidualsPanels is made visible we need to ensure that
            % the graphics are created.
            postSetVisible@sftoolgui.Panel( this );
            if isequal( this.Visible, 'on' )
                createGraphics( this );
            end
        end
    end
end

function aStem = iCreateResidualsPlot(anAxes)
aStem = iCreateStem( anAxes, 'ResidualsPlot', 'inclusion' );
end

function aStem = iCreateExclusionPlot(anAxes)
aStem = iCreateStem( anAxes, 'ResidualsExclusionPlot', 'exclusion' );

aMarker = get( aStem, 'MarkerHandle' );
set( aStem, 'LineWidth', 0.5 );
set( aMarker, 'LineWidth', 1.5 );
end

function aStem = iCreateValidationPlot(anAxes)
aStem = iCreateStem( anAxes, 'ResidualsValidationPlot', 'validation' );
end

function aStem = iCreateStem( anAxes, tag, style )
aStem = stem3( [], [], [], 'Parent', anAxes, 'Tag', tag );

sftoolgui.util.MarkerStylist.style( aStem, style );

curvefit.gui.makeAutoLegendable( aStem );
end

function aPlane = iCreateReferencePlane(anAxes)

xlim = get( anAxes, 'XLim' );
ylim = get( anAxes, 'YLim' );

aPlane = patch( xlim([1,1,2,2,1]), ylim([1,2,2,1,1]), zeros( 1, 5 ), ...
    'Parent', anAxes, ...
    'FaceAlpha', 0.2, ...
    'FaceColor', [0.2, 0.2, 0.2], ...
    'HitTest', 'off' );

% Don't (ever) show the reference plane in the legend
curvefit.gui.setLegendable( aPlane, false );
end
