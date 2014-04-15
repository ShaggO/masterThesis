clc, clear all

gridType = 'polar';
gridRadius = 17;
gridSize = [8 2];
nCells = gridSize(1)*gridSize(2)+1;
cellFilter = 'gaussian';
cellSigma = [1 1];
centerFilter = 'box';
centerSigma = [Inf Inf];

gridSpacing = 2*gridRadius / (gridSize(2)*2+1);
cellSigma = cellSigma * gridSpacing/2;
cellR = ceil(cellSigma * 3);

I = loadDtuImage(1,1,0);
I = rgb2gray(im2single(I));
d = kJetCoeffs(1);
scales = [1 2];
rescale = 1;

S = dGaussScaleSpace(I,d,scales,rescale);
cellOffsets = createCellOffsets(gridType,gridSize,gridSpacing);

F = [500 500 1];
[L,W,X] = scaleSpaceRegions(S,scales,rescale,F,cellOffsets,...
        centerFilter,centerSigma,cellFilter,cellSigma,ceil(3*cellSigma));
    
gridValues = (2*ceil((gridSize(2)*gridSpacing+cellR(1)))+1)^2
cellValues = prod(cellR*2+1)*nCells

totalGridValues = (2+nCells)*gridValues
totalCellValues = 3*cellValues
