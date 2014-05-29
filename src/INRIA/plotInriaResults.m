function plotInriaResults(varargin)

colours = {'r-','b-'};

figure

for i = 1:numel(varargin)
    load(varargin{i});
    ROCAUC
    loglog(ROC(:,1)+eps,1-ROC(:,2)+eps,colours{i});
    hold on
end

grid on
xlabel('FPR');
ylabel('1-recall');
axis([1e-6 1e-1 0.01 0.5]);
legend(cellfun(@fileName,varargin),'interpreter','none')

end

function s = fileName(path)

[~,s,~] = fileparts(path);
s = {s};

end