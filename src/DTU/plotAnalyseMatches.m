function [] = plotAnalyseMatches(match,t,mFunc,mName)
% Inputs:
%   match   Match structure after completed matching
%   t       threshold between best and 2nd best match
%   mName   Method name (where to lookup)

% Load paths for the data
load('paths');

imArgin = {match.setNum, match.imNum, match.liNum};
[imRes.X,imRes.D] = dtuFeatures(imArgin{:},mFunc,false);
[keyRes.X,keyRes.D] = dtuFeatures(match.setNum,25,0,mFunc,false);
I = loadDtuImage(imArgin{:});
Ikey = loadDtuImage(match.setNum, 25, match.liNum);

T = [0; sort(match.distRatio,'ascend')];

idx = find(T < t,1,'last');

f1 = figure('units','normalized','outerposition',[0 0 1 1],'name',mName);

while true
    figure(f1);
    rocAxis = subplot(2,2,1);
    plot(match.ROC(:,1),match.ROC(:,2),'r-','linewidth',2)
    hold on
    plot(match.ROC(idx,1),match.ROC(idx,2),'kx','linewidth',2,'markersize',15)
    hold off
    title(['ROC-curve, AUC = ' num2str(match.ROCAUC)])
    xlabel('FPR')
    ylabel('Recall (TPR)')
    axis image
    axis([0 1 0 1])

    prAxis = subplot(2,2,2);
    plot(match.PR(:,2),1-match.PR(:,1),'r-','linewidth',2)
    hold on
    plot(match.PR(idx,2),1-match.PR(idx,1),'kx','linewidth',2,'markersize',15)
    hold off
    title(['PR-curve, AUC = ' num2str(match.PRAUC)])
    xlabel('Recall (TPR)')
    ylabel('Precision')
    axis image
    axis([0 1 0 1])

    Pidx = match.distRatio <= t;
    TPidx = Pidx & (match.CorrectMatch == 1);
    FPidx = Pidx & (match.CorrectMatch == -1);
    UPidx = Pidx & (match.CorrectMatch == 0);
    TNidx = ~Pidx & (match.CorrectMatch == -1);
    FNidx = ~Pidx & (match.CorrectMatch == 1);
    UNidx = ~Pidx & (match.CorrectMatch == 0);

    posMatchAxis = subplot(2,2,3);
    imshow(I)
    hold on
    plot(match.coord(TPidx,1),match.coord(TPidx,2),'g.')
    plot(match.coord(FPidx,1),match.coord(FPidx,2),'r.')
    plot(match.coord(UPidx,1),match.coord(UPidx,2),'y.')
    hold off
    title('Classified as positive matches')

    negMatchAxis =subplot(2,2,4);
    imshow(I)
    hold on
    plot(match.coord(TNidx,1),match.coord(TNidx,2),'g.')
    plot(match.coord(FNidx,1),match.coord(FNidx,2),'r.')
    plot(match.coord(UNidx,1),match.coord(UNidx,2),'y.')
    hold off
    title('Classified as negative matches')

    suptitle(['t = ' num2str(t) ...
        ': consistent = ' num2str(sum(TPidx)+sum(FNidx)) ...
        ', inconsistent = ' num2str(sum(FPidx)+sum(TNidx)) ...
        ', unknown = ' num2str(sum(UPidx)+sum(UNidx))])

    while true
        [i,j,btn,clickedAxis] = myGinput(1);
        if btn == 27
            return;
        elseif btn == 1
            lims = [xlim; ylim];
            if all([i;j] >= lims(:,1) & [i;j] <= lims(:,2))
                if clickedAxis == rocAxis
                    dists = (match.ROC(:,1)-i) .^ 2 + (match.ROC(:,2)-j) .^ 2;
                    [~,idx] = min(dists);
                    t = T(idx);
                    break;
                elseif clickedAxis == prAxis
                    dists = (match.PR(:,1)-i) .^ 2 + (match.PR(:,2)-j) .^ 2;
                    [~,idx] = min(dists);
                    t = T(idx);
                    break;
                elseif any(clickedAxis == [posMatchAxis negMatchAxis])
                    if clickedAxis == posMatchAxis
                        wantedIdx = Pidx;
                    else
                      wantedIdx = ~Pidx;
                    end
                    dists = ones(size(wantedIdx)) * Inf;
                    dists(wantedIdx) = (imRes.X(wantedIdx,1)-i).^2 +...
                    (imRes.X(wantedIdx,2)-j).^2;

                    [~,idx] = min(dists);
                    x = imRes.X(idx,:);
                    d = imRes.D(idx,:);
                    matchIdx = match.matchIdx(idx,:);
                    matchX = keyRes.X(matchIdx,:);
                    matchD = keyRes.D(matchIdx,:);
                    desInd = 1:numel(d);

                    % Create new figure showing details about the
                    % chosen match
                    f2 = figure('units','normalized','outerposition',[0 0 1 1]);
                    matchType = 'positive';
                    if ~Pidx(idx)
                        matchType = 'negative';
                    end
                    suptitle(['Matched (' matchType ') descriptors ratio: ' num2str(match.distRatio(idx))]);

                    subplot(2,3,1);
                    title(['Feature to match (coordinates: ' nums2str(x) ')']);
                    hold on;

                    if (Pidx(idx) && match.CorrectMatch(idx) == 1) ...
                           || (~Pidx(idx) && match.CorrectMatch(idx) == -1)
                        color = 'g';
                    elseif match.CorrectMatch(idx) == 0
                        color = 'y';
                    else
                        color = 'r';
                    end
                    plotPatch(I,x,[150 150],color);

                    subplot(2,3,2);
                    title(['Best matching feature (coordinates: ' nums2str(matchX(1,:)) ')']);
                    hold on;
                    plotPatch(Ikey,matchX(1,:),[150 150],color);

                    subplot(2,3,3);
                    title(['2nd best matching feature (coordinates: ' nums2str(matchX(2,:)) ')']);
                    hold on;
                    plotPatch(Ikey,matchX(2,:),[150 150],color);

                    subplot(2,3,5);
                    title(['Distance to best match: ' num2str(match.dist(idx,1))]);
                    hold on;
                    plot(desInd,d,'-b');
                    plot(desInd,matchD(1,:),'-r');
                    axis([1 numel(d) 0 max(max(d,matchD(1,:)))]);
                    legend('D','D_1');
                    xlabel('Descriptor index');
                    ylabel('value');

                    subplot(2,3,6);
                    title(['Distance to 2nd best match: ' num2str(match.dist(idx,2))]);
                    hold on;
                    plot(desInd,d,'-b');
                    plot(desInd,matchD(2,:),'-r');
                    axis([1 numel(d) 0 max(max(d,matchD(1,:)))]);
                    legend('D','D_2');
                    xlabel('Descriptor index');
                    ylabel('value');
                    figure(f1);
                end
            end
        end
    end
end
end
