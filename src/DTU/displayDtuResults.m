function displayDtuResults(plotROCAUC,plotPRAUC,pathTypes,testType,plotParams,mNames)

[imNumKey,liNumKey,imNum,liNum,pathLabels] = dtuPaths(testType);

% Display results
for k = pathTypes % Generate figure for each image path
    if any(pathTypes == 1) && k == 1
        before = find(imNum{k} < imNumKey,1,'last');
    else
        before = 0;
    end
    if numel(liNum{k}) > 1
        x = liNum{k};
    else
        x = imNum{k};
    end

    figure('units','normalized','outerposition',[0 0 1 1]);
    h = zeros(numel(plotParams),1);
    hold on;
    for i = 1:numel(plotParams)
        plot(x(1:before),plotROCAUC{i,k}(1:before),plotParams{i}{:});
        h(i) = plot(x(before+1:end),plotROCAUC{i,k}(before+1:end),plotParams{i}{:});
    end
    padding = (x(end)-x(1))/20;
    axis([x(1)-padding x(end)+padding 0 1]);
    title(['ROC AUC ' pathLabels{k} ]);
    l = legend(h,mNames{:});
    set(l,'interpreter','none','location','southeast');

    figure('units','normalized','outerposition',[0 0 1 1]);
    hold on;
    for i = 1:numel(plotParams)
        plot(x(1:before),plotPRAUC{i,k}(1:before),plotParams{i}{:});
        h(i) = plot(x(before+1:end),plotPRAUC{i,k}(before+1:end),plotParams{i}{:});
    end
    axis([x(1)-padding x(end)+padding 0 1]);
    title(['PR AUC ' pathLabels{k} ]);
    l = legend(h,mNames{:});
    set(l,'interpreter','none','location','southeast');

end

end
