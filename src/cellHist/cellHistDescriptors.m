function [X,D] = cellHistDescriptors(I,F,contentType,magnitudeType,...
    scaleBase,rescale,gridType,gridSize,gridRadius,...
    centerFilter,centerSigma,cellFilter,cellSigma,...
    normType,normFilter,normSigma,binFilter,binSigma,binCount)
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
        vFunc = @(L,s) [diffStructure('Theta',L,s) ...
            diffStructure('S',L,s)];
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
        mFunc = @(L,s) diffStructure('M',L,s) .* diffStructure('C',L,s);
    case 'j2'
        dMagnitude = [1 0; 0 1; 2 0; 1 1; 0 2];
        mFunc = @(L,s) diffStructure('j2',L,s);
    case '1'
        dMagnitude = [1 0];
        mFunc = @(L,s) diffStructure('1',L,s);
end

% scale parameters according to definitions and rescale factor
[gridSpacing,centerSigma,cellSigma,binSigma,normSigma] = ...
    scaleParameters(rescale,gridType,gridSize,gridRadius,centerSigma,cellSigma,...
    binSigma,binCount,normType,normSigma,left,right);

% compute scale space images
d = union(dContent,dMagnitude,'rows');
scales = approxScales(F(:,3),scaleBase);
S = dGaussScaleSpace(I,d,scales,rescale);

S = struct('V',vFunc(S,scales),'M',mFunc(S,scales));

% create cell offsets
cellOffsets = createCellOffsets(gridType,gridSize,gridSpacing);

% compute histogram variables
[binF, binR] = ndFilter(binFilter,binSigma);
binC = createBinCenters(left,right,binCount,binCArgin{:});
wRenorm = renormWeights(binFilter,binSigma,left,right,period > 0,binC);

if rescale > 0
    if strcmp(normType,'pixel')
        % Pixel-wise normalization of magnitudes
        normSigma = repmat(normSigma,[numel(scales) 1]);
        Mnorm = pixelNormalization({S.M},normFilter,normSigma);
        [S.M] = Mnorm{:};
    end
    [L,W,X] = scaleSpaceRegions(S,scales,rescale,F,cellOffsets,...
        centerFilter,centerSigma,cellFilter,cellSigma,ceil(3*cellSigma));

    h = ndHist(L.V,L.M .* W,binC,binF,binR,'period',period,'wBin',wRenorm);
else
    if strcmp(normType,'pixel')
        % Pixel-wise normalization of magnitudes
        normSigma = scales' * normSigma;
        Mnorm = pixelNormalization({S.M},normFilter,normSigma);
        [S.M] = Mnorm{:};
    end
    [~,idx] = min(abs(repmat(log(scales),[size(F,1) 1]) - ...
        repmat(log(F(:,3)),[1 size(scales,2)])),[],2);

    X = zeros(0,size(F,2));
    h = zeros(prod(binCount),1,size(cellOffsets,1),0);
    for i = 1:numel(scales)
        disp(['Scale: ' num2str(i) '/' num2str(numel(scales))])
        % Find closest scale for each feature
        [L,W,Xi] = scaleSpaceRegions(S(i),scales(i),rescale,F(idx == i,:),cellOffsets,...
            centerFilter,centerSigma,cellFilter,cellSigma,ceil(3*cellSigma));
        X = [X; Xi];

        hSigma = ndHist(L.V,L.M .* W,binC,binF,binR,'period',period,'wBin',wRenorm);
        h = cat(4,h, hSigma);
    end
end

% Normalizations
if strcmp(normType,'cell')
    % Normalize each histogram of each vector
    h = h ./ repmat(sum(h,1),[prod(binCount) 1 1 1]);
elseif strcmp(normType,'block')
    % Block normalization
    localOffsets = createCellOffsets(gridType,gridSize,gridSpacing,true);
    h = blockNormalization(h,cellOffsets,localOffsets,normFilter,normSigma);
end

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
