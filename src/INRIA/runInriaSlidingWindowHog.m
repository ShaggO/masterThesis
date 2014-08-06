clc, clear all

params = load('results/optimize/inriaParametersHog.mat');
test = load('results/inriaTestSvmHogFinal.mat');
paths = load('paths');

% params.method.detectorArgs = {'type','square','scales',2.^(0:0.1:2),'spacing',1};
params.method.detectorArgs = {'type','square','scales',2.^(1.32:0.005:1.58),'spacing',1};

% I.image = imread([paths.inriaDataSet '/Test/pos/crop001573.png']);
I.image = imread('results/debugImage.png');

[mFunc, mName] = parseMethod(params.method);
profile off, profile on
tic

[X,D] = inriaDescriptors(I,mFunc);

toc
profile off
% profile viewer

s = D * test.svm.w';
clear D;

% save('results/inriaSlidingWindowHog')
save('results/debugImageHog')

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
