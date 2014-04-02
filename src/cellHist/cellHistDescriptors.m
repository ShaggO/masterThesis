function [X,D] = cellHistDescriptors(I,F,contentType,magnitudeType,...
    scaleBase,rescale,blockType,blockSize,blockSpacing,...
    centerType,centerSigma,cellType,cellSigma,binType,binSigma,binCount)
% GETGHISTDESCRIPTORS Customizable descriptor based on cells of gradient
% histograms.
%
% Input:
%   I               RGB image
%   F               Detected features
%   contentType     Type of content in histograms
%   magnitudeType   Type of magnitude weights on histogram content
%   scaleBase       Logarithmic base used to approximate scale space scales
%   rescale         If >0, rescale according to this scale
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

% set variables depending on type of histogram content
switch contentType
    case 'go'
        dContent = [1 0; 0 1];
        vFunc = @(L,sigma) diffStructure('Theta',L);
        left = -pi;
        right = pi;
        binCArgin = {};
        period = 2*pi;
    case 'si'
        dContent = [2 0; 1 1; 0 2];
        vFunc = @(L,sigma) diffStructure('S',L);
        left = -1;
        right = 1;
        binCArgin = {};
        period = 0;
    case 'go,si'
        assert(magnitudeType == 'm,c');
        [X,Dgo] = cellHistDescriptors(I,F,'go','m',scaleBase,rescale, ...
            blockType,blockSize,blockSpacing,cellType,cellSigma, ...
            binType,binSigma(1),binCount(1));
        [~,Dsi] = cellHistDescriptors(I,F,'si','c',scaleBase,rescale, ...
            blockType,blockSize,blockSpacing,cellType,cellSigma, ...
            binType,binSigma(2),binCount(2));
        D = [Dgo Dsi];
        return
    case 'go-si'
        dContent = [1 0; 0 1; 2 0; 1 1; 0 2];
        vFunc = @(L,sigma) [diffStructure('Theta',L,sigma) ...
            diffStructure('S',L,sigma)];
        left = [-pi -1];
        right = [pi 1];
        binCArgin = {};
        period = [2*pi 0];
    case 'l'
        dContent = [1 0; 0 1; 2 0; 1 1; 0 2];
        vFunc = @(L,sigma) diffStructure('l',L,sigma);
        left = -pi/2;
        right = pi/2;
        binCArgin = {};
        period = 0;
    case 'b'
        dContent = [1 0; 0 1; 2 0; 1 1; 0 2];
        vFunc = @(L,sigma) diffStructure('b',L,sigma);
        left = 0;
        right = pi/2;
        binCArgin = {};
        period = 0;
    case 'a'
        dContent = [1 0; 0 1; 2 0; 1 1; 0 2];
        vFunc = @(L,sigma) diffStructure('a',L,sigma);
        left = 0;
        right = pi/4;
        binCArgin = {};
        period = 0;
    case '0'
        dContent = [1 0; 0 1; 2 0; 1 1; 0 2];
        vFunc = @(L,sigma) zeros(size(nthField(L,1)));
        left = -1;
        right = 1; % these shouldn't matter for j2, but can't be identical
        binCArgin = {};
        period = 0;
end

switch magnitudeType
    case 'm'
        dMagnitude = [1 0; 0 1];
        mFunc = @(L,sigma) diffStructure('M',L,sigma);
    case 'c'
        dMagnitude = [2 0; 1 1; 0 2];
        mFunc = @(L,sigma) diffStructure('C',L,sigma);
    case 'm-c'
        dMagnitude = [1 0; 0 1; 2 0; 1 1; 0 2];
        mFunc = @(L,sigma) diffStructure('M',L,sigma) .* ...
            diffStructure('C',L,sigma);
    case 'j2'
        dMagnitude = [1 0; 0 1; 2 0; 1 1; 0 2];
        mFunc = @(L,sigma) diffStructure('j2',L,sigma);
end

% scale binSigma
binSigma = binSigma .* (right-left) ./ binCount;

% compute scale space images
d = union(dContent,dMagnitude,'rows');
minLogScale = log(min(F(:,3)))/log(scaleBase);
maxLogScale = log(max(F(:,3)))/log(scaleBase);
scales = scaleBase .^ (round(minLogScale) : round(maxLogScale));
S = dGaussScaleSpace(I,d,scales,rescale);

% create cell offsets
cellOffsets = createCellOffsets(blockType,blockSize,blockSpacing);

% compute histogram variables
[binF, binR] = ndFilter(binType,binSigma);
binC = createBinCenters(left,right,binCount,binCArgin{:});
wRenorm = renormWeights(binType,binSigma,left,right,period > 0,binC);

if rescale > 0
    [L,W,X] = scaleSpaceRegions(S,scales,rescale,F,cellOffsets,...
        centerType,centerSigma,cellType,cellSigma,ceil(3*cellSigma));
    sigma = repmat(permute(X(:,3),[4 2 3 1]),multIdx(size(nthField(L,1)),1:3));
    V = vFunc(L,sigma);
    M = mFunc(L,sigma);
    h = ndHist(V,M .* W,binC,binF,binR,'period',period,'wBin',wRenorm);
else
    [~,idx] = min(abs(repmat(log(scales),[size(F,1) 1]) - ...
        repmat(log(F(:,3)),[1 size(scales,2)])),[],2);
    
    X = zeros(0,size(F,2));
    h = zeros(prod(binCount),1,size(cellOffsets,1),0);
    for i = 1:numel(scales)
        disp(['Scale: ' num2str(i) '/' num2str(numel(scales))])
        % Find closest scale for each feature
        [L,W,XSigma] = scaleSpaceRegions(S(:,i),scales(i),rescale,F(idx == i,:),cellOffsets,...
            centerType,centerSigma,cellType,cellSigma,ceil(3*cellSigma));
        X = [X; XSigma];
        sigma = repmat(permute(X(:,3),[4 2 3 1]),multIdx(size(nthField(L,1)),1:3));
        V = vFunc(L,sigma);
        M = mFunc(L,sigma);
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
% h = h ./ repmat(sum(h,1),[prod(binCount) 1 1 1]);

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
