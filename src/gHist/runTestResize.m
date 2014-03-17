clc, clear all

I = im2double(imread('coins.png'));

p = [randi(size(I,2),[10 1]) randi(size(I,1),[10 1])];

sigma = 1;
hsize = 6;
gaussX = dGauss2d(1,0,hsize,sigma);
gaussY = dGauss2d(0,1,hsize,sigma);

Ix = imfilter(I,gaussX,'replicate','conv');
Iy = imfilter(I,gaussY,'replicate','conv');

T = atan2(Iy, Ix);

figure
subplot(121)
imshow(I)
hold on
plot(p(:,1)',p(:,2)','rx')

I = imresize(I,1/2.0147384);
p = (p-1)/2.0147384+1;
Ix = imfilter(I,gaussX,'replicate','conv');
Iy = imfilter(I,gaussY,'replicate','conv');

T = atan2(Iy, Ix);

subplot(122)
imshow(I)
hold on
plot(p(:,1)',p(:,2)','rx')