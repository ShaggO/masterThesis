function [SposTrain, SnegTrain, SposTest, SnegTest] = inriaSplit(n,k,nWindows)
%DTUSPLITSETS Splits the INRIA training data into n parts. Optionally
%only retrieve the k'th split(s).

if nargin < 2
    k = 1:n;
end

rng(1,'combRecursive');

nPosTrain = 2416;
nNegTrain = 1218;
permPosTrain = randperm(nPosTrain)';
permNegTrain = randperm(nNegTrain)';

SposTest = [];
SnegTest = [];

for i = k
    SposTest = [SposTest; permPosTrain( ...
        floor((i-1)/n*nPosTrain)+1 : floor(i/n*nPosTrain))];
    SnegTest = [SnegTest; permNegTrain( ...
        floor((i-1)/n*nNegTrain)+1 : floor(i/n*nNegTrain))];
end

SposTrain = permPosTrain(~ismember(permPosTrain,SposTest));
SnegTrain = permNegTrain(~ismember(permNegTrain,SnegTest));

SnegTrain = repmat(nWindows * (SnegTrain'-1),[nWindows 1]) + ...
    repmat((1:nWindows)',[1 numel(SnegTrain)]);
SnegTrain = SnegTrain(:);

SnegTest = repmat(nWindows * (SnegTest'-1),[nWindows 1]) + ...
    repmat((1:nWindows)',[1 numel(SnegTest)]);
SnegTest = SnegTest(:);

end