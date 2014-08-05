clc, clear all

load('results/inriaSlidingWindowCompactGo')

t = -0.5;
idx = s > t;

figure
imshow(I.image)
hold on
for i = find(idx)'
    k = min((s(i)-t)/1,1)/2;
    col = [0.5+k 0.5+k 0.5-k];
    plot(ones(1,5)*X(i,1)+[-35 35 35 -35 -35]*X(i,3), ...
        ones(1,5)*X(i,2)+[-67 -67 67 67 -67]*X(i,3),'color',col);
end