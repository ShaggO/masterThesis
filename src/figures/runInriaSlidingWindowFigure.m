clc, clear all

figure

names = {'Go','Hog'};
for j = 1:numel(names)
    load(['results/debugImage' names{j}])
    
    t = 1.5;
    idx = s > t;
    % idx = X(:,1) > 840 & X(:,1) < 850 & X(:,2) > 400 & X(:,2) < 410 & X(:,3) > 2.5 & X(:,3) < 2.8;
    s(idx)
    
    subplot(1,numel(names),j)
    imshow(I.image)
    hold on
    for i = find(idx)'
        k = max(min((s(i)-t)/1,1),0)/2;
        col = [0.5+k 0.5+k 0.5-k];
        plot(ones(1,5)*X(i,1)+[-35 35 35 -35 -35]*X(i,3), ...
            ones(1,5)*X(i,2)+[-67 -67 67 67 -67]*X(i,3),'color',col);
    end
end
