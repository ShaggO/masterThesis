function [P, minP, maxP, Ppol] = cellWindow(type, r, rCenter)
%CELLWINDOW Computes coordinate offsets of a cell window of some type and
%radius

switch type
    case 'gaussian'
        r = ceil(r);
        uniqueR = unique(r,'rows');
        
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
            mask = sqrt((X/ri(1)).^2 + (Y/ri(2)).^2) <= 1;
            Pi = [X(mask) Y(mask)];
            Pdata{i} = repmat(Pi,[1 1 nwi]);
            sizes(i,1:ndims(Pdata{i})) = size(Pdata{i});
            map(rMaski) = i;
            minP(rMaski,:) = repmat(min(Pi,[],1),[nwi 1]);
            maxP(rMaski,:) = repmat(max(Pi,[],1),[nwi 1]);
        end
        P = varArray.newFull(Pdata,sizes,map);
    case 'triangle'
        r = ceil(r);
        [X,Y] = meshgrid(-r(1):r(1),-r(2):r(2));
        mask = abs(X/r(1)) + abs(Y/r(2)) <= 1;
        P = [X(mask) Y(mask)];
    case 'box'
        r = ceil(r);
        [X,Y] = meshgrid(-r(1):r(1),-r(2):r(2));
        mask = ':';
        P = [X(mask) Y(mask)];
    case 'polar gaussian'
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
        
%         % old code for computing window masks
%         dTheta = abs(Theta-rCenterTheta);
%         dTheta = min(dTheta,2*pi-dTheta);
%         dTheta(Rho == 0) = 0;
%         dRho = abs(Rho-rCenterRho);
%         wMask(:) = f([dTheta(:) dRho(:)]) <= 1;
        f = @(D) sqrt((D(:,1)./rTheta(:)).^2 + (D(:,2)./rRho(:)).^2);
        wMask = false(size(Theta));
        wMask(:) = polarDiffFunction(f,[Theta(:) Rho(:)],[rCenterTheta(:) rCenterRho(:)],0) <= 1;
        nMask = squeeze(sum(sum(wMask,1),2));
        uniqueN = unique(nMask);
        
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