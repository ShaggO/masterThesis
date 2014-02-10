clc, clear all

% I = im2double(rgb2gray(imread('../data/img1200x1600/SET012/Img001_01.bmp')));
I = repmat(linspace(1,0,500),[500 1]);

figure
imshow(I)
hold on

sigma = 1;
nBlock = 3;
nCell = 30;
bins = 8;
D = hogsi(I,[200 200],sigma,nBlock,nCell,bins)