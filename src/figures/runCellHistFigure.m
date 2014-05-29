clc, clear all, close all

% load('cellHistExampleGo')
% 
% n = 60;
% 
% fig('unit','inches','width',6,'height',6,'fontsize',8);
% visualizeCellHist({L.none},P(n,:),H(:,:,n),cells,binC,2,'go')
% set(gcf,'color','w');
% path = '../report/img/cellHistFigureGo.pdf';
% % export_fig('-r300',path);
% saveTightFigure(gcf,path)

load('cellHistExampleSi')

n = 60;

fig('unit','inches','width',6,'height',6,'fontsize',8);
visualizeCellHist({L.none},P(n,:),H(:,:,n),cells,binC,2,'si')
set(gcf,'color','w');
path = '../report/img/cellHistFigureSi.pdf';
% export_fig('-r300',path);
saveTightFigure(gcf,path)

fig('unit','inches','width',6,'height',4,'fontsize',8);
x = [binC binC]';
y = [zeros(size(binC)) H(:,1,n)]';
plot(x,y,'r-','linewidth',2)
xlabel('Shape index')
ylabel('Bin value')
set(gca,'box','off')
path = '../report/img/cellHistFigureSiExample.pdf';
saveTightFigure(gcf,path)

I = shapeIndexImage(binC);
for i = 1:numel(I)
    fig('unit','inches','width',1,'height',1,'fontsize',8);
    imshow(I{i})
    path = ['../report/img/cellHistFigureSiExample' num2str(i) '.png'];
    imwrite(I{i},path);
end