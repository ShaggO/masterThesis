function v = normalize(v)
% L2-norm normalization of a vector

v = v/sqrt(sum(v .^ 2));

end

