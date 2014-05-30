function [X,D] = cellHistDescriptors(I,F,contentType,magnitudeType,...
    scaleBase,scaleOffset,rescale,smooth,gridType,gridSize,gridRadius,...
    centerFilter,centerSigma,cellFilter,cellSigma,...
    normType,normFilter,normSigma,binFilter,binSigma,binCount,...
    cellNormStrategy,binStrategy)
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
    X = zeros(0,2,'single');
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
        switch binStrategy
            case 0
                binCArgin = {};
            case 1
                binCArgin = {'offset',-pi/binCount};
        end
        period = 2*pi;
    case 'si'
        dContent = [2 0; 1 1; 0 2];
        vFunc = @(L,s) diffStructure('S',L,s);
        left = -1;
        right = 1;
        switch binStrategy
            case 0
                binCArgin = {};
            case 1
                binCArgin = {'endpoints',true};
        end
        period = 0;
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

saveVars = false;
windowGrid = any(strcmp(gridType,{'square window','triangle window'})) && ...
    size(F,1) > 1;

% scale parameters according to definitions and rescale factor
[gridRadius,centerSigma,cellSigma,binSigma,normSigma] = ...
    scaleParameters(rescale,gridSize,gridRadius,centerSigma,...
    cellFilter,cellSigma,binSigma,binCount,normType,normSigma,left,right);

% compute histogram variables
[binF, binR] = ndFilter(binFilter,binSigma);
binC = createBinCenters(left,right,binCount,binCArgin{:});
nBin = size(binC,1);
wRenorm = renormWeights(binFilter,binSigma,left,right,period > 0,binC);

% compute scale space images
d = union(dContent,dMagnitude,'rows');
if saveVars
    % if we save scale space figure data, generate raw smoothed images
    d = [0 0; d];
end
scales = approxScales(F(:,3:end),scaleBase,scaleOffset);
[L,Isizes] = dGaussScaleSpace(I,d,scales,rescale,smooth);
Vscales = vFunc(L,scales);
Mscales = mFunc(L,scales);

% Pixel-wise normalization of magnitudes
if strcmp(normType,'pixel')
    if rescale > 0
        normSigma = repmat(normSigma,[numel(scales) 1]);
    else
        normSigma = scales' * normSigma;
    end
    MscalesNorm = pixelNormalization(Mscales,normFilter,normSigma);
else
    MscalesNorm = Mscales;
end

% Convert value/magnitude cell arrays to concatenated arrays
V = cellfun(@(v) {reshape(v,[],numel(binCount))},Vscales);
V = cells2vector(V,numel(binCount));
M = cells2vector(MscalesNorm);

% Compute bin values (everywhere)
fullB = saveVars || windowGrid;
if fullB
    B = ndBinWeights(V,binC,binF,binR, ...
        'period',period,'wBin',wRenorm) .* repmat(M,[1 nBin]);
end

% Create cell windows (indices, weights, valid points)
P = scaleSpaceFeatures(F,scales,rescale);
Psplit = splitPoints(P,windowGrid);
D = [];
for s = 1:numel(Psplit)
    [validP,C,Wcell,Wcenter,cells] = createCells(Isizes,Psplit{s},gridType,gridSize,gridRadius,...
        centerFilter,centerSigma,cellFilter,cellSigma,cellNormStrategy);
    X = F(validP,1:2);
    
    % Compute bin values (at cell mask points only)
    if ~fullB
        maskC = false(size(V,1),1);
        maskC(C.vector) = true;
        B = zeros(size(V,1),nBin,'single');
        B(maskC,:) = ndBinWeights(V(maskC,:),binC,binF,binR, ...
            'period',period,'wBin',wRenorm) .* repmat(M(maskC),[1 nBin]);
    end
    
    % compute histograms
    H = zeros([size(C.map) nBin],'single');
    for i = 1:size(C.sizes,1)
        if windowGrid
            Di = zeros([1 C.sizes(i,2:end) nBin],'single');
            for j = 1:nBin
                Di(:,:,:,:,j) = sum(reshape(B(C.data{i}(:),j),C.sizes(i,:)) .* ...
                    Wcell.data{i},1);
            end
        else
            Bi = reshape(B(C.data{i}(:),:),[C.sizes(i,:) nBin]) .* ...
                repmat(Wcell.data{i},[1 1 1 1 nBin]);
            Di = sum(Bi,1);
        end
        
        H(repmat(C.map == i,[1 1 nBin])) = Di(:);
    end
    H = permute(H,[3 1 2]);
    
    % Histogram normalization
    if (strcmp(normType,'cell') || strcmp(normType,'pixel')) && ...
            any(cellNormStrategy == 1:3)
        % Normalize each histogram of each vector
        Hnorm = H ./ repmat(sum(H,1) + eps,[nBin 1]);
        if any(cellNormStrategy == 2:3)
            % Weights on cells based on cell center distance
            Hnorm = Hnorm .* repmat(Wcenter',[nBin 1 size(C.map,2)]);
        end
    else
        Hnorm = H;
    end
    
    Ds = reshape(Hnorm,[prod(binCount)*size(C.map,1) size(C.map,2)])';
    if cellNormStrategy < 4
        % Reshape and normalize descriptors to unit vectors
        Ds = Ds ./ repmat(sum(Ds,2) + eps,[1 size(Ds,2)]);
    end
    
    % concatenate descriptors for each split
    D = [D; Ds];
end

if saveVars
    save('cellHistExample')
end

% Cdata = C.data;
% WcellData = Wcell.data;
% whos
% memory

end

function Psplit = splitPoints(P,windowGrid)

s = 500; % max points per split

if windowGrid
    n = 1:s:size(P,1);
    Psplit = cell(numel(n),1);
    for i = 1:numel(n)-1
        Psplit{i} = P(n(i)+(0:s-1),:);
    end
    Psplit{end} = P(n(end):end,:);
else
    Psplit = {P};
end

end