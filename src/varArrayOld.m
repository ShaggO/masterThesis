classdef varArrayOld<handle
    %VARARRAY Array with support for variable length dimensions
    
    properties
        data    % array data in an encompassing numerical array
        valid   % logical array denoting valid data
    end
    
    methods
        function x = get(obj,varargin)
            v = obj.valid(varargin{:});
            assert(all(v(:)),'Index out of range.')
            x = obj.data(varargin{:});
        end
        
        function [] = set(obj,x,varargin)
            if nargin < 3
                obj.valid = true(size(x));
                obj.data = x;
            else
                obj.valid(varargin{:}) = true(size(x));
                obj.data(varargin{:}) = x;
            end
        end
        
        function s = sum(obj,dim)
            s = sum(obj.valid .* obj.data,dim);
        end
        
        function p = prod(obj,dim)
            p = prod(obj.valid .* obj.data + ~obj.valid,dim);
        end
    end
    
end

