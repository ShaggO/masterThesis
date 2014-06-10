clc, clear

d1 = 450;
d2 = 580;
d3 = 750;
v = [350 150];

[x,y] = pol2cart((0:pi/4:7/4*pi)',ones(8,1));
p = d3*[x y];
s = 0:pi/4:7/4*pi;
S = 0:45:315;

figure
set(gcf,'color','w');
axis equal off
drawCircle(0,0,d1)
plot([-d2 d2],[0 0],'k-')
plot([0 0],[-d2 d2],'k-')
plot(sqrt(2)/2*[-d1 d1],sqrt(2)/2*[d1 -d1],'k--')
plot(sqrt(2)/2*[-d1 d1],sqrt(2)/2*[-d1 d1],'k--')
text(d2-60,70,'L_x','HorizontalAlignment','center','fontsize',14)
text(60,d2-50,'L_y','HorizontalAlignment','center','fontsize',14)
colormap('gray')
for i = 1:8
    I = gradientImage(s(i));
    I = imnorm(I);
    hold on
    imagesc(p(i,1)-100,p(i,2)-70,I)
    text(p(i,1),p(i,2)-110,['\Theta = ' num2str(S(i)) sprintf('%c', char(176))],'HorizontalAlignment','center')
end

% quiver(0,0,300,200,'k-')

ah = annotation('arrow','color','b',...
        'headStyle','cback1','linewidth',1,'HeadLength',15000,'HeadWidth',10000);
set(ah,'parent',gca);
set(ah,'position',[0 0 v(1) v(2)]);
drawAngle(0,0,0,atan2(v(2),v(1)),160,'b')
text(v(1)/2-20,v(2)/2+50,'M','HorizontalAlignment','center','fontsize',14,'color','b')
text(95,-40,'\Theta','HorizontalAlignment','center','fontsize',14,'color','b')

path = '../report/img/gradientOrientationTheory.pdf';
export_fig('-r300',path);
open(path)