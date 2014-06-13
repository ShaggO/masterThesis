function plotInriaResults(varargin)

colours = {'r-','b-','c-','k-','r:','b:','c:','k:'};

ROC = cell(1,numel(varargin));
PR = ROC;
ROCAUC = zeros(1,numel(varargin));
PRAUC = ROCAUC;
for i = 1:numel(varargin)
    test = load(varargin{i});
    ROC{i} = test.ROC;
    ROCAUC(i) = test.ROCAUC;
    PR{i} = test.PR;
    PRAUC(i) = test.PRAUC;
end

%% ROC
figure
for i = 1:numel(varargin)
	loglog(ROC{i}(:,1)+eps,1-ROC{i}(:,2)+eps,colours{i});
    hold on
end
grid on
xlabel('FPR');
ylabel('1-TPR');
axis([1e-6 1e-1 0.01 0.5])
legend(cellfun(@fileName,varargin),'interpreter','none','location','southwest')

%% PR
figure
for i = 1:numel(varargin)
    plot(PR{i}(:,2)+eps,1-PR{i}(:,1),colours{i});
    hold on
end
grid on
xlabel('Recall');
ylabel('Precision');
axis([0.75 1 0 1])
legend(cellfun(@fileName,varargin),'interpreter','none','location','southwest')

end

function s = fileName(path)

[~,s,~] = fileparts(path);
s = {s};

end