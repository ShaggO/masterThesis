clc, clear all

setNum = 1;
imNum = 1;
liNum = 1;
peakThreshold = 5*10^4;
% method = methodStruct( ...
%    'vl',{'method','MultiscaleHarris','peakthreshold',peakThreshold}, ...
%    'sift',{'colour','rgb'},{'go-'});

method = methodStruct( ...
   'vl',{'method','dog','peakthreshold',5}, ...
   'k-jet',{'k',5,'sigma',1,'domain','spatial'},{'co-'});

t = 0.99;

[mFunc, mName] = parseMethod(method);
mDir = ['DTU/results/' mName];
tic
match = imageCorrespondence(setNum,imNum,liNum,mFunc,mDir);
plotAnalyseMatches(match,t);