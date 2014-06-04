function [X,D] = siftDescriptor(I,F,varargin)
%SIFTDESCRIPTORS Wrapper function for vl_sift

F = double(F);
[X,D] = vl_sift(255*I,'frames',F(:,1:4)',varargin{:});
X = X(1:3,:)';
D = D';

end
