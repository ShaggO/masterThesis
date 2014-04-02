function vi = interweave( v1,v2 )
%INTERWEAVE Interweave two vectors of same type (matrix/cell) and length

assert(iscell(v1) == iscell(v2),'The two inputs must be the same type (matrix/cell)');

if iscell(v1) && iscell(v2)
    
    vi = cell(numel(v1)+numel(v2),1);
else
    vi = zeros(numel(v1)+numel(v2),1);
end
if size(v1,1) < size(v1,2)
    vi = vi';
end
vi(1:2:end) = v1;
vi(2:2:end) = v2;

end