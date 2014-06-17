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

svmPath{end+1} = 'results/inriaTestSvmGo100kSeed2';
svmPath{end+1} = 'results/inriaTestSvmSi100kSeed2';
svmPath{end+1} = 'results/inriaTestSvmGoSi100kSeed2';
svmPath{end+1} = 'results/inriaTestSvmHog100kSeed2';
svmPath{end+1} = 'results/inriaTestSvmHogDT100kSeed2';

labels = {'Go','Si','GoSi','HOG (UoCTTI)','HOG (DalalTriggs)', ...
    'Go seed 2','Si seed 2','GoSi seed 2','HOG (UoCTTI) seed 2','HOG (DalalTriggs) seed 2'};
plotInriaResults(svmPath,labels);