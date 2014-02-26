clc, clear all

%% Parameters
hsize = 201;
sigma = 20;
m = 1;
n = 2;

%% Compute Gaussian derivative filters
g = dGauss2d(m,n,hsize,sigma);
G = fftshift(fft2(ifftshift(g)));
F = dGaussFourier2d(m,n,hsize,sigma);
f = fftshift(real(ifft2(ifftshift(F))));

%% 2D figures
r = max(abs(g(:)));
R = max(abs(G(:)));
figure('units','normalized','outerposition',[0 0 1 1])
subplot(231)
imshow(g,[-r r])
title('Spatial')
subplot(232)
imshow(abs(G),[0 R])
title('Fourier magnitude')
subplot(233)
imshow(angle(G),[-pi pi])
title('Fourier phase')
subplot(234)
imshow(f,[-r r])
title('Spatial')
subplot(235)
imshow(abs(F),[0 R])
title('Fourier magnitude')
subplot(236)
imshow(angle(F),[-pi pi])
title('Fourier phase')
suptitle('Gaussian derivative filter computed analytically in spatial (above) and Fourier domain (below)')

%% 1D figures
% figure
% plot(linspace(-pi,pi,hsize),abs(F),'b-')
% hold on
% plot(linspace(-pi,pi,hsize),abs(G),'r-')
% axis([-pi pi 0 1])
% 
% x = -(hsize-1)/2:(hsize-1)/2;
% figure
% plot(x,real(f),'b-')
% hold on
% plot(x,g,'r-')
% axis([x(1) x(end) 0 1])