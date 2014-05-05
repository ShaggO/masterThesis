function I = visualizeScaleSpaces(S,scales,range,border,P,validP)
%VISUALIZESCALESPACES Summary of this function goes here
%   Detailed explanation goes here

if nargin < 5
    P = zeros(0,4);
    validP = zeros(0,1);
end

idx = 1:3:numel(scales);
S = S(idx);

h = cellfun(@(x) size(x,1),S);
w = cellfun(@(x) size(x,2),S);

I = ones(h(1)-1,w(1)+1+w(2)) * border;

offset = [[0; 0; cumsum(h(2:end-1))'] [0; repmat(w(1)+1,numel(S)-1,1)]];

for i = 1:numel(S)
    I(offset(i,1)+(1:h(i)-1),offset(i,2)+(1:w(i)-1)) = S{i}(1:end-1,1:end-1);
end

imshow(I,range)

for i = 1:numel(S)
    PiValid = P(P(:,3) == idx(i) & validP,:);
    drawCircle(PiValid(:,1)+offset(i,2),PiValid(:,2)+offset(i,1),1,'g');
    PiInvalid = P(P(:,3) == idx(i) & ~validP,:);
    drawCircle(PiInvalid(:,1)+offset(i,2),PiInvalid(:,2)+offset(i,1),1,'r');
end

end