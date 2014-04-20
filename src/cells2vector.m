function V = cells2vector(C,dims)
%CELLS2VECTOR Converts a cell array of arrays to a 1-dimensional array
% Input:
%   C       Cell array of arrays
%   dims    Number of dimensions of output

if nargin < 2
    dims = 1;
end

V = [];
for i = 1:numel(C)
    if dims == 1
        V = [V; C{i}(:)];
    else
        sizeCi = num2cell(size(C{i}));
        reshapeArgs = sizeCi(2:dims);
        V = [V; reshape(C{i},[],reshapeArgs{:})];
    end
end

end