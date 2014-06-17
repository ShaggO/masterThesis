clc, clear

svmPath = {};

% svmPath{end+1} = 'results/inriaTestSvmGo';
% svmPath{end+1} = 'results/inriaTestSvmSi';
% svmPath{end+1} = 'results/inriaTestSvmGoSi';
% svmPath{end+1} = 'results/inriaTestSvmHog';

% svmPath{end+1} = 'results/inriaTestSvmGoNoHard';
% svmPath{end+1} = 'results/inriaTestSvmSiNoHard';
% svmPath{end+1} = 'results/inriaTestSvmGoSiNoHard';
% svmPath{end+1} = 'results/inriaTestSvmHogNoHard';
% svmPath{end+1} = 'results/inriaTestSvmHogDTNoHard';

svmPath{end+1} = 'results/inriaTestSvmGo100k';
svmPath{end+1} = 'results/inriaTestSvmSi100k';
svmPath{end+1} = 'results/inriaTestSvmGoSi100k';
svmPath{end+1} = 'results/inriaTestSvmHog100k';
svmPath{end+1} = 'results/inriaTestSvmHogDT100k';
labels = {'Go','Si','GoSi','HOG (UoCTTI)','HOG (DalalTriggs)'};

plotInriaResults(svmPath,labels);
