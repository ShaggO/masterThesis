function visualizeScaleSpaces(S,scales,range,cmap,cbLabel,P,validP,outline)
%VISUALIZESCALESPACES Summary of this function goes here
%   Detailed explanation goes here

if nargin < 6
    P = zeros(0,4);
    validP = zeros(0,1);
end
if nargin < 8
    outline = false;
end

circRadius = 1.1;

idx = 4:3:numel(scales);
S = S(idx);
% P(:,1:2) = round(P(:,1:2));

h = cellfun(@(x) size(x,1),S);
w = cellfun(@(x) size(x,2),S);

I = zeros(h(1)-1,w(1)+w(2)-1);
Isize = size(I);
Ialpha = true(Isize);

offset = [[0; 0; cumsum(h(2:end-1))'] [0; repmat(w(1),numel(S)-1,1)]];

for i = 1:numel(S)
    I(offset(i,1)+(1:h(i)-1),offset(i,2)+(1:w(i)-1)) = S{i}(1:end-1,1:end-1);
    Ialpha(offset(i,1)+(1:h(i)-1),offset(i,2)+(1:w(i)-1)) = false;
end

colorMapImshow(I,cmap,range,Ialpha,cbLabel);
% imshow(I,range);
% set(hdl, 'AlphaData', ~Ialpha)
hold on
% rectangle('position',[1/2,1/2,1/2,1/2],'facecolor','w','edgecolor','w')
% [X,Y] = find(Ialpha);
% for i = 1:numel(X)
%     rectangle('position',[Y(i)-0.6,X(i)-0.6,1.2,1.2],'facecolor','w','edgecolor','none')
% end
if outline
    [X,Y] = find(bwperim(I > 0) & ~Ialpha);
    plot(Y,X,'y.','markersize',2)
end

for i = 1:numel(S)
    PiValid = P(P(:,3) == idx(i) & validP,:);
    drawCircle(PiValid(:,1)+offset(i,2),PiValid(:,2)+offset(i,1),circRadius,'g');
    PiInvalid = P(P(:,3) == idx(i) & ~validP,:);
    drawCircle(PiInvalid(:,1)+offset(i,2),PiInvalid(:,2)+offset(i,1),circRadius,'r');
end

end