clc, clear all

R = [5 10 15];
Sigma = R/2;
color = {'r','g','b'};

figure
plot(0,0,'k+')
drawCircle(0,0,2.55,'r')
hold on
for theta = pi/4:pi/4:2*pi
    for i = 1:3
        x = R(i)*sin(theta);
        y = R(i)*cos(theta);
        plot(x,y,'k+')
        drawCircle(x,y,Sigma(i),color{i});
    end
end
axis off equal
saveas(gcf,'img/daisy.pdf')