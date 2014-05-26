clc, clear all

fig('unit','inches','width',12,'height',1,'fontsize',8)
hold on
plot(0,0,'rx','linewidth',1)
plot(0,0,'k-','linewidth',1.5)
plot(0,0,'g-','linewidth',1.5)
plot(0,0,'b--','linewidth',1.5)

h=legend(gca,'Cell centers','Cell SD','Detection scale','Grid radius', ...
    'Orientation','horizontal');
set(allchild(gca),'visible','off');
set(gca,'visible','off')
set(h,'OuterPosition',[0 0 1 1],'color',[0.95 0.95 0.95]);

% saveTightFigure(gcf,'../report/img/gridType_legend.pdf')
export_fig('-r300','../report/img/gridType_legend.pdf');