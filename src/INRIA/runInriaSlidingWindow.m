clc, clear all

params = load('results/optimize/inriaParametersGoChosenSmall.mat');
test = load('results/inriaTestSvmGoChosenSmallFinal.mat');
% params = load('results/optimize/inriaParametersHog.mat');
% test = load('results/inriaTestSvmHogFinal.mat');
paths = load('paths');

 params.method.detectorArgs = {'type','square','scales',2.^(0:0.1:2),'spacing',5};

data = inriaData;
%images = data.loadCache('posTest');
I.image = imread([paths.inriaDataSet '/Test/pos/crop001573.png']);
%I.image = imread([paths.inriaDataSet '/test_64x128_H96/pos/person_293f.png']);

[mFunc, mName] = parseMethod(params.method);
profile off, profile on
tic

[X,D] = inriaDescriptors(I,mFunc);
% [L2,D2] = data.getDescriptors(params.method,false,'posTest',84,false);

%% Test on positive test data
%[LposTest,DposTest] = data.getDescriptors(params.method,false,'posTest','all',false);
%DposTest = sparse(double(DposTest));
%[~,~,probPos] = linearpredict(LposTest,DposTest,test.svm);

%[probPos test.probPos]

toc
profile off
% profile viewer

% s = D * test.svm.w'
% 
[~,~,s] = linearpredict(1,sparse(double(D)),test.svm)

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
