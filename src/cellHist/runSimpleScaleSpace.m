S = {ones(10,10)};
sigmaS = [1];
rescale=false;
F = [5 5 1; 6 6 1];
cellOffsets = [-1 -1;1 1];
centerType = 'gaussian';
centerSigma = [1 1];
cellType = 'gaussian';
cellSigma = [1 1];
r = [3 3];

[Y,W,X] = scaleSpaceRegions(S,sigmaS,rescale,F,cellOffsets,centerType,centerSigma,cellType,cellSigma,r);
