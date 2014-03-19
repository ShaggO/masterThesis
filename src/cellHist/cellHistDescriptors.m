function [X,D] = cellHistDescriptors(I,F,contentType,scaleBase, ...
    blockType,blockSize,blockSpacing, ...
    spatialType,spatialSigma,binType,binSigma,binCount)
% GETGHISTDESCRIPTORS Customizable descriptor based on cells of gradient
% histograms.
%
% Input:
%   I               RGB image
%   F               Detected features
%   contentType     Type of content in histograms
%   scaleBase       Logarithmic base used to approximate scale space scales
%   blockType       Spatial layout of cells: square or polar
%   blockSize       Number of cells in x,y or polar,cartesian directions
%   blockSpacing    Distance between cells
%   spatialType     Type of spatial filter (on distance from cell center)
%   spatialSigma    Variance of spatial filter
%   binType         Type of bin filter (on distance from bin center)
%   binSigma        Variance of bin filter
%   binCount        Number of bins

switch contentType
    case 'go'
        m = [1 0];
        n = [0 1];
        vFunc = @(Y) atan2(Y{2}, Y{1});
        mFunc = @(Y) sqrt(Y{1} .^ 2 + Y{2} .^ 2);
        left = 0;
        right = 2*pi;
        binCArgin = {};
        hArgin = {'period',2*pi};
    case 'si'
        m = [2 1 0];
        n = [0 1 2];
        vFunc = @(Y) 2/pi*atan2(-Y{1}-Y{3},sqrt(4*Y{2}.^2+(Y{1}-Y{3}).^2));
        mFunc = @(Y) sqrt(Y{1}.^2 + 2*Y{2}.^2 + Y{3}.^2);
        left = -1;
        right = 1;
        binCArgin = {};
        hArgin = {};
    case 'go,si'
    case 'go-si'
        m = [1 0 2 1 0];
        n = [0 1 0 1 2];
        vFunc = @(Y) [atan2(Y{2}, Y{1}), ...
            2/pi*atan2(-Y{3}-Y{5},sqrt(4*Y{4}.^2+(Y{3}-Y{5}).^2))];
        mFunc = @(Y) sqrt(Y{1} .^ 2 + Y{2} .^ 2) .* ...
            sqrt(Y{3}.^2 + 2*Y{4}.^2 + Y{5}.^2);
        left = [0 -1];
        right = [2*pi 1];
        binCArgin = {};
        hArgin = {'period',[2*pi 0]};
    case 'kjet'
end

I = rgb2gray(im2double(I));

% wRenorm = renormWeights(binType,binSigma,0,2*pi,binC);

% compute scale space images
minLogScale = log(min(F(:,3)))/log(scaleBase);
maxLogScale = log(max(F(:,3)))/log(scaleBase);
scales = scaleBase .^ (round(minLogScale) : round(maxLogScale));
S = dGaussScaleSpace(I,m,n,scales);

% lookup cells in scale space images
cellOffsets = createCellOffsets(blockType,blockSize,blockSpacing);
[Y,W,X] = scaleSpaceRegions(S,scales,F,cellOffsets, ...
    spatialType,spatialSigma,ceil(3*spatialSigma));
% W = repmat(W,[1 numel(binCount) 1 1]);

% compute histogram
[binF, binR] = ndFilter(binType,binSigma);
binC = createBinCenters(left,right,binCount,binCArgin{:});
h = ndHist(vFunc(Y),mFunc(Y) .* W,binC,binF,binR,hArgin{:});
h = h ./ repmat(sum(h,1),[prod(binCount) 1 1 1]);

% assemble descriptor
D = zeros(size(h,4),size(h,1)*size(h,3));
for j = 1:size(h,3)
    D(:,(j-1)*prod(binCount)+(1:prod(binCount))) = ...
        permute(h(:,1,j,:),[4 1 3 2]);
end

% return only coordinates
X = X(:,1:2);

end
