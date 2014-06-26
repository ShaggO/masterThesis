function windows = extractWindows(I,F,windowSize)

windowX = -(windowSize(2)-1)/2 : (windowSize(2)-1)/2;
windowY = -(windowSize(1)-1)/2 : (windowSize(1)-1)/2;

scales = unique(F(:,3))';
S = cell(size(scales));
for i = 1:numel(scales)
    S{i} = imresize(I,1/scales(i));
%     figure
%     imshow(S{i})
end
P = scaleSpaceFeatures(F,scales,1);

windows = cell(size(P,1),1);
for i = 1:size(P,1)
    windows{i} = S{P(i,3)}(round(P(i,2)+windowY),round(P(i,1)+windowX),:);
end

end