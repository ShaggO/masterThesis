clc, clear

svmPath = {};

% svmPath{end+1} = 'results/inriaTestSvmGo';
% svmPath{end+1} = 'results/inriaTestSvmSi';
% svmPath{end+1} = 'results/inriaTestSvmGoSi';
% svmPath{end+1} = 'results/inriaTestSvmHog';

svmPath{end+1} = 'results/inriaTestSvmGo100k';
svmPath{end+1} = 'results/inriaTestSvmSi100k';
svmPath{end+1} = 'results/inriaTestSvmGoSi100k';
svmPath{end+1} = 'results/inriaTestSvmHog100k';

plotInriaResults(svmPath{:})