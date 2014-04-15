function [C,W,validP] = createCells(Isizes,P,gridType,gridSize,gridSpacing,...
    centerFilter,centerSigma,cellFilter,cellSigma)
% Output:
%   C       1-dim. varArray with constant dims [c,f]
%   validP  mask of features fully within image borders

centers = createCellOffsets(gridType,gridSize,gridSpacing);
nCenters = size(centers,1);
minCenters = min(centers,[],1);
maxCenters = max(centers,[],1);

% offsets for each scale image
idxScales = [0; cumsum(prod(Isizes,2))];

% iterate over each cell size
uniquePsize = unique(P(:,4));
validP = false([size(P,1) 1]);
Cdata = cell(numel(uniquePsize),1);
Wdata = cell(numel(uniquePsize),1);
sizes = ones(numel(uniquePsize),3);
map = zeros(size(centers,1),size(P,1));
for i = 1:numel(uniquePsize)
    % iterate over unique cell sizes
    Psize = uniquePsize(i);
    maski = P(:,4) == Psize;
    Pi = P(maski,:);
    nPi = size(Pi,1);
    PiRound = round(Pi(:,1:2));
    centersi = Psize*centers;
    
    % construct cell filter and window
    [fCell,rCell] = ndFilter(cellFilter,Psize*cellSigma);
    window = cellWindow(cellFilter,rCell);
    nWindow = size(window,1);
    
    % filter points too close to edge
    minContrib = min(window,[],1) + Psize*minCenters;
    maxContrib = max(window,[],1) + Psize*maxCenters;
    validPi = all(PiRound + repmat(minContrib,[nPi 1]) >= 1 & ...
        PiRound + repmat(maxContrib,[nPi 1]) <= Isizes(Pi(:,3),2:-1:1),2);
    maski(maski) = validPi;
    Pi = Pi(validPi,:);
    nPi = size(Pi,1);
    validP(maski) = 1;
    
    % compute cell points and weights
    pointsPiR = repmat(permute(round(Pi(:,1:2)),[4 2 3 1]),[nWindow 1 nCenters]);
    pointsWindowR = repmat(repmat(window,[1 1 nCenters]) + ...
        repmat(permute(round(centersi),[3 2 1]),[nWindow 1 1]),[1 1 1 nPi]);
    pointsR = pointsWindowR + pointsPiR;
    
    pointsCenter = repmat(permute(round(Pi(:,1:2)) - Pi(:,1:2),[4 2 3 1]), ...
        [nWindow 1 nCenters]) + pointsWindowR;
    pointsCell = repmat(permute(centersi,[3 2 1]),[nWindow 1 1 nPi]);
    Wdata{i} = fCell(pointsCenter-pointsCell);
    
    if ~strcmp(centerFilter,'none')
        [fCenter,~] = ndFilter(centerFilter,Psize*centerSigma);
        Wdata{i} = Wdata{i} .* fCenter(pointsCenter);
    end

    % compute indices of cell points
    Cdata{i} = pointsR(:,2,:,:) + (pointsR(:,1,:,:)-1) .* ...
        repmat(permute(Isizes(Pi(:,3),1),[4 2 3 1]),[nWindow 1 nCenters]) + ...
        repmat(permute(idxScales(Pi(:,3),1),[4 2 3 1]),[nWindow 1 nCenters]);
    sizes(i,1:numel(size(Cdata{i}))) = size(Cdata{i});
    map(:,maski) = i;
    
%     % compute relative cell window indices
%     idxWindow = window(:,1) * Isizes(Pi(:,3),1)' + ...
%         repmat(window(:,2),[1 nPi]);
%     idxWindow = permute(idxWindow,[1 3 4 2]);
%     
%     % compute relative cell center indices
%     idxPs = (PiRound(:,1)-1) .* Isizes(Pi(:,3),1) + PiRound(:,2) + ...
%         idxScales(Pi(:,3),1);
%     idxCenters = round(centersi(:,1)) * Isizes(Pi(:,3),1)' + ...
%         repmat(round(centersi(:,2)),[1 nPi]) + ...
%         repmat(idxPs',[size(centers,1) 1]);
%     idxCenters = permute(idxCenters,[3 4 1 2]);
%     
%     % assemble cells
%     Cdata{i} = repmat(idxWindow,[1 1 size(centers,1)]) + ...
%         repmat(idxCenters,[size(window,1) 1]);
%     sizes(i,1:numel(size(Cdata{i}))) = size(Cdata{i});
%     map(:,maski) = i;
end

map = map(:,validP);
C = varArray.newFull(Cdata,sizes,map);
W = varArray.newFull(Wdata,sizes,map);

end