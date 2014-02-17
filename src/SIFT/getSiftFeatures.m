function [X,D] = getSiftFeatures(I,EdgeThresh)
% Assumes a grayscale image normalized in the [0,255] interval

[F,D] = vl_sift(single(I),'EdgeThresh',EdgeThresh);

% figure
% imshow(I)
% hold on
% vl_plotsiftdescriptor(D,F);

X = F(1:2,:)';
D = D';

end