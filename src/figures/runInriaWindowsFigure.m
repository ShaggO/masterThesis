clc, clear all

params = load('results/optimize/inriaParametersGoSi'); % settings

data = inriaData(10,1*10^5);

[L,D] = data.getDescriptors(params.method,false,'negTestCutouts',1,false);