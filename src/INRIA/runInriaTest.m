clc, clear all

method = methodStruct( ...
    '',{}, ...
    'full-hog',{}, ...
    0,{'rx-'});

totalTime = tic;
[Lsvm, acc, P] = inriaTest(method);
totalTime = toc(totalTime)