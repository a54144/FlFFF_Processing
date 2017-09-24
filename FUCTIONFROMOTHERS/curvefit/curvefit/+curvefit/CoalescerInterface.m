classdef CoalescerInterface
    % CoalescerInterface   Interface for things that coalesce duplicate points
    
    %   Copyright 2011 The MathWorks, Inc.
    %   $Revision: 1.1.6.2 $  $Date: 2012/08/20 23:53:56 $
    
    methods(Abstract)
        % Coalesce duplicate points
        [X, z] = coalesce( this, X, z )
    end
end
