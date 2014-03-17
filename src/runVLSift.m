clc, clear all

I = zeros(200);
I(:,1:100) = repmat(200:-2:1,[200 1]);
I(1:80,1:30) = repmat(80:2:138,[80 1]);
I(92:108,42:58) = 200;
I(99:101,49:51) = 0;
I(142:158,92:108) = 200;
I(150,100) = 100;
% I = imread('coins.png');

[X,D] = vl_sift(single(I),'peakthresh',13,'edgethresh',100);
size(X,2)

figure
imshow(I,[0 255])
hold on
vl_plotsiftdescriptor(D,X);