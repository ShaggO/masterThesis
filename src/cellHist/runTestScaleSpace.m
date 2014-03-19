clc, clear all

I = im2double(imread('coins.png'));

figure, imshow(imresize(I,1/2))
figure, imshow(dGaussScaleSpace(I, 0, 0, 2, 1),[])
figure, imshow(dGaussScaleSpace(I, 0, 0, 2, 2),[])

