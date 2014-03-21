function [X,D] = siftDescriptors(I,F)
%SIFTDESCRIPTORS Wrapper function to vl_sift

[X,D] = vl_sift(single(255 * I),'frames',F(:,1:4)');
X = X(1:2,:)';
D = D';

end
