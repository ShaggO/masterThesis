clc, clear all

fig('unit','inches','width',15,'height',2,'fontsize',8)
hold on
plot(0,0,'rx')
plot(0,0,'k-')
plot(0,0,'g-')
plot(0,0,'b-')

h=legend(gca,'Cell centers','Cell \sigma','Detection \sigma','Grid radius', ...
    'Orientation','horizontal');
set(allchild(gca),'visible','off');
set(gca,'visible','off')
set(h,'OuterPosition',[0 0 1 1]);

saveTightFigure(gcf,'../report/img/legendTest.pdf')