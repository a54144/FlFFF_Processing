classdef SurfaceInterpolantFactory < curvefit.Handle
    % SurfaceInterpolantFactory   Factory to create surface interpolants
    %
    % Example
    %   factory = curvefit.model.SurfaceInterpolantFactory();
    %   interpolant = factory.create( 'linearinterp', X, z );
    %
    % See also: curvefit.model.SurfaceInterpolant.
    
    %   Copyright 2011 The MathWorks, Inc.
    %   $Revision: 1.1.6.2 $  $Date: 2012/08/20 23:54:37 $
    
    properties(Access = private)
        % WarningThrower   Something that throws warnings (curvefit.attention.Thrower)
        WarningThrower = [];
        % ErrorThrower   Something that throws errors (curvefit.attention.Thrower)
        ErrorThrower = [];
        % Coalescer   Something that coalesces similar points (curvefit.CoalescerInterface)
        Coalescer = [];
    end
    methods
        function factory = SurfaceInterpolantFactory( varargin )
            % SurfaceInterpolantFactory   Create a factory for surface interpolants.
            %
            % Syntax:
            %   factory = SurfaceInterpolantFactory( ... )
            %
            % Parameter-value pairs:
            %   'WarningThrower' = An instance of curvefit.attention.Thrower that will be
            %      asked to throw warnings (if any).
            %   'ErrorThrower' = An instance of curvefit.attention.Thrower that will be
            %      asked to throw errors (if any)..
            %   'Coalescer' = An instance of curvefit.CoalescerInterface that will be
            %      asked to coalesce similar points.
            %
            % See also: create
            parseParameterValuePairs( factory, varargin{:} );
            
            % Set default values where needed
            if isempty( factory.WarningThrower )
                factory.WarningThrower = curvefit.attention.Warning();
            end
            if isempty( factory.ErrorThrower )
                factory.ErrorThrower = curvefit.attention.Error();
            end
            if isempty( factory.Coalescer )
                factory.Coalescer = curvefit.Coalescer();
            end
        end
        
        function anInterpolant = create( factory, type, X, z )
            % create   Create a Surface Interpolant
            %
            % Syntax:
            %   interpolant = factory.create( type, X, z )
            %
            % Inputs:
            %   type = The type of interpolant to create. One of 'linearinterp',
            %       'nearestinterp', 'cubicinterp', 'biharmonicinterp'.
            %   X = Array (numPoints-by-2) of interpolation sites.
            %   z = Vector (numPoints-by-1) of interpolation values.
            %
            % Outputs:
            %   interpolant = A surface interpolant (curvefit.model.SurfaceInterpolant)
            %
            %   If there is an error creating the interpolant then output will be empty
            %   (unless the ErrorThrower actually throws a MATLAB error).
            % 
            % See also: curvefit.model.SurfaceInterpolant.
           
            % For backward compatibility, the following values for type are also supported:
            %   'linear', 'nearest', 'cubic', 'v4'.
            
            [X, z] = factory.doCoalesceDuplicatePoints( X, z );
            
            switch type
                case {'linearinterp', 'linear'}
                    anInterpolant = factory.createTriangleSurfaceInterpolant( 'Linear', 'linear', X, z );
                    
                case {'nearestinterp', 'nearest'}
                    anInterpolant = factory.createTriangleSurfaceInterpolant( 'Nearest Neighbor', 'nearest', X, z );
                    
                case {'cubicinterp', 'cubic'}
                    anInterpolant = curvefit.model.GriddataInterpolant( 'Cubic', 'cubic', X, z );
                    
                case {'biharmonicinterp', 'v4'}
                    anInterpolant = curvefit.model.GriddataInterpolant( 'Biharmonic', 'v4', X, z );
                    
                otherwise
                    factory.ErrorThrower.throw( message( 'curvefit:model:SurfaceInterpolantFactory:UnknownTypeToCreate' ) );
            end
        end
    end
    
    methods(Hidden)
        function anInterpolant = load( factory, interpolantToLoad )
            % load   Load a interpolant from an old form to the contemporary form.
            %
            % Syntax:
            %   factory.load( anInterpolant )
            %
            % Inputs:
            %   anInterpolant should be one of:
            %       1. An instance of curvefit.model.SurfaceInterpolant 
            %       2. A structure with fields 'Method', 'XData', YData' and 'ZData'. This
            %       structure was used for surface interpolants in R2011b and earlier.
            if isstruct( interpolantToLoad )
                % Create an interpolant from the structure
                anInterpolant = factory.interpolantFromStructure( interpolantToLoad );
                
            elseif isa( interpolantToLoad, 'curvefit.model.SurfaceInterpolant' );
                % Return the given interpolant
                anInterpolant = interpolantToLoad;
                
            else
                factory.ErrorThrower.throw( message( 'curvefit:model:SurfaceInterpolantFactory:UnknownTypeToLoad' ) );
            end
        end
    end
    
    methods(Access = private)
        function parseParameterValuePairs( factory, varargin )
            % parseParameterValuePairs   Parse the parameter value pairs for the constructor.
            for i = 1:2:length( varargin )
                if ~ischar( varargin{i} )
                    error( message( ...
                        'curvefit:model:SurfaceInterpolantFactory:ParameterNameNotString', ...
                        int2str( i ) ) );
                end
                switch varargin{i}
                    case 'WarningThrower'
                        factory.WarningThrower = varargin{i+1};
                    case 'ErrorThrower'
                        factory.ErrorThrower = varargin{i+1};
                    case 'Coalescer'
                        factory.Coalescer = varargin{i+1};
                    otherwise
                        error( message( ...
                            'curvefit:model:SurfaceInterpolantFactory:UnknownParameter', ...
                            varargin{i} ) );
                end
            end
        end
        
        function anInterpolant = createTriangleSurfaceInterpolant( factory, type, method, X, z )
            % createTriangleSurfaceInterpolant   Create a TriangleSurfaceInterpolant.
            dt = DelaunayTri( X );
            
            if isempty( iGetDelaunayTriangles( dt ) )
                factory.ErrorThrower.throw( message( 'curvefit:fit:EmptyTriangles' ) );
                anInterpolant = [];
            else
                anInterpolant = curvefit.model.TriangleSurfaceInterpolant( type, method, dt, z );
            end
        end
        
        function [X, z] = doCoalesceDuplicatePoints( factory, X, z )
            % doCoalesceDuplicatePoints   Coalesce duplicate points and throw a warning if
            % there are duplicates.
            numBefore = size( X, 1 );
            [X, z] = factory.Coalescer.coalesce( X, z );
            numAfter = size( X, 1 );
            if numBefore > numAfter
                factory.WarningThrower.throw( message( 'curvefit:fit:DuplicateDataPoints' ) );
            end
        end
        
        function anInterpolant = interpolantFromStructure( factory, pp )
            % interpolantFromStructure   Create an interpolant from a structure
            %
            % The input, pp, should be a structure with fields 'Method', 'XData', YData' and
            % 'ZData'. This structure was used for surface interpolants in R2011b and
            % earlier.
            
            % Try to get the required fields from the structure ...
            try
                method = pp.Method;
                X = [pp.XData, pp.YData];
                z = pp.ZData;
            catch ignore  %#ok<NASGU>
                % ... and if we can't, then throw an error.
                factory.ErrorThrower.throw( message( 'curvefit:model:SurfaceInterpolantFactory:UnknownStructureToLoad' ) );
                anInterpolant = [];
                return
            end
            
            % Create the interpolant from the information pulled from the structure
            anInterpolant = factory.create( method, X, z );
        end
    end
end

function triangles = iGetDelaunayTriangles( dt )
% iGetDelaunayTriangles   Get triangle from a Delaunay triangulation.

% Need to suppress a possible EmptyTri2DWarnId warning.
warningState = warning( 'off', 'MATLAB:TriRep:EmptyTri2DWarnId' );
warningCleanup = onCleanup( @() warning( warningState ) );

triangles = dt.Triangulation ;
end

