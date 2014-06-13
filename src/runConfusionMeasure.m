clc, clear

n = 10^6;
% rng(1,'combRecursive')
groundTruth = (-1).^randi(2,n,1);
prob = rand(n,1);
% prob = floor(10*rand(n,1))/10;

profile off, profile on
[ROC, PR] = confusionMeasure(groundTruth,prob);
profile off
profile viewer

% old = load('oldConfusion');
% 
% figure
% plot(old.ROC(:,1),old.ROC(:,2),'b-')
% hold on
% plot(ROC(:,1),ROC(:,2),'r-')
% 
% all(PR(:) == old.PR(:))
% all(ROC(:) == old.ROC(:))