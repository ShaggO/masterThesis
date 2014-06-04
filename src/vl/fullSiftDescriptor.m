function [X,D] = fullSiftDescriptor(I,varargin)
%SIFTDESCRIPTORS Wrapper function for vl_sift

I = 255*rgb2gray(I);

[X,D] = vl_sift(I,varargin{:});
X = X(1:3,:)';
D = D';

end
