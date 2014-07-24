function [] = plotLoggerResults(logger,xlab,name,legendArgs,dimsFlag,yRange,height,showStd)

if nargin < 4
    legendArgs = {};
end
if nargin < 5
    dimsFlag = false;
end
if nargin < 6
    if dimsFlag
        yRange = [0 12000];
    else
        yRange = [0.985 1];
    end
end
if nargin < 7
    height = 3;
end
if nargin < 8
    showStd = false;
end

fig('unit','inches','width',7,'height',height,'fontsize',8);
set(gcf,'color','white')
box on
hold on
xlabel(xlab)
if dimsFlag
    ylabel('Dimensions')
    name = [name 'Dims'];
    colours = {'b--','r--','g--'};
else
    ylabel('PR AUC')
    if numel(logger) <= 3
        colours = {'b','r','g'};
    else
        colours = [repmat({'b'},[1 6]) repmat({'r'},[1 6]) repmat({'g'},[1 6])];
    end
end

for j = 1:size(logger,2)
    for i = 1:size(logger,1)
        [v{i},idxv] = sort(logger(i,j).values(:,1)');
        minv(i) = min(v{i});
        maxv(i) = max(v{i});
        auc{i} = logger(i,j).PRAUC(idxv);
        [maxauc(i),idxmaxauc(i)] = max(auc{i});
        
        if dimsFlag
            logger(i,j).dims
            v
            dims{i} = logger(i,j).dims(idxv);
            plot(v{i},dims{i},colours{i})
        else
            if showStd
                errorbar(v{i},auc{i},logger(i,j).stdPRAUC(idxv),colours{i})
            else
                plot(v{i},auc{i},colours{i})
            end
        end
    end
    
    axis([min(minv) max(maxv) yRange])
    [~,i] = max(maxauc);
    if dimsFlag
        yMarker = dims{i}(idxmaxauc(i));
    else
        yMarker = auc{i}(idxmaxauc(i));
    end
    plot(v{i}(idxmaxauc(i)),yMarker,[colours{i} 'x'],'markersize',10)
end

if ~isempty(legendArgs)
    legend(legendArgs{:})
end
export_fig('-r300',['../report/img/' name '.pdf']);

end
