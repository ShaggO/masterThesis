function [X,D] = getSiftFeatures(I)
% Assumes a grayscale image normalized in the [0,255] interval

[F,D] = vl_sift(single(I));
X = F(1:2,:)';
D = D';

end