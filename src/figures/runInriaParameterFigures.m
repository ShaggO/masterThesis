clc, clear all, close all

parameters = {'gridSize','cellSigma','normSigma','binSigma','binCount','logc'};
symbols = {'r','\alpha','\eta','\beta','n','log(C)'};
% name = {'Go','Si'};
name = {'Go'};
minAuc = [0.98 0.96];

for i = 1:numel(name)
    params = load(['results/optimize/inriaParameters' name{i}]);
    for j = 1:numel(parameters)
        idx = find(strcmp({params.loggerParameterResults.data.parameter},parameters{j}));
%         idx = idx(end-1:end);
        v = cell2mat({params.loggerParameterResults.data(idx).values}');
        [v,idxv] = sort(v(:,1)');
        auc = cell2mat({params.loggerParameterResults.data(idx).PRAUC});
        auc = auc(idxv);
        [maxauc,idxmaxauc] = max(auc);
        fig('unit','inches','width',7,'height',3,'fontsize',8);
        plot(v,auc)
        axis([v(1) v(end) minAuc(i) 1])
        set(gcf,'color','white')
        box on
        hold on
        xlabel(symbols{j})
        ylabel('PR AUC')
        plot(v(idxmaxauc),maxauc,'x','markersize',10)
        export_fig('-r300',['../report/img/inriaParameters' name{i} '_' parameters{j} '.pdf']);
        
        fig('unit','inches','width',7,'height',3,'fontsize',8);
        plot(v,auc)
    end
end

% for i = 1:numel(name)
%     params = load(['results/optimize/inriaParameters' name{i}]);
%     auc = [];
%     for j = 1:numel(params.logger.data)
%         if j < numel(params.logger.data) && params.logger.data(j).iteration >= params.logger.data(j+1).iteration
%             auc(end+1) = max(params.logger.data(j).PRAUC);
%         end
%     end
%     plot(1:numel(auc),auc)
%     axis([1 numel(auc) 0.98 1])
% end