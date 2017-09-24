classdef Coalescer < curvefit.CoalescerInterface
    % Coalescer   Something that coalesce duplicate points
    
    %   Copyright 2011 The MathWorks, Inc.
    %   $Revision: 1.1.6.2 $  $Date: 2012/08/20 23:53:55 $
    
    methods
        function [X, z] = coalesce( ~, X, z )
            % Coalesce   Coalesce duplicate points
            %
            % Syntax:
            %   coalescer.coalesce( X, z )
            %
            % See also: curvefit.coalesceDuplicatePoints
            [X, z] = curvefit.coalesceDuplicatePoints( X, z );
        end
    end
end
