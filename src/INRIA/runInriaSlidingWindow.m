clc, clear all

params = load('results/optimize/inriaParametersGoChosenSmall.mat');
test = load('results/inriaTestSvmGoChosenSmall.mat');
paths = load('paths');

params.method.detectorArgs = {'type','square','scales',2.^(0:0.1:2),'spacing',5};

% images = data.loadCache('negTestFull');
% I = images(1);
I.image = imread([paths.inriaDataSet '/Test/pos/person_204.png']);

[mFunc, mName] = parseMethod(params.method);
profile off, profile on
tic

data = inriaData;

[X,D] = inriaDescriptors(I,mFunc);

toc
profile off
% profile viewer

s = D * test.svm.w';
clear D;

save('results/inriaSlidingWindowCompactGo')

% t = -1;
% idx = s > t;

% figure
% imshow(I.image)
% hold on
% for i = find(idx)'
%     k = min((s(i)-t)/2,1)/2;
%     col = [0.5+k 0.5+k 0.5-k];
%     plot(ones(1,5)*X(i,1)+[-35 35 35 -35 -35]*X(i,3), ...
%         ones(1,5)*X(i,2)+[-67 -67 67 67 -67]*X(i,3),'color',col);
% end