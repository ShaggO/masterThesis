function [Spos, Sneg] = inriaSplit(n,k)
%DTUSPLITSETS Splits the INRIA training data into n parts. Optionally
%only retrieve the k'th split(s).

if nargin < 2
    k = 1:n;
end

nPosTrain = 2416;
nNegTrain = 12180;
permPosTrain = randperm(nPosTrain);
permNegTrain = randperm(nNegTrain);

Spos = [];
Sneg = [];

rng(1,'combRecursive');

for i = k
    Spos = [Spos; permPosTrain( ...
        floor((i-1)/n*nPosTrain)+1 : floor(i/n*nPosTrain))];
    Sneg = [Sneg; permNegTrain( ...
        floor((i-1)/n*nNegTrain)+1 : floor(i/n*nNegTrain))];
end

end