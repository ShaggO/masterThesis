clc, clear all, close all

load('cellHistExample')

n = 60;

fig('unit','inches','width',6,'height',6,'fontsize',8);
visualizeCellHist({L.none},P(n,:),H(:,:,n),cells,binC,2)
set(gcf,'color','w');
path = '../report/img/cellHistFigure.pdf';
% export_fig('-r300',path);
saveTightFigure(gcf,path)