clc, clear all, close all

load('cellHistExampleGo')

n = 60;

fig('unit','inches','width',6,'height',6,'fontsize',8);
visualizeCellHist({L.none},P(n,:),H(:,:,n),cells,binC,2,'go')
set(gcf,'color','w');
path = '../report/img/cellHistFigureGo.pdf';
% export_fig('-r300',path);
saveTightFigure(gcf,path)

load('cellHistExampleSi')

n = 60;

fig('unit','inches','width',6,'height',6,'fontsize',8);
visualizeCellHist({L.none},P(n,:),H(:,:,n),cells,binC,2,'si')
set(gcf,'color','w');
path = '../report/img/cellHistFigureSi.pdf';
% export_fig('-r300',path);
saveTightFigure(gcf,path)

%figh = fig('unit','inches','width',6,'height',4,'fontsize',8);
figh = figure('units','pixels');
x = [binC binC]';
y = [zeros(size(binC)) H(:,1,n)]';
plot(x,y,'r-','linewidth',2)
xlabel('Shape index')
xlabh = get(gca,'XLabel');
set(xlabh,'Position',get(xlabh,'Position') - [0 0.00023 0])
set(gca,'OuterPosition',get(gca,'OuterPosition') - [0 -0.12 0 0.12]);
ylabel('Bin value')
%set(gca,'box','off')
hold on;
set(gca,'XTickMode','manual');
set(gca,'XTick',x(1,:));
set(gcf,'color','white');

axh = gca;
xticks = get(gca,'xtick');
yticks = get(gca,'ytick');

set(gca,'XTickLabel','');
%set(gca,'YTickLabel','');

pos = get(axh,'position');

x1 = pos(1);
y1 = pos(2);
dlta = (pos(3)-pos(1)) / length(xticks)*2
delta = pos(3)/numel(xticks)
fhPos = get(figh,'position');
aspect = fhPos(4) / fhPos(3);

for i = 1:length(xticks)
    text(xticks(1,i),-0.00024, num2str(xticks(1,i)),'HorizontalAlignment','center');
end

I = shapeIndexImage(binC);
for i = 1:length(xticks)
%    fig('unit','inches','width',1,'height',1,'fontsize',8);
    pic = I{i};
    xPos = delta*(i-1)+x1+dlta/32*aspect;

    lblAx = axes('parent',figh,'PlotBoxAspectRatioMode','manual','PlotBoxAspectRatio',[1 1 1],'position',[xPos,y1-dlta*3/4-0.001,dlta*3/4*aspect,dlta*3/4]);
    imagesc(pic,'parent',lblAx);
    axis(lblAx,'off');
    colormap('gray');
%    path = ['../report/img/cellHistFigureSiExample' num2str(i) '.png'];
%    imwrite(I{i},path);
end


path = '../report/img/cellHistFigureSiExample.pdf';
%saveTightFigure(gcf,path)
export_fig -r300 ../report/img/cellHistFigureSiExample.pdf
