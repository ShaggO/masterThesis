clc, clear all

fig('unit','inches','width',4,'height',4,'fontsize',8)
axis([-0.5 16.5 -0.5 16.5])
hold on
for x = 0:4:12
    for y = 0:4:12
        rectangle('position',[x y 4 4],'curvature',1);
    end
end

axis off equal
saveTightFigure(gcf,'../report/img/siftGrid.pdf')
open('../report/img/siftGrid.pdf')