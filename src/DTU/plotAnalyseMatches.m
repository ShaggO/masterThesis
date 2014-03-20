function [] = plotAnalyseMatches(match,t)

I = imread(dtuImagePath(match.setNum,match.imNum,match.liNum));

T = [0; sort(match.distRatio,'ascend')];

idx = find(T < t,1,'last');

figure('units','normalized','outerposition',[0 0 1 1])

while ~isnan(t)
    rocAxis = subplot(2,4,1);
    plot(match.ROC(:,1),match.ROC(:,2),'r-','linewidth',2)
    hold on
    plot(match.ROC(idx,1),match.ROC(idx,2),'kx','linewidth',2,'markersize',15)
    hold off
    title(['ROC-curve, AUC = ' num2str(match.ROCAUC)])
    xlabel('FPR')
    ylabel('recall (TPR)')
    axis image
    axis([0 1 0 1])
    
    prAxis = subplot(2,4,2);
    plot(match.PR(:,1),match.PR(:,2),'r-','linewidth',2)
    hold on
    plot(match.PR(idx,1),match.PR(idx,2),'kx','linewidth',2,'markersize',15)
    hold off
    title(['PR-curve, AUC = ' num2str(match.PRAUC)])
    xlabel('1-precision')
    ylabel('recall (TPR)')
    axis image
    axis([0 1 0 1])
    
    TPidx = match.distRatio <= t & (match.CorrectMatch == 1);
    FPidx = match.distRatio <= t & (match.CorrectMatch == -1);
    UPidx = match.distRatio <= t & (match.CorrectMatch == 0);
    TNidx = match.distRatio > t & (match.CorrectMatch == -1);
    FNidx = match.distRatio > t & (match.CorrectMatch == 1);
    UNidx = match.distRatio > t & (match.CorrectMatch == 0);
    
    subplot(2,4,5)
    imshow(I)
    hold on
    plot(match.coord(TPidx,1),match.coord(TPidx,2),'g.')
    plot(match.coord(FPidx,1),match.coord(FPidx,2),'r.')
    plot(match.coord(UPidx,1),match.coord(UPidx,2),'y.')
    hold off
    title('Classified as positive matches')
    
    subplot(2,4,6)
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
    
    [i,j,btn,clickedAxis] = myGinput(1);
    if btn ~= 1
        t = NaN;
    else
        if clickedAxis == rocAxis
            dists = (match.ROC(:,1)-i) .^ 2 + (match.ROC(:,2)-j) .^ 2;
            [~,idx] = min(dists);
            t = T(idx);
        elseif clickedAxis == prAxis
            dists = (match.PR(:,1)-i) .^ 2 + (match.PR(:,2)-j) .^ 2;
            [~,idx] = min(dists);
            t = T(idx);
        end
    end
end