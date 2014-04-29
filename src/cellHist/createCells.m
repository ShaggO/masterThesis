function [validP,C,Wcell,Wcen] = createCells(Isizes,P,gridType,gridSize,gridSpacing,...
    centerFilter,centerSigma,cellFilter,cellSigma,cellNormStrategy)
% Output:
%   validP  mask of features fully within image borders
%   C       1-dim. varArray with constant dims [c,f]
%   Wcell   weights on pixels within cells
%   Wcenter weights on cell centers

[cen,cenPol] = createCellOffsets(gridType,gridSize,gridSpacing);
nCen = size(cen,1);

if strcmp(centerFilter,'none')
    Wcen = ones(nCen,1);
else
    fCen = ndFilter(centerFilter,centerSigma);
    Wcen = fCen(cen);
end

polarCells = strcmp(cellFilter,'polar gaussian');

% offsets for each scale image
idxScales = [0; cumsum(prod(Isizes,2))];

% iterate over each cell size
uniquePsize = unique(P(:,4),'stable');
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
    ceni = Psize*cen;
    cenPoli = repmat([1 Psize],[nCen 1]) .* cenPol;
    
    % construct cell filter and windows
    if polarCells
        [fCell,rCell] = ndFilter(cellFilter(7:end),[1 Psize].*cellSigma);
        rCell = repmat(1.*rCell,[nCen 1]);
        [win,minWin,maxWin,~] = cellWindow(cellFilter,rCell,...
            repmat([1 1],[size(cenPoli,1) 1]) .* cenPoli);
        minContrib = minWin;
        maxContrib = maxWin;
    else
        [fCell,rCell] = ndFilter(cellFilter,Psize*cellSigma);
        rCell = repmat(rCell,[nCen 1]);
        [win,minWin,maxWin] = cellWindow(cellFilter,rCell);
        minContrib = min(minWin + Psize*cen,[],1);
        maxContrib = max(maxWin + Psize*cen,[],1);
    end
    
    % filter points too close to edge
    validPi = all(PiRound + repmat(minContrib,[nPi 1]) >= 1 & ...
        PiRound + repmat(maxContrib,[nPi 1]) <= Isizes(Pi(:,3),2:-1:1),2);
    maski(maski) = validPi;
    Pi = Pi(validPi,:);
    nPi = size(Pi,1);
    validP(maski) = 1;
    
    for j = 1:numel(win.data)
        k = k + 1;
        winj = win.data{j};
        nWinj = size(winj,1);
        maskj = win.map == j;
        cenj = ceni(maskj,:);
        nCenj = size(cenj,1);
        
        % compute cell points and weights
        pointsPiR = repmat(permute(round(Pi(:,1:2)),[4 2 3 1]),[nWinj 1 nCenj]);
        if polarCells
            pointsWindowR = repmat(winj,[1 1 1 nPi]);
            pointsCenter = repmat(permute(round(Pi(:,1:2)) - Pi(:,1:2),[4 2 3 1]), ...
                [nWinj 1 nCenj]) + pointsWindowR;
            cenPolj = cenPoli(maskj,:);
            [theta,rho] = cart2pol(pointsCenter(:,1,:,:),pointsCenter(:,2,:,:));
            pointsCenterPol = [theta rho];
%             pointsCellPol = pointsCenterPol - ...
%                 repmat(permute(cenPolj,[3 2 1]),[nWinj 1 1 nPi]);
%             pointsCellPol(:,1,:,:) = abs(pointsCellPol(:,1,:,:));
%             pointsCellPol(:,1,:,:) = min(pointsCellPol(:,1,:,:), ...
%                 2*pi - pointsCellPol(:,1,:,:));
%             Wdata{k} = fCell(pointsCellPol);
            Wdata{k} = polarDiffFunction(fCell,pointsCenterPol, ...
                repmat(permute(cenPolj,[3 2 1]),[nWinj 1 1 nPi]),1);
        else
            pointsWindowR = repmat(winj + ...
                repmat(permute(round(cenj),[3 2 1]),[nWinj 1 1]),[1 1 1 nPi]);
            pointsCenter = repmat(permute(round(Pi(:,1:2)) - Pi(:,1:2),[4 2 3 1]), ...
                [nWinj 1 nCenj]) + pointsWindowR;
            pointsCell = pointsCenter - ...
                repmat(permute(cenj,[3 2 1]),[nWinj 1 1 nPi]);
            Wdata{k} = fCell(pointsCell);
        end
        Wdata{k} = Wdata{k} ./ repmat(sum(Wdata{k},1) + eps,[nWinj 1]);
%         sum(Wdata{k},1)
        
        if ~strcmp(centerFilter,'none') && any(cellNormStrategy == 0:2)
            [fCen,~] = ndFilter(centerFilter,Psize*centerSigma);
            Wdata{k} = Wdata{k} .* fCen(pointsCenter);
        end
        
        % compute indices of cell points
        pointsR = pointsWindowR + pointsPiR;
        Cdata{k} = pointsR(:,2,:,:) + (pointsR(:,1,:,:)-1) .* ...
            repmat(permute(Isizes(Pi(:,3),1),[4 2 3 1]),[nWinj 1 nCenj]) + ...
            repmat(permute(idxScales(Pi(:,3),1),[4 2 3 1]),[nWinj 1 nCenj]);
        sizes(k,1:4) = [size(Cdata{k}) ones(1,4-numel(size(Cdata{k})))];
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
Wcell = varArray.newFull(Wdata,sizes,map);

end