classdef(Sealed) GriddataInterpolant < curvefit.model.SurfaceInterpolant
    % GriddataInterpolant   A surface interpolant that uses GRIDDATA
    %
    % Examples: Create biharmonic and cubic surface interpolants
    %   curvefit.model.GriddataInterpolant( 'Biharmonic', 'v4', X, z )
    %   curvefit.model.GriddataInterpolant( 'Cubic', 'cubic', X, z )
    %
    % See also: curvefit.model.SurfaceInterpolant
    
    %   Copyright 2011 The MathWorks, Inc.
    %   $Revision: 1.1.6.2 $  $Date: 2012/08/20 23:54:35 $
    
    properties(Access = private)
        % Method   GRIDDATA method (string) to use
        Method = '';
        % XYData  Interpolation sites (numPoints-by-2 array)
        XYData = zeros( 0, 2 )
        % ZData   Interpolation values (numPoints-by-2 array)
        ZData  = zeros( 0, 1)
    end
    
    methods 
        function this = GriddataInterpolant( type, method, X, z )
            % GriddataInterpolant   Create a GRIDDATA surface interpolant.
            %
            % Syntax:
            %   curvefit.model.GriddataInterpolant( type, method, X, z )
            %
            % Inputs:
            %   type - Either 'Biharmonic' or 'Cubic'.
            %   method - Method of GRIDDATA to use. Either 'v4' (for biharmonic) or 'cubic'.
            %   X - Interpolation sites (numPoints-by-2 array)
            %   z - Interpolation values (numPoints-by-1 array)
            this = this@curvefit.model.SurfaceInterpolant( type );
                        
            this.Method = method;
            this.XYData = X;
            this.ZData  = z;
        end
    end
    
    methods(Access = protected)
        function zi = doEvaluate( this, xi, yi )
            % doEvaluate   Evaluate surface interpolant.
            %
            % See also: curvefit.model.SurfaceInterpolant.doEvaluate
            x = this.XYData(:,1);
            y = this.XYData(:,2);
            z = this.ZData;
            
            zi = griddata( x, y, z, xi, yi, this.Method );  %#ok<GRIDD>
        end
    end
end

