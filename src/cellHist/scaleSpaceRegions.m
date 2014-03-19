function [Y,W,X] = scaleSpaceRegions(S, sigmaS, F, cellOffsets, type, sigmaFactor, r)
%SCALESPACEREGIONS Retrieve values and weights from a scale space sorted
% into regions
% Input:
%   S           Scale space images      {i,j}[:,:]
%   sigmaS      Scales                  [1,j]
%   F           Feature points          [f,3]
%   cellOffsets Offsets of cell centers [c,2]
%   type        Type of spatial filter
%   sigmaFactor Variance of filter, which is multiplied by each scale
%   r           Filter support radius   [1,2]
% Output:
%   Y           Scale space values      {i}[:,1,c,f]
%   W           Spatial weights         [:,1,c,f]

nCells = size(cellOffsets,1);
minOffset = min(cellOffsets,[],1);
maxOffset = max(cellOffsets,[],1);

[~,idx] = min(abs(repmat(log(sigmaS),[size(F,1) 1]) - ...
    repmat(log(F(:,3)),[1 size(sigmaS,2)])),[],2);
P = [(F(:,1:2)-1) ./ repmat(sigmaS(idx)',[1 2]) + 1, F(:,3:end)];

% preallocate relative cell meshgrid
[cellMeshX, cellMeshY] = meshgrid(1:2*r(1)+1,1:2*r(2)+1);

Y = cell(size(S,1),1);
[Y{:}] = deal(zeros(prod(2*r+1),1,nCells,0));
W = zeros(prod(2*r+1),1,nCells,0);
X = zeros(0,size(F,2));
for j = 1:numel(sigmaS)
    % find cell center points for this scale space
    idxJ = idx == j;
    nJ = sum(idxJ);
    c = P(idxJ,:);
    % filter points too close to edge
    edgeFilter = all(c(:,1:2) + repmat(minOffset-r,[nJ 1]) >= 1,2) & ...
        all(c(:,2:-1:1) + repmat(maxOffset+r,[nJ 1]) <= repmat(size(S{1,j}), ...
        [nJ 1]),2);
    c = c(edgeFilter,:);
    Fout = F(idxJ,:);
    X = [X; Fout(edgeFilter,:)];
    nJ = size(c,1);
    if nJ > 0
        % compute all cell points
        p = repmat(permute(c(:,1:2),[4 2 3 1]),[1 1 nCells 1]) + ...
            repmat(permute(cellOffsets,[3 2 1 4]),[1 1 1 nJ]);
        pCell = round(p-repmat(r,[1 1 nCells nJ]));
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
        W = cat(4,W,spatialWeights(coords,mu,type,sigmaFactor));
    end
end