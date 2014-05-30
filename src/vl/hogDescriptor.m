function [X,D] = hogDescriptor(I,F,windowSize,cellsize,varargin)
%SIFTDESCRIPTORS Wrapper function for vl_hog

windowX = -(windowSize(2)-1)/2 : (windowSize(2)-1)/2;
windowY = -(windowSize(1)-1)/2 : (windowSize(1)-1)/2;

I = 255*I;
scales = unique(F(:,3))';
S = cell(size(scales));
for i = 1:numel(scales)
    S{i} = imresize(I,1/scales(i));
end
P = scaleSpaceFeatures(F,scales,1);

for i = 1:size(P,1)
    window = S{P(i,3)}(round(P(i,2)+windowY),round(P(i,1)+windowX));
    Di = vl_hog(window,cellsize,varargin{:});
    if i == 1
        D = zeros(size(P,1),numel(Di),'single');
    end
    D(i,:) = Di(:)';
end
X = F(:,1:2);

end