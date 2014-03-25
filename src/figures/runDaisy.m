clc, clear all

R = [5 10 15];
Sigma = R/2;
color = {'r','g','b'};

fig('unit','inches','width',4,'height',4,'fontsize',8)
axis([-23 23 -23 23])
hold on
plot(0,0,'k+')
drawCircle(0,0,2.55,'r')
for theta = pi/4:pi/4:2*pi
    for i = 1:3
        x = R(i)*sin(theta);
        y = R(i)*cos(theta);
        plot(x,y,'k+')
        drawCircle(x,y,Sigma(i),color{i});
    end
end

axis off equal
saveTightFigure(gcf,'../report/img/daisyGrid.pdf')
open('../report/img/daisyGrid.pdf')