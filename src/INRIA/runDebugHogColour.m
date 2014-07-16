% clc, clear

load paths
inria = load([inriaDataSet '/inriaPosTrain']);
I = im2single(inria.images(1).image);

params = load('results/optimize/inriaParametersHog.mat');
params.method = modifyDescriptor(params.method,'colour','none');

mFunc = parseMethod(params.method);

[~,Dnone] = mFunc(I,'','',false);