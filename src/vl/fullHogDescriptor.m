function [X,D] = fullHogDescriptor(I,cellsize,varargin)
%SIFTDESCRIPTORS Wrapper function for vl_hog

D = vl_hog(255*rgb2gray(I),cellsize,varargin{:});
D = D(:)';
X = ([size(I,2) size(I,1)]+1)/2; % set feature point to image center

end