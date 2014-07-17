function plotInriaResults(svmPath,labels)

if nargin < 2
    labels = cellfun(@fileName,svmPath);
end

% colours = {'r-','b-','c-','k-','r:','b:','c:','k:'};
% colours = {'b-','g-','c-','r-','m-','b:','g:','c:','r:','m:'};
colours = {'r-','g-','b-','k-','r--','r-.'};

ROC = cell(1,numel(svmPath));
PR = ROC;
ROCAUC = zeros(1,numel(svmPath));
PRAUC = ROCAUC;
for i = 1:numel(svmPath)
    test = load(svmPath{i});
%     [~,~,T] = confusionMeasure([ones(size(test.probPos)); -ones(size(test.probNeg))], ...
%         [test.probPos; test.probNeg]);
%     idx{i} = find(test.ROC(:,1) >= 10^-4,1);
%     T(idx{i})
%     idx{i} = find(T >= -10,1);
    ROC{i} = test.ROC;
    ROCAUC(i) = test.ROCAUC;
    PR{i} = test.PR;
    PRAUC(i) = test.PRAUC;
end

PRAUC

%% ROC
fig('width',8,'height',8,'unit','in','fontsize',10)
set(gcf,'color','white');
for i = 1:numel(svmPath)
	loglog(ROC{i}(:,1)+eps,1-ROC{i}(:,2)+eps,colours{i});
    hold on
end
grid on
xlabel('FPR');
ylabel('1-TPR');
axis([1e-6 1e-1 0.01 0.5])
% legend(labels,'interpreter','none','location','southwest')
% for i = 1:numel(svmPath)
%     loglog(ROC{i}(idx{i},1)+eps,1-ROC{i}(idx{i},2)+eps,[colours{i} 'o']);
% end
export_fig('../report/img/inriaTestResultsROC.pdf','-r300');

%% PR
fig('width',8,'height',8,'unit','in','fontsize',10)
set(gcf,'color','white');
for i = 1:numel(svmPath)
    plot(PR{i}(:,2)+eps,1-PR{i}(:,1),colours{i});
    hold on
end
grid on
xlabel('Recall');
ylabel('Precision');
axis([0.75 1 0 1])
% legend(labels,'interpreter','none','location','southwest')
% for i = 1:numel(svmPath)
%     loglog(PR{i}(idx{i},2)+eps,1-PR{i}(idx{i},1),[colours{i} 'o']);
% end
export_fig('../report/img/inriaTestResultsPR.pdf','-r300');

%% Legend
fig('unit','inches','width',14,'height',1,'fontsize',8);
hold on;
h = zeros(1,numel(colours));
for i = 1:numel(colours)
    h(i) = plot(0,0,colours{i});
end
set(allchild(gca),'visible','off');
set(gca,'visible','off');
%l = gridLegend(h,4,mNames);
l = legend(gca,labels{:},'Orientation','Horizontal');
set(l,'interpreter','none');
set(l,'OuterPosition',[0 0  1 1],'color',[0.95, 0.95, 0.95]);
export_fig('-r300','../report/img/inriaTestResultsLegend.pdf');

end

function s = fileName(path)

[~,s,~] = fileparts(path);
s = {s};

end
