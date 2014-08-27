I = imread('../defence/img/pedestrians.png');
I = im2double(I);

stride = 41;
scales = [2 2^(4/3)];
wSize = [134,70];

F = windowDetector([size(I,1) size(I,2)],'square',scales,stride,wSize);

figure;
imshow(I);
set(gcf,'color','white');
hold on;
for i = 1:size(F,1)
    path = ['../defence/img/slidingWindow/position_' sprintf('%03d',i) '.png'];
    x = F(i,:);
    w = x(3)*[[-32 -32 32 32 -32]' [-64 64 64 -64 -64]'];
    h = plot(x(1)+w(:,1),x(2)+w(:,2),'y-','linewidth',3);
    drawnow;
    export_fig(gcf,path);
%    saveTightFigure(gcf,path);
    delete(h);
end
