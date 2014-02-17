function dist = featureDist(d1, d2)
% Distance between two features

dist = sum((d2 - d1) .^ 2);
dist = sqrt(dist);

end

