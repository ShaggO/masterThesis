clc, clear all

p = gridDetector([128 64],'square',[1],3);
plot(p(:,1),p(:,2),'bx')
axis equal