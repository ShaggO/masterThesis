clc, clear all

figure
hold on
for x = 0:4:12
    for y = 0:4:12
        rectangle('position',[x y 4 4]);
    end
end
axis off equal
saveas(gcf,'img/sift.pdf')