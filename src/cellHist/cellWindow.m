function [P, minP, maxP, Ppol] = cellWindow2(type, r, rCenter)
%CELLWINDOW Computes coordinate offsets of a cell window of some type and
%radius

if ~strncmp(type,'polar',5)
    r = ceil(r);
    uniqueR = unique(r,'rows','stable');
    
    Pdata = cell(size(uniqueR,1),1);
    sizes = ones(size(uniqueR,1),3);
    map = zeros(size(uniqueR,1),1);
    minP = zeros(size(r,1),2);
    maxP = minP;
    for i = 1:size(uniqueR,1)
        ri = uniqueR(i,:);
        rMaski = ismember(r,ri,'rows');
        nwi = sum(rMaski);
        [X,Y] = meshgrid(-ri(1):ri(1),-ri(2):ri(2));
        if strcmp(type,'gaussian') % circular mask
            mask = sqrt((X/ri(1)).^2 + (Y/ri(2)).^2) <= 1;
        else
            mask = ':';
        end
        Pi = [X(mask) Y(mask)];
        Pdata{i} = repmat(Pi,[1 1 nwi]);
        sizes(i,1:ndims(Pdata{i})) = size(Pdata{i});
        map(rMaski) = i;
        minP(rMaski,:) = repmat(min(Pi,[],1),[nwi 1]);
        maxP(rMaski,:) = repmat(max(Pi,[],1),[nwi 1]);
    end
    P = varArray.newFull(Pdata,sizes,map);
else
    rBox = ceil(max(r(:,2) + rCenter(:,2)));
    [X,Y] = meshgrid(-rBox:rBox,-rBox:rBox);
    minP = -[rBox rBox];
    maxP = [rBox rBox];
    [Theta,Rho] = cart2pol(X,Y);
    
    Theta = repmat(Theta,[1 1 size(r,1)]);
    Rho = repmat(Rho,[1 1 size(r,1)]);
    rTheta = repmat(permute(r(:,1),[2 3 1]),size(X));
    rRho = repmat(permute(r(:,2),[2 3 1]),size(X));
    rCenterTheta = repmat(permute(rCenter(:,1),[2 3 1]),size(X));
    rCenterRho = repmat(permute(rCenter(:,2),[2 3 1]),size(X));
    
    if strcmp(type,'polar gaussian')
        f = @(D) sqrt((D(:,1)./(rTheta(:)+eps)).^2 + (D(:,2)./(rRho(:)+eps)).^2);
    else
        f = @(D) max(abs(D(:,1)./(rTheta(:)+eps)),abs(D(:,2)./(rRho(:)+eps)));
    end
    wMask = false(size(Theta));
    wMask(:) = polarDiffFunction(f,[Theta(:) Rho(:)],[rCenterTheta(:) rCenterRho(:)],0) <= 1;
    nMask = squeeze(sum(sum(wMask,1),2));
    uniqueN = unique(nMask,'stable');
    
    Pdata = cell(numel(uniqueN),1);
    PpolData = cell(numel(uniqueN),1);
    sizes = ones(numel(uniqueN),3);
    map = zeros(numel(nMask),1);
    for i = 1:numel(uniqueN)
        ni = uniqueN(i);
        nMaski = ni == nMask;
        nwi = sum(nMaski);
        wMaski = wMask(:,:,nMaski);
        Pdata{i} = [reshape(multIdx(repmat(X,[1 1 nwi]),wMaski),ni,1,nwi) ...
            reshape(multIdx(repmat(Y,[1 1 nwi]),wMaski),ni,1,nwi)];
        PpolData{i} = [reshape(multIdx(repmat(Theta,[1 1 nwi]),wMaski),ni,1,nwi) ...
            reshape(multIdx(repmat(Rho,[1 1 nwi]),wMaski),ni,1,nwi)];
        sizes(i,1:ndims(Pdata{i})) = size(Pdata{i});
        map(nMaski) = i;
    end
    P = varArray.newFull(Pdata,sizes,map);
    Ppol = varArray.newFull(PpolData,sizes,map);
end

end