clc, clear all, close all

parameters = {'normSigma','logc','cellSigma','gridSize','binCount'};
name = {'Go'};
for j = 1:numel(parameters)
    for i = 1:numel(name)
        load(['results/optimize/inriaParameters' name{i}]);
        
        idx = find(strcmp({logger.data.parameter},parameters{j}));
        idx = idx(end-1:end);
        v = cell2mat({logger.data(idx).values}');
        [v,idxv] = sort(v(:,1)');
        auc = cell2mat({logger.data(idx).PRAUC});
        auc = auc(idxv);
        [maxauc,idxmaxauc] = max(auc);
        figure
        plot(v,auc)
        hold on
        plot(v(idxmaxauc),maxauc,'x','markersize',10)
    end
end