function [Y,W,X] = scaleSpaceRegions(S,sigmaS,rescale,F,cellOffsets,...
    centerType,centerSigma,cellType,cellSigma,cellR)
%SCALESPACEREGIONS Retrieve values and weights from a scale space sorted
% into regions
% Input:
%   S           Scale space images      {i,j}[:,:]
%   sigmaS      Scales                  [1,j]
%   rescale     if >0, rescale according to this scale
%   F           Feature points          [f,3]
%   cellOffsets Offsets of cell centers [c,2]
%   centerType  Type of descriptor center spatial filter
%   centerSigma Variance of descriptor center spatial filter
%   cellType    Type of cell spatial filter
%   cellSigma   Variance of cell filter, which is multiplied by each scale
%   cellR       Cell filter support radius   [1,2]
% Output:
%   Y           Scale space values      {i}[:,1,c,f]
%   W           Spatial weights         [:,1,c,f]

nCells = size(cellOffsets,1);

% Find closest scale for each feature
[~,idx] = min(abs(repmat(log(sigmaS),[size(F,1) 1]) - ...
    repmat(log(F(:,3)),[1 size(sigmaS,2)])),[],2);

if rescale > 0
    P = [(F(:,1:2)-1) * rescale ./ repmat(sigmaS(idx)',[1 2]) + 1, F(:,3:end)];
else
    % Perform no rescaling. This only occurs with a single scale (sigmaS)
    assert(numel(sigmaS) == 1,['Cannot create scale space regions for multiple'...
        'sigmas without rescaling. Call the function multiple times instead.']);

    P = F(:,1:2);
    cellOffsets = cellOffsets * sigmaS;
    cellSigma = cellSigma * sigmaS;
    cellR = cellR * sigmaS;
end

minOffset = min(cellOffsets,[],1);
maxOffset = max(cellOffsets,[],1);

% No rotation so far. Same cell offsets for all features
% Rotation should be handled in this matrix if needed
cellOffsets = repmat(permute(cellOffsets,[3 2 1 4]),[1 1 1 size(F,1)]);

% preallocate relative cell meshgrid
[cellMeshX, cellMeshY] = meshgrid(1:2*cellR(1)+1,1:2*cellR(2)+1);

Y = cell(size(S,1),1);
[Y{:}] = deal(zeros(prod(2*cellR+1),1,nCells,0));
W = zeros(prod(2*cellR+1),1,nCells,0);
X = zeros(0,size(F,2));
for j = 1:numel(sigmaS)
    % find cell center points for this scale space
    idxJ = idx == j;
    nJ = sum(idxJ);
    c = P(idxJ,:);
    % filter points too close to edge
    edgeFilter = all(c(:,1:2) + repmat(minOffset-cellR,[nJ 1]) >= 1,2) & ...
        all(c(:,2:-1:1) + repmat(maxOffset+cellR,[nJ 1]) <= repmat(size(S{1,j}), ...
        [nJ 1]),2);
    c = c(edgeFilter,:);
    Fout = F(idxJ,:);
    X = [X; Fout(edgeFilter,:)];
    nJ = size(c,1);
    if nJ > 0
        % compute all cell points
        cellOffsetsJ = multIdx(cellOffsets,{':',':',':',idxJ},{':',':',':',edgeFilter});
        p = repmat(permute(c(:,1:2),[4 2 3 1]),[1 1 nCells 1]) + cellOffsetsJ;
        pCell = round(p-repmat(cellR,[1 1 nCells nJ]));
        % compute indices for upper left corner of cells
        pCellIdx = sub2ind(size(S{1,j}),pCell(1,2,:,:),pCell(1,1,:,:));
        % compute relative indices for one cell
        relIdx = sub2ind(size(S{1,j}),cellMeshY,cellMeshX)-1;
        % compute indices for all cells and lookup in scale space
        cellIdx = repmat(relIdx(:),[1 1 nCells nJ]) + ...
            repmat(pCellIdx,[numel(relIdx) 1 1 1]);
        for i = 1:size(S,1)
            Y{i} = cat(4,Y{i},S{i,j}(cellIdx));
        end
        % compute weights
        coords = repmat([cellMeshX(:) cellMeshY(:)], [1 1 nCells nJ]);
        mu = p-pCell+1;
        W = cat(4,W,spatialWeights(coords,mu,cellType,cellSigma) .* ...
            spatialWeights(coords,mu-cellOffsetsJ,centerType,centerSigma));
    end
end
end
