clc, clear

d1 = 450;
d2 = 580;
d3 = 750;
v = [350 150];

[x,y] = pol2cart((0:pi/4:7/4*pi)',ones(8,1));
p = d3*[x y];
s = 2/pi*atan2(x+y,x-y);
S = round(10*2/pi*atan((x+y)./(sign(x-y).*(x-y))))/10;

figure
set(gcf,'color','w');
axis equal off
drawCircle(0,0,d1)
plot([-d2 d2],[0 0],'k-')
plot([0 0],[-d2 d2],'k-')
plot(sqrt(2)/2*[-d1 d1],sqrt(2)/2*[d1 -d1],'k--')
plot(sqrt(2)/2*[-d1 d1],sqrt(2)/2*[-d1 d1],'k--')
text(d2-50,70,'\kappa_1','HorizontalAlignment','center','fontsize',14)
text(70,d2-50,'\kappa_2','HorizontalAlignment','center','fontsize',14)
colormap('gray')
for i = 1:8
    I = shapeIndexImage(s(i));
    I = imnorm(I);
    hold on
    imagesc(p(i,1)-100,p(i,2)-70,I)
    text(p(i,1),p(i,2)-110,['S = ' num2str(S(i))],'HorizontalAlignment','center')
end

% quiver(0,0,300,200,'k-')

ah = annotation('arrow','color','b',...
        'headStyle','cback1','linewidth',1,'HeadLength',15000,'HeadWidth',10000);
set(ah,'parent',gca);
set(ah,'position',[0 0 v(1) v(2)]);
drawAngle(0,0,-pi/4,atan2(v(2),v(1)),80,'b')
text(v(1)/2-20,v(2)/2+50,'C','HorizontalAlignment','center','fontsize',14,'color','b')
text(120,-20,'\phi','HorizontalAlignment','center','fontsize',14,'color','b')

path = '../report/img/shapeIndexTheory.pdf';
export_fig('-r300',path);
open(path)