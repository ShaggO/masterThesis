clc, clear all

R = [6 11 15];

figure
hold on
for i = 1:3
    drawCircle(0,0,R(i));
end
for theta = pi/4:pi/4:2*pi
    plot([R(1)*sin(theta) R(end)*sin(theta)],[R(1)*cos(theta) R(end)*cos(theta)],'k')
end

axis off equal
saveas(gcf,'figures/img/gloh.pdf')