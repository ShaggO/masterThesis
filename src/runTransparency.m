clc, clear all

I = imread('coins.png');
J = zeros(size(I));
J(:,1:200) = 1;

figure
imshow(I/2)
hold on 
h = imshow(I);
set(h, 'AlphaData', J)
hold off
