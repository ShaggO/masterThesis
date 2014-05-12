clc, clear all, close all

load('cellHistExample')

figure
imshow(I)
hold on
drawCircle(F(:,1),F(:,2),F(:,3),'g')
c = colorbar;
ylabel(c,'Grayscale intensity')
set(gcf,'color','w');
path = '../report/img/cellHistDetector.pdf';
export_fig('-r300',path);