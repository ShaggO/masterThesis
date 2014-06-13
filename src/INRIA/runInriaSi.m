clc, clear all

windowSize = [134 70];

load('paths');

name = 'Si';
load(['results/optimize/inriaParameters' name]); % SI settings

profile off,profile on
totalTime = tic;
svmPath = inriaTestSvm(method,svmArgs,true);
totalTime = toc(totalTime)
profile off
% profile viewer

% plotInriaResults(svmPath,svmPath2)
clear data;
save(['results/optimize/inriaParameters' name]);
