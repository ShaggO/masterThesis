function V = cells2vector(C)
%CELLS2VECTOR Converts a cell array of arrays to a 1-dimensional array

V = [];
for i = 1:numel(C)
    V = [V; C{i}(:)];
end

end

