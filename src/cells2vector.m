function V = cells2vector(C)
%CELLS2VECTOR Converts a cell array of arrays to a 1-dimensional array

V = zeros(0,1);
for i = 1:numel(C)
    V = [V; C{i}(:)];
end

end

