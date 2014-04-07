function [X,D] = fullSiftDescriptor(I,varargin)
%SIFTDESCRIPTORS Wrapper function for vl_sift

[X,D] = vl_sift(255*rgb2gray(I),varargin{:});
X = X(1:2,:)';
D = D';

end
