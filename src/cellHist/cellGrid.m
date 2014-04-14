classdef cellGrid
    %CELLGRID Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        V
        Wcenter
    end
    
    properties(Dependent)
        weightedVals
        test
    end
    
    methods
        function X = get.weightedVals(obj)
            X = obj.V .* obj.Wcenter;
        end
        
        function X = get.test(obj)
            X = obj.weightedVals * 2;
        end
        
        function X = test2(obj)
            X = obj.weightedVals * 2;
        end
    end
    
end

