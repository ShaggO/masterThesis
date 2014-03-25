clc, clear all

R = [6 11 15];

fig('unit','inches','width',4,'height',4,'fontsize',8)
axis([-15.2 15.2 -15.2 15.2])
hold on
drawCircle(zeros(size(R)), zeros(size(R)),R)
for theta = pi/4:pi/4:2*pi
    plot([R(1)*sin(theta) R(end)*sin(theta)],[R(1)*cos(theta) R(end)*cos(theta)],'k-')
end

axis equal off
saveTightFigure(gcf,'../report/img/glohGrid.pdf')
open('../report/img/glohGrid.pdf')