clc, clear all, close all

load('cellHistExample')

n = 60;

figure
subplot(1,2,1)
visualizeCellHist({L.none},P(n,:),H(:,:,n),cells,binC,2)

subplot(1,2,2)
imshow(H(:,:,n),[])