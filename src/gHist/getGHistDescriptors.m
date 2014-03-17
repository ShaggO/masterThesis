function [X,D] = getGHistDescriptors(I,F,blockType,blockSize,blockSpacing,...
    spatialType,spatialSigma,binType,binSigma,binCount)
% GETGHISTDESCRIPTORS Customizable descriptor based on cells of gradient
% histograms.
%
% Input:
%   I               RGB image
%   F               Detected features
%   blockType       Spatial layout of cells: square or polar
%   blockSize       Number of cells in x,y or polar,cartesian directions
%   blockSpacing    Distance between cells
%   spatialType     Type of spatial filter (on distance from cell center)
%   spatialSigma    Variance of spatial filter
%   binType         Type of bin filter (on distance from bin center)
%   binSigma        Variance of bin filter
%   binCount        Number of bins

I = rgb2gray(im2double(I));

% wRenorm = renormWeights(binType,binSigma,0,2*pi,binC);

% create cell offsets
cellOffsets = createCellOffsets(blockType,blockSize,blockSpacing);

% compute scale space images
scales = 2 .^ (round(log2(min(F(:,3)))) : round(log2(max(F(:,3)))));
S = dGaussScaleSpace(I, [1 0], [0 1], scales);

% lookup in scale space images (Ix and Iy)
[Y,W,X] = scaleSpaceRegions(S,scales,F,cellOffsets, ...
    spatialType,spatialSigma,ceil(3*spatialSigma));

% compute theta and m
Theta = atan2(Y{2}, Y{1});
M = sqrt(Y{1} .^ 2 + Y{2} .^ 2);

% Compute histogram bins
[binF, binR] = ndFilter(binType,binSigma);
binC = createBinCenters(0,2*pi,binCount);

% Permute theta and m such that first dimension is points within one
% cell, second dimension is singleton, third dimension is cell number,
% and fourth dimension is feature number.
h = ndHist(Theta,M .* W,binC,binF,binR,'period',2*pi);

D = zeros(size(h,4),size(h,1)*size(h,3));
for j = 1:size(h,3)
    D(:,(j-1)*binCount+(1:binCount)) = permute(h(:,1,j,:),[4 1 3 2]);
end

X = X(:,1:2);

end
