function v = normalize(v,dim)
% L2-norm normalization of a vector

switch dim
    case 1
        v = v./repmat(sqrt(sum(v .^ 2,1)), [size(v,1) 1]);
    case 2
        v = v./repmat(sqrt(sum(v .^ 2,2)), [1 size(v,2)]);
end

