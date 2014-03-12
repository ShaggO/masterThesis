clc, clear all

setNum = 1;
imNum = 24;
liNum = 'diffuse';

peakThresholdDog = 5;
peakThresholdHarris = 5*10^4;

%method = methodStruct( ...
%   'vl',{'method','MultiscaleHarris','peakthreshold',peakThresholdHarris}, ...
%   'sift',{'colour','rgb'},{'go-'});
method = methodStruct( ...
   'dog',{'sigma',1,'k',2,'threshold',0.085},...
   'ghist',{'blockSize',[4 4],'cellSize',[4 4],'spatialSigma',[3 3],'binSigma',pi/8},{'co-'});

% method = methodStruct( ...
%    'vl',{'method','dog','peakthreshold',peakThresholdDog}, ...
%    'k-jet',{'k',5,'sigma',10.6,'domain','auto'},{'co-'});

% method = methodStruct( ...
%    'dog',{'sigma',10.6,'k',2,'threshold',0.01}, ...
%    'k-jet',{'k',5,'sigma',10.6,'domain','auto'},{'co-'});

t = 0.9;

[mFunc, mName] = parseMethod(method);
tic
profile on
match = imageCorrespondence(setNum,imNum,liNum,mFunc,mName);
profile off
profile viewer
plotAnalyseMatches(match,t);