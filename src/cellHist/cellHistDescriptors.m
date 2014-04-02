function [X,D] = cellHistDescriptors(I,F,contentType,scaleBase,rescale,...
    blockType,blockSize,blockSpacing,centerType,centerSigma,...
    cellType,cellSigma,binType,binSigma,binCount)
% GETGHISTDESCRIPTORS Customizable descriptor based on cells of gradient
% histograms.
%
% Input:
%   I               RGB image
%   F               Detected features
%   contentType     Type of content in histograms
%   scaleBase       Logarithmic base used to approximate scale space scales
%   rescale         Boolean determining whether to rescale depending on scale or not
%   blockType       Spatial layout of cells: square or polar
%   blockSize       Number of cells in x,y or polar,cartesian directions
%   blockSpacing    Distance between cells
%   centerType      Type of descriptor center spatial filter
%   centerSigma     Variance of center spatial filter
%   cellType        Type of cell spatial filter
%   cellSigma       Variance of cell spatial filter
%   binType         Type of bin center filter
%   binSigma        Variance of bin filter
%   binCount        Number of bins

switch contentType
    case 'go'
        m = [1 0];
        n = [0 1];
        vFunc = @(Y) atan2(Y{2}, Y{1});
        mFunc = @(Y) sqrt(Y{1} .^ 2 + Y{2} .^ 2);
        left = -pi;
        right = pi;
        binCArgin = {};
        period = 2*pi;
    case 'si'
        m = [2 1 0];
        n = [0 1 2];
        vFunc = @(Y) 2/pi*atan2(-Y{1}-Y{3},sqrt(4*Y{2}.^2+(Y{1}-Y{3}).^2));
        mFunc = @(Y) sqrt(Y{1}.^2 + 2*Y{2}.^2 + Y{3}.^2);
        left = -1;
        right = 1;
        binCArgin = {};
        period = 0;
    case 'go,si'
        [X,Dgo] = cellHistDescriptors(I,F,'go',scaleBase, rescale, ...
            blockType,blockSize,blockSpacing,cellType,cellSigma, ...
            binType,binSigma(1),binCount(1));
        [~,Dsi] = cellHistDescriptors(I,F,'si',scaleBase, rescale, ...
            blockType,blockSize,blockSpacing,cellType,cellSigma, ...
            binType,binSigma(2),binCount(2));
        D = [Dgo Dsi];
        return
    case 'go-si'
        m = [1 0 2 1 0];
        n = [0 1 0 1 2];
        vFunc = @(Y) [atan2(Y{2}, Y{1}), ...
            2/pi*atan2(-Y{3}-Y{5},sqrt(4*Y{4}.^2+(Y{3}-Y{5}).^2))];
        mFunc = @(Y) sqrt(Y{1} .^ 2 + Y{2} .^ 2) .* ...
            sqrt(Y{3}.^2 + 2*Y{4}.^2 + Y{5}.^2);
        left = [-pi -1];
        right = [pi 1];
        binCArgin = {};
        period = [2*pi 0];
    case 'kjet'
end

% scale binSigma
binSigma = binSigma .* (right-left) ./ binCount;

% compute scale space images
minLogScale = log(min(F(:,3)))/log(scaleBase);
maxLogScale = log(max(F(:,3)))/log(scaleBase);
scales = scaleBase .^ (round(minLogScale) : round(maxLogScale));
S = dGaussScaleSpace(I,m,n,scales,rescale);

% create cell offsets
cellOffsets = createCellOffsets(blockType,blockSize,blockSpacing);

% compute histogram variables
[binF, binR] = ndFilter(binType,binSigma);
binC = createBinCenters(left,right,binCount,binCArgin{:});
wRenorm = renormWeights(binType,binSigma,left,right,period > 0,binC);

if rescale
    [Y,W,X] = scaleSpaceRegions(S,scales,rescale,F,cellOffsets,...
        centerType,centerSigma,cellType,cellSigma,ceil(3*cellSigma));

    V = vFunc(Y);
    M = mFunc(Y);
    h = ndHist(V,M .* W,binC,binF,binR,'period',period,'wBin',wRenorm);
else
    [~,idx] = min(abs(repmat(log(scales),[size(F,1) 1]) - ...
                    repmat(log(F(:,3)),[1 size(scales,2)])),[],2);

    X = zeros(0,size(F,2));
    h = zeros(prod(binCount),1,size(cellOffsets,1),0);
    for i = 1:numel(scales)
        disp(['Scale: ' num2str(i) '/' num2str(numel(scales))])
        % Find closest scale for each feature
        [Y,W,XSigma] = scaleSpaceRegions(S(:,i),scales(i),rescale,F(idx == i,:),cellOffsets,...
            centerType,centerSigma,cellType,cellSigma,ceil(3*cellSigma));
        X = [X; XSigma];
        V = vFunc(Y);
        M = mFunc(Y);
        hSigma = ndHist(V,M .* W,binC,binF,binR,'period',period,'wBin',wRenorm);
        h = cat(4,h, hSigma);
    end
end

% % TODO: create parameters for these somehow
% localOffsets = createCellOffsets(blockType,blockSize-1,blockSpacing);
% localType = 'gaussian';
% localSigma = blockSpacing;
% h = localNormalization(h,cellOffsets,localOffsets,localType,localSigma);

% Normalize each histogram of each vector
%h = h ./ repmat(sum(h,1),[prod(binCount) 1 1 1]);

% % plot histogram
% figure
% plot([binC'; binC'],[sum(sum(h,3),4)'; zeros(size(binC'))],'b-')

% assemble descriptor
D = zeros(size(h,4),size(h,1)*size(h,3));
for j = 1:size(h,3)
    D(:,(j-1)*prod(binCount)+(1:prod(binCount))) = ...
        permute(h(:,1,j,:),[4 1 3 2]);
end
% Normalize to unit vector descriptors
D = D ./ repmat(sum(D,2),[1 size(D,2)]);

% return only coordinates
X = X(:,1:2);

end
