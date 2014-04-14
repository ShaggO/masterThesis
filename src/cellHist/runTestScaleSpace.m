clc, clear all, close all

% I = im2double(imread('coins.png'));
I = zeros(5,5);
I(3,3) = 1;
d = [0 0; 1 0; 0 1];
scales = 2.^linspace(0,7,80);

tic
Sold = dGaussScaleSpace(I,d,scales,0,1,0);
told = toc
tic
S = dGaussScaleSpace(I,d,scales,0,1,1);
t = toc

s = 6;

figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,3,1)
imshow(Sold(s).x,[])

subplot(1,3,2)
imshow(S(s).x,[])

subplot(1,3,3)
imshow(S(s).x - Sold(s).x,[])

% [min(S(2).x(:)) max(S(2).x(:))]