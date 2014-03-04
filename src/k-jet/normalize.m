function v = normalize(v,dim)
% L2-norm normalization of a vector

len = sqrt(sum(v .^ 2,dim));
if len > 0
    switch dim
        case 1
            v = v./repmat(len, [size(v,1) 1]);
        case 2
            v = v./repmat(len, [1 size(v,2)]);
    end
end