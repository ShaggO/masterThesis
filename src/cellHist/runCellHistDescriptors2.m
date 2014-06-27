clc, clear all

load('results/optimize/inriaParametersGo.mat')

[mFunc, mName] = parseMethod(method);
profile off, profile on
tic

data = inriaData;
images = data.loadCache('posTest');
[X,D] = inriaDescriptors(images(1),mFunc);

toc
profile off
% profile viewer
