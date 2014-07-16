clc, clear all

dtu = load('results/optimize/DTUparamsTest.mat');
sift = load('results/optimize/fullsift_dogsift_test.mat');

pathTypes = 1:6;
[imNumKey,liNumKey,imNum,liNum,pathNames,pathX,pathXlabel] = dtuPaths('test');

setNum = 1:60;
% Number of images in each set
imgNum = sum(cellfun(@numel,imNum(pathTypes)) .* ...
    cellfun(@numel,liNum(pathTypes))) * numel(setNum);

% Generate indexing matrix
idx2spil = zeros(imgNum,4);

n = 0;
for s = setNum
    for p = pathTypes
        for i = imNum{p}
            for l = liNum{p}
                n = n+1;
                idx2spil(n,:) = [s,p,i,l];
            end
        end
    end
end

%% Stats

% Create a nicely formatted cell of confidence intervals
ci = cell(1,numel(pathTypes));
for p = pathTypes
    % Retrieve results for path from result matrix
    pIdx = idx2spil(:,2) == p;
    prGo = reshape(dtu.PR{1}(pIdx),[numel(liNum{p}) numel(imNum{p}) numel(setNum)]);
    prSift = reshape(sift.PR(pIdx,1),[numel(liNum{p}) numel(imNum{p}) numel(setNum)]);
    
    % Compute means based on number of lightings per image
    if numel(liNum{p}) > 1
        % Light path
        prGo = reshape(prGo,numel(liNum{p}),[]);
        prSift = reshape(prSift,numel(liNum{p}),[]);
    else
        % Viewpoint path (arc/linear)
        prGo = reshape(prGo,numel(imNum{p}),[]);
        prSift = reshape(prSift,numel(imNum{p}),[]);
    end
    
    % Compute confidence intervals
    ci{p} = zeros(size(prGo,1),2);
    for i = 1:size(prGo,1)
        [h,~,ci{p}(i,:)] = ttest(prGo(i,:),prSift(i,:));
    end
end

% Display results
for k = pathTypes % Generate figure for each image path
    if any(pathTypes == 1) && k == 1
        before = find(imNum{k} < imNumKey,1,'last');
    else
        before = 0;
    end
    x = pathX{k};

    width = ~mod(k,2) * 7.2 + mod(k,2) * 8;
    fig('width',width,'height',4.5,'unit','in','fontsize',10)
    hold on;
        
    if before ~= 0
        plot(x(1:before),ci{k}(1:before,1),'b-');
        plot(x(1:before),ci{k}(1:before,2),'b-');
        fillBetweenLines(x(1:before),ci{k}(1:before,1),ci{k}(1:before,2),[0.9 0.9 1])
    end
    
    plot(x(before+1:end),ci{k}(before+1:end,1),'b-');
    plot(x(before+1:end),ci{k}(before+1:end,2),'b-');
    fillBetweenLines(x(before+1:end),ci{k}(before+1:end,1),ci{k}(before+1:end,2),[0.9 0.9 1])
    
    padding = (x(end)-x(1))/20;
    plot([x(1)-padding x(end)+padding],[0 0],'k--')
    axis([x(1)-padding x(end)+padding -0.2 0.2]);
    xlabel(pathXlabel{k});
    if mod(k,2) == 1
        ylabel('PR AUC difference');
    end
    grid on;
    box on;
    export_fig('-r300',['../report/img/dtuResultsStats_' num2str(k) '.pdf']);
end

% disp('GO+SI vs SIFT:')
% for i = 1:6
%     idx = idx2spil(:,2) == i;
%     PRgosi = dtu.PR{5}(idx);
%     PRsift = sift.PR(idx,1);
%     [~,p,ci] = ttest(PRgosi,PRsift);
%     if mean(ci) > 0
%         disp([pathLabels{i} ': GO+SI wins with significance p = ' num2str(p,3)])
%     else
%         disp([pathLabels{i} ': SIFT wins with significance p = ' num2str(p,3)])
%     end
% end
% 
% disp('GO vs SIFT:')
% for i = 1:6
%     idx = idx2spil(:,2) == i;
%     PRgo = dtu.PR{1}(idx);
%     PRsift = sift.PR(idx,1);
%     [~,p,ci] = ttest(PRgo,PRsift);
%     if mean(ci) > 0
%         disp([pathLabels{i} ': GO wins with significance p = ' num2str(p,3)])
%     else
%         disp([pathLabels{i} ': SIFT wins with significance p = ' num2str(p,3)])
%     end
% end
% 
% disp('GO-SI vs GO:')
% for i = 1:6
%     idx = idx2spil(:,2) == i;
%     PRgosi = dtu.PR{5}(idx);
%     PRgo = dtu.PR{1}(idx);
%     [~,p,ci] = ttest(PRgosi,PRgo);
%     if mean(ci) > 0
%         disp([pathLabels{i} ': GO+SI wins with significance p = ' num2str(p,3)])
%     else
%         disp([pathLabels{i} ': GO wins with significance p = ' num2str(p,3)])
%     end
% end