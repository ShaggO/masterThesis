function plotInriaResults(svmPath,labels)

if nargin < 2
    labels = cellfun(@fileName,svmPath);
end

% colours = {'r-','b-','c-','k-','r:','b:','c:','k:'};
colours = {'b-','g-','c-','r-','m-','b:','g:','c:','r:','m:'};

ROC = cell(1,numel(svmPath));
PR = ROC;
ROCAUC = zeros(1,numel(svmPath));
PRAUC = ROCAUC;
for i = 1:numel(svmPath)
    test = load(svmPath{i});
    ROC{i} = test.ROC;
    ROCAUC(i) = test.ROCAUC;
    PR{i} = test.PR;
    PRAUC(i) = test.PRAUC;
end

%% ROC
figure
set(gcf,'color','white');
for i = 1:numel(svmPath)
	loglog(ROC{i}(:,1)+eps,1-ROC{i}(:,2)+eps,colours{i});
    hold on
end
grid on
xlabel('FPR');
ylabel('1-TPR');
axis([1e-6 1e-1 0.01 0.5])
legend(labels,'interpreter','none','location','southwest')
export_fig('../report/img/inriaTestResultsROC.pdf','-r300');

%% PR
figure
set(gcf,'color','white');
for i = 1:numel(svmPath)
    plot(PR{i}(:,2)+eps,1-PR{i}(:,1),colours{i});
    hold on
end
grid on
xlabel('Recall');
ylabel('Precision');
axis([0.75 1 0 1])
legend(labels,'interpreter','none','location','southwest')
export_fig('../report/img/inriaTestResultsPR.pdf','-r300');

end

function s = fileName(path)

[~,s,~] = fileparts(path);
s = {s};

end
