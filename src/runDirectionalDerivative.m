clc, clear all

hsize = 200;
sigma = 50;
Ix = gauss(hsize,sigma,'x');
Iy = gauss(hsize,sigma,'y');
Ixy = sqrt(2)/2 * (Ix + Iy);

figure
imshow(Ix,[])
figure
imshow(Iy,[])
figure
imshow(Ixy,[])