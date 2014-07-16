clc, clear all

windowSize = [134 70];

load('paths');

name = 'Go';
load(['results/optimize/inriaParameters' name]); % SI settings

method = modifyDescriptor(method,'gridSize',1.74,'binCount',9);

profile off,profile on
totalTime = tic;
svmPath = inriaTestSvm(method,svmArgs,true);
totalTime = toc(totalTime)
profile off
% profile viewer

% plotInriaResults(svmPath,svmPath2)
clear data;
save(['results/optimize/inriaParameters' name 'ChosenBig']);
copyfile(svmPath,['results/inriaTestSvm' name 'ChosenBig']);
