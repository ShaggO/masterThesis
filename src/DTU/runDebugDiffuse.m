clc, clear all, close all

runGenerateDiffuse
I = double(imread(dtuImagePath(1,1,'diffuse')));
% I = imadjust(I,[0 0.61],[0 1]);
J = double(imread('C:\Users\Ben\Documents\MATLAB\VIP\1\images\Img001_diffuse.tif'));

IR = I(:,:,1);
IG = I(:,:,2);
IB = I(:,:,3);
JR = J(:,:,1);
JG = J(:,:,2);
JB = J(:,:,3);
X = JR == 30 & JG == 30 & JB == 30;

[IR(X) IG(X) IB(X)]

% F = J(I > 0) ./ I(I > 0);
% hist(F(:),0.9:0.02:2.1)
% axis([1 2 0 10^6])

% sum(J(:) - I(:))
% sum((J(:) - I(:)) .^ 2)

figure
imshow(uint8(I))
figure
imshow(uint8(J))
% figure
% imshow(rgb2gray(I)-rgb2gray(J),[])