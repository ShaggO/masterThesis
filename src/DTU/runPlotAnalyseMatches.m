clc, clear all

setNum = 1;
imNum = 12;
liNum = 'diffuse';

peakThresholdDog = 5;
peakThresholdHarris = 2*10^4;

% method = methodStruct( ...
%    'vl',{'method','MultiscaleHarris','peakthreshold',peakThresholdHarris}, ...
%    'sift',{'colour','rgb'},{'go-'});

method = methodStruct( ...
   'vl',{'method','dog','peakthreshold',peakThresholdDog}, ...
   'k-jet',{'k',3,'sigma',10.6,'domain','auto'},{'co-'});

t = 0.99;

[mFunc, mName] = parseMethod(method);
mDir = ['DTU/results/' mName];
tic
match = imageCorrespondence(setNum,imNum,liNum,mFunc,mDir);
plotAnalyseMatches(match,t);