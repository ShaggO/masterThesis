function [X,D] = dtuFeatures(dFunc, setNum, imNum, liNum)
% Wrapper function for extracting features from a DTU Robot image

path = sprintf('img1200x1600/SET%.3d/Img%.3d_%.2d.bmp',setNum,imNum,liNum);
I = rgb2gray(imread(path));
[X,D] = dFunc(I);

end