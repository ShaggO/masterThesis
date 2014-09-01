function displayDtuReportResults(plotROCAUC,plotPRAUC,pathTypes,testType,plotParams,mNames,resName)

if nargin < 7
    resName = '';
end

[imNumKey,liNumKey,imNum,liNum,pathNames,pathX,pathXlabel] = dtuPaths(testType);

fig('unit','inches','width',12,'height',1,'fontsize',8);
hold on;
h = zeros(1,numel(plotParams));
for i = 1:numel(plotParams)
    h(i) = plot(0,0,plotParams{i}{:});
end
set(allchild(gca),'visible','off');
set(gca,'visible','off');
%l = gridLegend(h,4,mNames);
l = legend(gca,mNames{:},'Orientation','Horizontal');
set(l,'interpreter','none');
set(l,'OuterPosition',[0 0  1 1],'color',[0.95, 0.95, 0.95]);
export_fig('-r300',['../defence/img/dtuResults_' resName 'legend_cropped.pdf']);


% Display results
for k = pathTypes % Generate figure for each image path
    if any(pathTypes == 1) && k == 1
        before = find(imNum{k} < imNumKey,1,'last');
    else
        before = 0;
    end
    x = pathX{k};

    width = ~mod(k,2) * 7.2 + mod(k,2) * 8;
    fig('width',width,'height',4.5,'unit','in','fontsize',10)
    h = zeros(numel(plotParams),1);
    hold on;
    for i = 1:numel(plotParams)
        plot(x(1:before),plotROCAUC{i,k}(1:before),plotParams{i}{:});
        h(i) = plot(x(before+1:end),plotROCAUC{i,k}(before+1:end),plotParams{i}{:});
    end
    padding = (x(end)-x(1))/20;
    axis([x(1)-padding x(end)+padding 0.76 1]);
    xlabel([pathNames{k} ' - ' pathXlabel{k}]);
    if mod(k,2) == 1
        ylabel('Mean ROC AUC');
    end
    grid on;
    box on;
    %title(['ROC AUC ' pathNames{k} ]);
    export_fig('-r300',['../defence/img/dtuResultsROC_' resName num2str(k) '.pdf']);

    fig('width',width,'height',4.5,'unit','in','fontsize',10)
    hold on;
    for i = 1:numel(plotParams)
        plot(x(1:before),plotPRAUC{i,k}(1:before),plotParams{i}{:});
        h(i) = plot(x(before+1:end),plotPRAUC{i,k}(before+1:end),plotParams{i}{:});
    end
    axis([x(1)-padding x(end)+padding 0.58 1]);
    xlabel([pathNames{k} ' - ' pathXlabel{k}]);
    if mod(k,2) == 1
        ylabel('Mean PR AUC');
    end
    grid on;
    box on;
    %title(['PR AUC ' pathNames{k} ]);
    export_fig('-r300',['../defence/img/dtuResultsPR_' resName num2str(k) '.pdf']);

end

end
