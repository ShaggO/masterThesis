function plotInriaResults(varargin)

colours = {'r-','b-'};

figure

for i = 1:numel(varargin)
    load(varargin{i});
%     ROCAUC
    loglog(ROC(:,1)+eps,1-ROC(:,2)+eps,colours{i});
%     plot(PR(:,2)+eps,1-PR(:,1),colours{i});
    hold on
end

grid on
xlabel('FPR');
ylabel('1-TPR');
axis([1e-6 1e-1 0.01 0.5]);
% axis([0.9 1 0.9 1])
legend(cellfun(@fileName,varargin),'interpreter','none','location','southwest')

end

function s = fileName(path)

[~,s,~] = fileparts(path);
s = {s};

end