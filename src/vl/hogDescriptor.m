function [X,D] = hogDescriptor(I,F,windowSize,cellsize,varargin)
%SIFTDESCRIPTORS Wrapper function for vl_hog

windows = extractWindows(255*I,F,windowSize);

for i = 1:size(F,1)
    Di = vl_hog(windows{i},cellsize,varargin{:});
    if i == 1
        D = zeros(size(F,1),numel(Di),'single');
    end
    D(i,:) = Di(:)';
end
X = F(:,1:3);

end