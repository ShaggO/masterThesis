function [validP,C,Wcell,Wcen] = createCells(Isizes,P,gridType,gridSize,gridRadius,...
    centerFilter,centerSigma,cellFilter,cellSigma,cellNormStrategy)
% Output:
%   validP  mask of features fully within image borders
%   C       1-dim. varArray with constant dims [c,f]
%   Wcell   weights on pixels within cells
%   Wcenter weights on cell centers

[cen,cenPol,cellSize] = createCellOffsets(gridType,gridSize,gridRadius);
% cellSize(18:25) = 2;
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

% iterate over unique cell sizes
uniquePsize = unique(P(:,4),'stable');
validP = false([size(P,1) 1]);
k = 0;
for i = 1:numel(uniquePsize)
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
        rCell = [repmat(rCell(1),[nCen 1]) cellSize*rCell(2)];
        [win,minWin,maxWin,~] = cellWindow(cellFilter,rCell,...
            repmat([1 1],[size(cenPoli,1) 1]) .* cenPoli);
        minContrib = minWin;
        maxContrib = maxWin;
    else
        [fCell,rCell] = ndFilter(cellFilter,Psize*cellSigma);
        rCell = cellSize * rCell;
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
            pointsCellPol = [theta, rho ./ repmat(permute(cellSize(maskj),[3 2 1]), ...
                [nWinj 1 1 nPi])];
            pointsCenPol = repmat(permute(cenPolj ./ [ones(nCenj,1) cellSize(maskj)], ...
                [3 2 1]),[nWinj 1 1 nPi]);
            Wdata{k} = polarDiffFunction(fCell,pointsCellPol, ...
                pointsCenPol,true);
        else
            pointsWindowR = repmat(winj + ...
                repmat(permute(round(cenj),[3 2 1]),[nWinj 1 1]),[1 1 1 nPi]);
            pointsCenter = repmat(permute(round(Pi(:,1:2)) - Pi(:,1:2),[4 2 3 1]), ...
                [nWinj 1 nCenj]) + pointsWindowR;
            pointsCell = pointsCenter - ...
                repmat(permute(cenj,[3 2 1]),[nWinj 1 1 nPi]);
            pointsCell = pointsCell ./ repmat(permute(cellSize(maskj),[3 2 1]), ...
                [nWinj 2 1 nPi]);
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
end

map = map(:,validP);
C = varArray.newFull(Cdata,sizes,map);
Wcell = varArray.newFull(Wdata,sizes,map);

end