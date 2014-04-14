function C = vector2cells(V,sizes)
%CELLS2VECTOR Converts a 1-dimensional array to a cell array of arrays.

offset = 0;
C = cell(1,size(sizes,1));
for i = 1:size(sizes,1)
    n = prod(sizes(i,:));
    C{i} = reshape(V(offset+(1:n)),sizes(i,:));
    offset = offset + n;
end

end

