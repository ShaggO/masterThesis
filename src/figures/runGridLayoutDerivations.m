clc, clear all, close all

width = 1;
angleArgs = {'k-','linewidth',width};
textArgs = {'horizontalalignment','center'};
legendArgs = {'orientation','horizontal','location','north'};

%% non-concentric
tt = pi/6;
t = tt/2;
k = (1+sin(t))/(1-sin(t));
d1 = 1;
r1 = sqrt(2)/2 * sqrt(1-cos(tt))*d1;
d2 = k*d1;
r2 = k*r1;

p1 = [cos(0) sin(0)]*d1;
q1 = [cos(tt) sin(tt)]*d1;
m1 = [cos(tt/2) sin(tt/2)]*d1;
p2 = [cos(0) sin(0)]*d2;
q2 = [cos(tt) sin(tt)]*d2;
m2 = [cos(tt/2) sin(tt/2)]*d2;

fig('unit','inches','width',7*1.2,'height',4*1.2,'fontsize',8);
hold on
drawCircle(p1(1),p1(2),r1,'k')
drawCircle(p2(1),p2(2),r2,'k')
plot([p1(1) (p1(1)+q1(1))/2],[p1(2) (p1(2)+q1(2))/2],'k-')
plot([0 p2(1) (p2(1)+q2(1))/2 0],[0 p2(2) (p2(2)+q2(2))/2 0],'k-')
hd1 = plot([0 p1(1)],[0 p1(2)],'r-','linewidth',width);
hd2 = plot([0 p2(1)],[-1/3 p2(2)-1/3],'b-','linewidth',width);
hr1 = plot([(p1(1)+q1(1))/2 p1(1) p1(1)+r1],[(p1(2)+q1(2))/2 p1(2) p1(2)],'m-','linewidth',width);
hr2 = plot([p2(1)-r2 p2(1) (p2(1)+q2(1))/2],[p2(2) p2(2) (p2(2)+q2(2))/2],'c-','linewidth',width);
drawAngle((p1(1)+q1(1))/2,(p1(2)+q1(2))/2,pi+t,pi+t+pi/2,1/25,angleArgs{:})
drawAngle((p2(1)+q2(1))/2,(p2(2)+q2(2))/2,pi+t,pi+t+pi/2,1/25,angleArgs{:})
drawAngle(0,0,0,t,1/(15*t),angleArgs{:})
text(1/(2*15*t),-1/20,'\theta',textArgs{:})
legend([hd1 hd2 hr1 hr2],'d_1','d_2','r_1','r_2',legendArgs{:})
axis equal off
rectangle('Position',[-0.1 -0.5 2.35 1.3],'Curvature',[0 0],'EdgeColor','white');
filePath = '../report/img/gridLayoutDerivationNormal.pdf';
saveTightFigure(gcf,filePath);
open(filePath);

figure
hold on
drawCircle(p1(1),p1(2),r1,'k')
drawCircle(p2(1),p2(2),r2,'k')
plot([p1(1) (p1(1)+q1(1))/2],[p1(2) (p1(2)+q1(2))/2],'k-')
plot([0 p2(1) (p2(1)+q2(1))/2 0],[0 p2(2) (p2(2)+q2(2))/2 0],'k-')
axis equal

%% concentric
beta = -real(log((exp(-(t*1i)/2)*(exp(t*1i) + exp(t*2*1i) + 1)^(1/2) + 1i)/(exp(t*1i) + 1))*1i);
k = 1/sin(beta) - 1;
d2 = k*d1;
r2 = k*r1;

p2 = [cos(0) sin(0)]*d2;
q2 = [cos(tt) sin(tt)]*d2;
m2 = [cos(tt/2) sin(tt/2)]*d2;

fig('unit','inches','width',7*1.2,'height',5*1.2,'fontsize',8);
hold on
drawCircle(p1(1),p1(2),r1,'k')
drawCircle(m2(1),m2(2),r2,'k')
plot([p1(1) (p1(1)+q1(1))/2],[p1(2) (p1(2)+q1(2))/2],'k-')
plot([0 m2(1) m2(1) 0],[0 0 m2(2) 0],'k-')
hd1 = plot([0 p1(1)],[0 p1(2)],'r-','linewidth',width);
hd2 = plot([0 m2(1)],[0 m2(2)],'b-','linewidth',width);
hr1 = plot([(p1(1)+q1(1))/2 p1(1) p1(1)+(m2(1)-p1(1))*r1/(r1+r2)],...
    [(p1(2)+q1(2))/2 p1(2) p1(2)+(m2(2)-p1(2))*r1/(r1+r2)],'m-','linewidth',width);
hr2 = plot([p1(1)+(m2(1)-p1(1))*r1/(r1+r2) m2(1) m2(1)],...
    [p1(2)+(m2(2)-p1(2))*r1/(r1+r2) m2(2) 0],'c-','linewidth',width);
drawAngle((p1(1)+q1(1))/2,(p1(2)+q1(2))/2,pi+t,pi+t+pi/2,1/25,angleArgs{:})
drawAngle(m2(1),0,pi/2,pi,1/25,angleArgs{:})
drawAngle(0,0,0,t,1/(15*t),angleArgs{:})
text(1/(2*15*t),-1/20,'\theta',textArgs{:})
drawAngle(m2(1),m2(2),pi+t,pi+t+beta,1/(15*beta),angleArgs{:})
text(m2(1)-1/(2*15*beta),m2(2)+1/20,'\beta',textArgs{:})
drawAngle(p1(1),p1(2),0,t+beta,1/(15*(t+beta)),angleArgs{:})
text(p1(1)+1/(2*15*(t+beta)),p1(2)-1/20,'\alpha',textArgs{:})
legend([hd1 hd2 hr1 hr2],'d_1','d_2','r_1','r_2',legendArgs{:})
axis equal off
rectangle('Position',[-0.1 -0.35 2.15 1.5],'Curvature',[0 0],'EdgeColor','white');
filePath = '../report/img/gridLayoutDerivationConcentric.pdf';
saveTightFigure(gcf,filePath);
open(filePath);