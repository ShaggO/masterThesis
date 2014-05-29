clc, clear all

p = gridDetector([128 64],'triangle',[1],3);
p2 = createCellOffsets('triangle window',3,[134 70],3*[1 1]);
p2 = p2 + repmat(([64 128]+1)/2,[size(p2,1) 1]);

figure
hold on
plot(p(:,1),p(:,2),'rx')
plot(p2(:,1),p2(:,2),'bx')
rectangle('Position',[0 0 64 128])
axis equal