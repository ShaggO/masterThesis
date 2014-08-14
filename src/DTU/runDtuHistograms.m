clc, clear all

dtu = load('results/optimize/DTUparamsTestFinalOpponent.mat');
sift = load('results/optimize/dogsift_opponent_test.mat');

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

names = {'Go','Si','GoSi','Sift'};
data = {dtu.PR{1},dtu.PR{2},dtu.PR{3},sift.PR};
%data = {dtu.ROC{1},dtu.ROC{2},dtu.ROC{3},sift.ROC(:,1)};
combinations = [1 4;2 4;3 4]';
combinations = [3 4]';
exportFigures = false;

%% Stats
pathTypes = 1:6;

for combination = combinations
% Create a nicely formatted cell of confidence intervals
ci = cell(1,numel(pathTypes));
for p = pathTypes
    % Retrieve results for path from result matrix
    pIdx = idx2spil(:,2) == p;
    prData1 = reshape(data{combination(1)}(pIdx),[numel(liNum{p}) numel(imNum{p}) numel(setNum)]);
    prData2 = reshape(data{combination(2)}(pIdx),[numel(liNum{p}) numel(imNum{p}) numel(setNum)]);
    
    % Compute means based on number of lightings per image
    if numel(liNum{p}) > 1
        % Light path
        prData1 = reshape(prData1,numel(liNum{p}),[]);
        prData2 = reshape(prData2,numel(liNum{p}),[]);
    else
        % Viewpoint path (arc/linear)
        prData1 = reshape(prData1,numel(imNum{p}),[]);
        prData2 = reshape(prData2,numel(imNum{p}),[]);
    end
    
%     % Compute confidence intervals
%     ci{p} = zeros(size(prData1,1),2);
%     for i = 1:size(prData1,1)
%         [h,~,ci{p}(i,:)] = ttest2(prData1(i,:),prData2(i,:),'vartype','unequal');
%     end

    figure
    hist(reshape(prData1,[],1),20)
end

end