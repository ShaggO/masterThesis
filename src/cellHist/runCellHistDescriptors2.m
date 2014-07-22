clc, clear all

load('results/optimize/inriaParametersGo.mat')
% method = modifyDescriptor(method,'gridSize',4,'cellFilter','triangle');
% method = modifyDescriptor(method,'cellSigma',[10 10]);
% method = modifyDescriptor(method,'colour','none');
method = modifyDescriptor(method,'smooth',true);

[mFunc, mName] = parseMethod(method);
profile off, profile on
tic

data = inriaData;
images = data.loadCache('posTest');
[X,D] = inriaDescriptors(images(1),mFunc);

toc
profile off
% profile viewer