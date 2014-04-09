clc, clear all

setNum = 1;
imNum = 57;
liNum = 0;

I = imread(dtuImagePath(setNum,imNum,liNum));
load('DTU\results1200x1600\vl-dog-5-10\features_001-057-00')
load('DTU\results1200x1600\vl-dog-5-10_cellhist-gray-go-m-1.2599-1-concentric polar-8,2-17-box-Inf,Inf-gaussian-1,1-pixel-gaussian-2,2-gaussian-2.5-8\descriptors_001-057-00')

figure
imshow(I)
hold on
drawCircle(F(:,1),F(:,2),F(:,3),'r')

figure
imshow(I)
hold on
plot(X(:,1),X(:,2),'r.')