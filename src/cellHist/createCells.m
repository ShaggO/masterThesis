function [C,W,validP] = createCells(Isizes,P,gridType,gridSize,gridSpacing,...
    centerFilter,centerSigma,cellFilter,cellSigma)
% Output:
%   C       1-dim. varArray with constant dims [c,f]
%   validP  mask of features fully within image borders

centers = createCellOffsets(gridType,gridSize,gridSpacing);
nCenters = size(centers,1);

% offsets for each scale image
idxScales = [0; cumsum(prod(Isizes,2))];

% iterate over each cell size
uniquePsize = unique(P(:,4));
validP = false([size(P,1) 1]);
% Cdata = cell(numel(uniquePsize),1);
% Wdata = cell(numel(uniquePsize),1);
% sizes = ones(numel(uniquePsize),4);
% map = zeros(size(centers,1),size(P,1));
k = 0;
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
    rCell = repmat(rCell,[nCenters 1]);
    [windows,minWindows,maxWindows] = cellWindow(cellFilter,rCell);
    
    % filter points too close to edge
    minContrib = min(minWindows + Psize*centers,[],1);
    maxContrib = max(maxWindows + Psize*centers,[],1);
    validPi = all(PiRound + repmat(minContrib,[nPi 1]) >= 1 & ...
        PiRound + repmat(maxContrib,[nPi 1]) <= Isizes(Pi(:,3),2:-1:1),2);
    maski(maski) = validPi;
    Pi = Pi(validPi,:);
    nPi = size(Pi,1);
    validP(maski) = 1;
    
    for j = 1:numel(windows.data)
        k = k + 1;
        windowsj = windows.data{j};
        nWindowsj = size(windowsj,1);
        maskj = windows.map == j;
        centersj = centersi(maskj,:);
        nCentersj = size(centersj,1);
        
        % compute cell points and weights
        pointsPiR = repmat(permute(round(Pi(:,1:2)),[4 2 3 1]),[nWindowsj 1 nCentersj]);
        pointsWindowR = repmat(windowsj + ...
            repmat(permute(round(centersj),[3 2 1]),[nWindowsj 1 1]),[1 1 1 nPi]);
        pointsR = pointsWindowR + pointsPiR;
        
        pointsCenter = repmat(permute(round(Pi(:,1:2)) - Pi(:,1:2),[4 2 3 1]), ...
            [nWindowsj 1 nCentersj]) + pointsWindowR;
        pointsCell = repmat(permute(centersj,[3 2 1]),[nWindowsj 1 1 nPi]);
        Wdata{k} = fCell(pointsCenter-pointsCell);
        
        if ~strcmp(centerFilter,'none')
            [fCenter,~] = ndFilter(centerFilter,Psize*centerSigma);
            Wdata{k} = Wdata{k} .* fCenter(pointsCenter);
        end
        
        % compute indices of cell points
        Cdata{k} = pointsR(:,2,:,:) + (pointsR(:,1,:,:)-1) .* ...
            repmat(permute(Isizes(Pi(:,3),1),[4 2 3 1]),[nWindowsj 1 nCentersj]) + ...
            repmat(permute(idxScales(Pi(:,3),1),[4 2 3 1]),[nWindowsj 1 nCentersj]);
        sizes(k,1:numel(size(Cdata{k}))) = size(Cdata{k});
        map(maskj,maski) = k;
    end
    
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