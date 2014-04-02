clc, clear all

I = imread('C:\Users\Ben\Documents\GitHub\masterThesis\src\DTU\img1200x1600\SET001\Img001_diffuse.bmp');
I = rgb2gray(im2double(I));

m = [1 0 2 1 0];
n = [0 1 0 1 2];
goFunc = @(Y) atan2(Y{2}, Y{1});
mFunc = @(Y) sqrt(Y{1} .^ 2 + Y{2} .^ 2);
siFunc = @(Y) 2/pi*atan2(-Y{3}-Y{5},sqrt(4*Y{4}.^2+(Y{3}-Y{5}).^2));
cFunc = @(Y) sqrt(Y{3}.^2 + 2*Y{4}.^2 + Y{5}.^2);

S = dGaussScaleSpace(I,m,n,1,0);
GO = goFunc(S);
M = mFunc(S);
SI = siFunc(S);
C = cFunc(S);

figure
imshow(M,[0 0.2])
figure
imshow(C,[0 0.2])