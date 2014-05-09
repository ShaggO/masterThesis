clc, clear all, close all

load('cellHistExample')

figure
imshow(I)
hold on
drawCircle(F(:,1),F(:,2),F(:,3),'g')