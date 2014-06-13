clc, clear

svmPath{1} = 'results/inriaTestSvmGo';
svmPath{2} = 'results/inriaTestSvmSi';
svmPath{3} = 'results/inriaTestSvmGoSi';
svmPath{4} = 'results/inriaTestSvmHog';

plotInriaResults(svmPath{:})