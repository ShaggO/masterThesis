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

% svmPath{end+1} = 'results/inriaTestSvmGo100k';
% svmPath{end+1} = 'results/inriaTestSvmSi100k';
% svmPath{end+1} = 'results/inriaTestSvmGoSi100k';
% svmPath{end+1} = 'results/inriaTestSvmHog100k';
% svmPath{end+1} = 'results/inriaTestSvmHogDT100k';

% svmPath{end+1} = 'results/inriaTestSvmGo100kSeed2';
% svmPath{end+1} = 'results/inriaTestSvmSi100kSeed2';
% svmPath{end+1} = 'results/inriaTestSvmGoSi100kSeed2';
% svmPath{end+1} = 'results/inriaTestSvmHog100kSeed2';
% svmPath{end+1} = 'results/inriaTestSvmHogDT100kSeed2';

% svmPath{end+1} = 'results/inriaTestSvmGo100k_30_seed1';
% svmPath{end+1} = 'results/inriaTestSvmSi100k_30_seed1';
% svmPath{end+1} = 'results/inriaTestSvmGoSi100k_30_seed1';
% svmPath{end+1} = 'results/inriaTestSvmHog100k_30_seed1';
% svmPath{end+1} = 'results/inriaTestSvmHogDT100k_30_seed1';

% svmPath{end+1} = 'results/inriaTestSvmGoFinal10';
% svmPath{end+1} = 'results/inriaTestSvmSiFinal10';
% svmPath{end+1} = 'results/inriaTestSvmGoSiFinal10';
% svmPath{end+1} = 'results/inriaTestSvmHogFinal';
% svmPath{end+1} = 'results/inriaTestSvmHogDTFinal';

svmPath{end+1} = 'results/inriaTestSvmGoFinal';
svmPath{end+1} = 'results/inriaTestSvmSiFinal';
svmPath{end+1} = 'results/inriaTestSvmGoSiFinal';
svmPath{end+1} = 'results/inriaTestSvmHogFinal';

svmPath{end+1} = 'results/inriaTestSvmGoChosenSmall';
svmPath{end+1} = 'results/inriaTestSvmGoChosenBig';
svmPath{end+1} = 'results/inriaTestSvmHogColourFinal';


% svmPath{end+1} = 'results/inriaTestSvmGoTriangleFinal';
% svmPath{end+1} = 'results/inriaTestSvmSiTriangleFinal';
% svmPath{end+1} = 'results/inriaTestSvmGoSiFinal';

% labels = {'Go','Si','GoSi','HOG (UoCTTI)','HOG (DalalTriggs)', ...
%     'Go 30pw train','Si 30k train','GoSi 30k train','HOG (UoCTTI) 30k train','HOG (DalalTriggs) 30k train'};
% labels = {'Go (old params)','Si (old params)','GoSi (old params)','HOG (UoCTTI)','HOG (DalalTriggs)', ...
%     'Go','Si','GoSi','HOG (UoCTTI)','HOG (DalalTriggs)'};
labels = {'GO','SI','GO+SI','HOG','GO (4185)','GO (5355)'};
plotInriaResults(svmPath,labels);
