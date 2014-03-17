clc, clear all

S{1} = reshape(1:100,10,10);
S{2} = -reshape(1:100,10,10);

sigmaS = [1 2];
F = [2,2,1; 4.9,4.9,2; 2,8,1];
cellOffsets = [0 0; 0 1];
type = 'gaussian';
sigmaFactor = [1/3 1/3];
r = [1 1];

[X,W] = scaleSpaceRegions(S,sigmaS,F,cellOffsets,type,sigmaFactor,r)