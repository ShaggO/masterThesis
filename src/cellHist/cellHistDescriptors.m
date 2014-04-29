function [X,D] = cellHistDescriptors(I,F,contentType,magnitudeType,...
    scaleBase,scaleOffset,rescale,gridType,gridSize,gridRadius,...
    centerFilter,centerSigma,cellFilter,cellSigma,...
    normType,normFilter,normSigma,binFilter,binSigma,binCount,...
    cellNormStrategy)
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
%   gridType        Spatial layout of cells: square or polar
%   gridSize        Number of cells in x,y or polar,cartesian directions
%   gridRadius      Total radius of grid
%   centerFilter    Type of descriptor center spatial filter
%   centerSigma     Variance of center spatial filter
%   cellFilter      Type of cell spatial filter
%   cellSigma       Variance of cell spatial filter
%   binFilter       Type of bin center filter
%   binSigma        Variance of bin filter
%   binCount        Number of bins

% check if 0 features
if size(F,1) == 0
    X = zeros(0,2);
    D = [];
    return
end

% set variables depending on type of histogram content
switch contentType
    case 'go'
        dContent = [1 0; 0 1];
        vFunc = @(L,s) diffStructure('Theta',L,s);
        left = -pi;
        right = pi;
        binCArgin = {};
        period = 2*pi;
    case 'si'
        dContent = [2 0; 1 1; 0 2];
        vFunc = @(L,s) diffStructure('S',L,s);
        left = -1;
        right = 1;
        binCArgin = {};
        period = 0;
    case 'go,si'
        assert(strcmp(magnitudeType,'m,c'));
        [X,Dgo] = cellHistDescriptors(I,F,'go','m',scaleBase,rescale, ...
            gridType,gridSize,gridRadius,centerFilter,centerSigma,...
            cellFilter,cellSigma,normType,normFilter,normSigma,...
            binFilter,binSigma(1),binCount(1));
        [~,Dsi] = cellHistDescriptors(I,F,'si','c',scaleBase,rescale, ...
            gridType,gridSize,gridRadius,centerFilter,centerSigma,...
            cellFilter,cellSigma,normType,normFilter,normSigma,...
            binFilter,binSigma(2),binCount(2));
        D = [Dgo Dsi];
        return
    case 'go-si'
        dContent = [1 0; 0 1; 2 0; 1 1; 0 2];
        vFunc = @(L,s) diffStructure('Theta-S',L,s);
        left = [-pi -1];
        right = [pi 1];
        binCArgin = {};
        period = [2*pi 0];
    case 'l'
        dContent = [1 0; 0 1; 2 0; 1 1; 0 2];
        vFunc = @(L,s) diffStructure('l',L,s);
        left = -pi/2;
        right = pi/2;
        binCArgin = {};
        period = 0;
    case 'b'
        dContent = [1 0; 0 1; 2 0; 1 1; 0 2];
        vFunc = @(L,s) diffStructure('b',L,s);
        left = 0;
        right = pi/2;
        binCArgin = {};
        period = 0;
    case 'a'
        dContent = [1 0; 0 1; 2 0; 1 1; 0 2];
        vFunc = @(L,s) diffStructure('a',L,s);
        left = 0;
        right = pi/4;
        binCArgin = {};
        period = 0;
    case '0'
        dContent = [1 0];
        vFunc = @(L,s) diffStructure('0',L,s);
        left = -1;
        right = 1; % these shouldn't matter for j2, but can't be identical
        binCArgin = {};
        period = 0;
end

% set variables depending on magnitude type
switch magnitudeType
    case 'm'
        dMagnitude = [1 0; 0 1];
        mFunc = @(L,s) diffStructure('M',L,s);
    case 'c'
        dMagnitude = [2 0; 1 1; 0 2];
        mFunc = @(L,s) diffStructure('C',L,s);
    case 'm-c'
        dMagnitude = [1 0; 0 1; 2 0; 1 1; 0 2];
        mFunc = @(L,s) diffStructure('M*C',L,s);
    case 'j2'
        dMagnitude = [1 0; 0 1; 2 0; 1 1; 0 2];
        mFunc = @(L,s) diffStructure('j2',L,s);
    case '1'
        dMagnitude = [1 0];
        mFunc = @(L,s) diffStructure('1',L,s);
end

% scale parameters according to definitions and rescale factor
[gridSpacing,centerSigma,cellSigma,binSigma,normSigma] = ...
    scaleParameters(rescale,gridType,gridSize,gridRadius,centerSigma,...
    cellFilter,cellSigma,binSigma,binCount,normType,normSigma,left,right);

% compute scale space images
d = union(dContent,dMagnitude,'rows');
scales = approxScales(F(:,3),scaleBase,scaleOffset);
[L,Isizes] = dGaussScaleSpace(I,d,scales,rescale);
V = vFunc(L,scales);
M = mFunc(L,scales);

% Pixel-wise normalization of magnitudes
if strcmp(normType,'pixel')
    if rescale > 0
        normSigma = repmat(normSigma,[numel(scales) 1]);
    else
        normSigma = scales' * normSigma;
    end
    M = pixelNormalization(M,normFilter,normSigma);
end

V = cellfun(@(v) {reshape(v,[],numel(binCount))},V);
V = cells2vector(V,numel(binCount));
M = cells2vector(M);

% create cells
P = scaleSpaceFeatures(F,scales,rescale);
[validP,C,Wcell,Wcenter] = createCells(Isizes,P,gridType,gridSize,gridSpacing,...
    centerFilter,centerSigma,cellFilter,cellSigma,cellNormStrategy);
X = F(validP,1:2);

% % draw cells (for debugging)
% Iw = zeros(sum(prod(Isizes,2)),1);
% for i = 1:numel(C.data)
%     for j = 1:size(C.data{i},3)
%         for k = 1:size(C.data{i},4)
%             Iw(C.data{i}(:,:,j,k)) = max(Iw(C.data{i}(:,:,j,k)), ...
%                 Wcell.data{i}(:,:,j,k));
% %             Iw(C.data{i}(:,:,j,k)) = 1;
%         end
%     end
% end
% Iw = varArray.newVector(Iw,Isizes,C.map);
% figure
% % imshow(max(imresize(I,Isizes(2,:)),5*Iw.data{2}),[])
% imshow(Iw.data{2},[])

% compute histogram variables
[binF, binR] = ndFilter(binFilter,binSigma);
binC = createBinCenters(left,right,binCount,binCArgin{:});
nBin = size(binC,1);
wRenorm = renormWeights(binFilter,binSigma,left,right,period > 0,binC);

% compute bin and magnitude weights (at cell mask points only)
maskC = false(size(V,1),1);
maskC(C.vector) = true;
B = zeros(size(V,1),nBin);
B(maskC,:) = ndBinWeights(V(maskC,:),binC,binF,binR, ...
    'period',period,'wBin',wRenorm) .* repmat(M(maskC),[1 nBin]);

% compute histograms
H = zeros([size(C.map) nBin]);
for i = 1:size(C.sizes,1)
    [Ci,maskPart] = C.partData(i);
    Bi = reshape(B(Ci(:),:),[C.sizes(i,:) nBin]) .* ...
        repmat(Wcell.partData(i),[1 1 1 1 nBin]);
    Di = sum(Bi,1);
    H(repmat(maskPart,[1 1 nBin])) = Di(:);
end
H = permute(H,[3 1 2]);

% Histogram normalization
if (strcmp(normType,'cell') || strcmp(normType,'pixel')) && ...
        any(cellNormStrategy == 1:3)
    % Normalize each histogram of each vector
    H = H ./ repmat(sum(H,1) + eps,[nBin 1]);
    if any(cellNormStrategy == 2:3)
        % Weights on cells based on cell center distance
        H = H .* repmat(Wcenter',[nBin 1 size(C.map,2)]);
    end
elseif strcmp(normType,'block')
    % Block normalization
    localOffsets = createCellOffsets(gridType,gridSize,gridSpacing,true);
    H = blockNormalization(H,cellOffsets,localOffsets,normFilter,normSigma);
end

% Reshape and normalize descriptors to unit vectors
D = reshape(H,[prod(binCount)*size(C.map,1) size(C.map,2)])';

D = D ./ repmat(sum(D,2) + eps,[1 size(D,2)]);

end