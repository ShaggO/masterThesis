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