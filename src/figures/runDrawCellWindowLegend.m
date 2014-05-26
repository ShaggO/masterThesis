clc, clear all

fig('unit','inches','width',7,'height',1,'fontsize',8)
hold on
plot(0,0,'k-','linewidth',2)
plot(0,0,'y-','linewidth',2)

h=legend(gca,'Cell SD','Cell support radius', ...
    'Orientation','horizontal');
set(allchild(gca),'visible','off');
set(gca,'visible','off')
set(h,'OuterPosition',[0 0 1 1],'color',[0.95 0.95 0.95]);

% saveTightFigure(gcf,'../report/img/cellWindow_legend.pdf')
export_fig('-r300','../report/img/cellWindow_legend.pdf');