clc, clear all

fig('unit','inches','width',8,'height',16,'fontsize',8)
axis([-0.5 64.5 -0.5 128.5])
hold on
for x = 0:8:56
    for y = 0:8:120
        rectangle('position',[x y 8 8]);
    end
end
rectangle('position',[0 112 16 16],'linewidth',3)

axis off equal
saveTightFigure(gcf,'../defence/img/hogGrid.pdf')
% open('../report/img/hogGrid.pdf')
