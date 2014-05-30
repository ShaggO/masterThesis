function [X,D] = fullHogDescriptor(I,cellsize,varargin)
%SIFTDESCRIPTORS Wrapper function for vl_hog

windowSize = [134 70];
windowX = -(windowSize(2)-1)/2 : (windowSize(2)-1)/2;
windowY = -(windowSize(1)-1)/2 : (windowSize(1)-1)/2;

scales = 1;
F = windowDetector(size(I),'square',scales,8,windowSize);

I = 255*rgb2gray(I);

for i = 1:size(F,1)
    window = I(F(i,2)+windowY,F(i,1)+windowX);
    Di = vl_hog(window,cellsize,varargin{:});
    if i == 1
        D = zeros(size(F,1),numel(Di),'single');
    end
    D(i,:) = Di(:)';
end
X = F(:,1:2);

end