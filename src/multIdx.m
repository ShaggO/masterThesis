function x = multIdx(x,varargin)
%MULTIDX Multiple successive indexing.

for i = 1:numel(varargin)
    x = x(varargin{i});
end

end