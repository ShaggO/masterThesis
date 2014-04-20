classdef varArray<handle
    %VARARRAY Array with support for variable length dimensions
    
    properties
        data    % data{i} is a part of the array with same dimensions
        sizes   % sizes(i,:) is the size of data{i}
        map     % map(j) is the array part for constant index j
    end
    
    properties(Dependent)
        varDims % number of variable length dimensions
        conSize % size of constant length dimensions
        parts   % number of array parts
    end
    
    methods
%         function n = get.varDims(obj)
%             n = size(obj.sizes,2)-numel(size(obj.map));
%         end
        
%         function n = get.conSize(obj)
%             n = size(obj.map);
%         end
        
%         function n = get.parts(obj)
%             n = size(obj.sizes,1);
%         end
        
%         function obj = add(obj,data,varargin)
%             mask = false([obj.conSize 1]);
%             mask(varargin{:}) = true;
%             sz = size(data);
%             sz = sz(1:obj.varDims);
%             [~,i] = ismember(sz,obj.sizes(1:end-1));
%             I = obj.map(mask);
%             assert(all(I(:) == 0),'This constant index is already set.')
%             if i > 0
%                 % add to current array part
%                 oldMask = obj.map == i;
%                 or = oldMask | mask;
%                 varInd = repmat({':'},[1 obj.varDims]);
%                 obj.data{i}(varInd{:},oldMask(or)) = obj.data{i};
%                 obj.data{i}(varInd{:},mask(or)) = data;
%             else
%                 % create new array part
%                 i = size(obj.sizes,1)+1;
%                 obj.data{i} = data;
%             end
%             obj.sizes(i,:) = size(obj.data{i});
%             obj.map(mask) = i;
%         end
        
        % Get data part i
        function [data,mask] = partData(obj,i)
            data = obj.data{i};
            mask = obj.map == i;
        end
        
        % Lookup data values from map indices
        function x = lookup(obj,varargin)
            mapIdx = reshape(1:numel(obj.map),size(obj.map));
            mapIdx = mapIdx(varargin{:}); mapIdx = mapIdx(:);
            i = obj.map(mapIdx);
            assert(all(i-i(1) == 0),'All indices must have the same size.')
            [D,mask] = obj.partData(i(1));
            dataIdx = zeros(size(mask));
            dataIdx(mask) = 1:sum(mask(:));
            x = D(dataIdx(mapIdx(:)),:);
        end
        
        % Convert to vector
        function V = vector(obj)
            V = cells2vector(obj.data);
        end
    end
    
    %% Constructors
    methods(Static)
        function A = newEmpty(varDims,conSize)
            A = varArray;
            A.sizes = zeros(0,varDims+1);
            A.map = zeros([conSize 1]);
        end
    end
    
    methods(Static)
        function A = newFull(data,sizes,map)
            A = varArray;
            A.data = data;
            A.sizes = sizes;
            A.map = map;
        end
    end
    
    methods(Static)
        function A = newVector(dataVector,sizes,map)
            A.data = vector2cells(dataVector,sizes);
            A.sizes = sizes;
            A.map = map;
        end
    end
end

