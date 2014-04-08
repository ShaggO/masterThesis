clc, clear all, close all

I1rgb = im2double(imread(dtuImagePath(1,25,20)));
I1 = rgb2gray(I1rgb);
I2rgb = im2double(imread(dtuImagePath(1,25,28)));
I2 = rgb2gray(I2rgb);

cutout = {500:899,500:1099};

S1 = dGaussScaleSpace(I1,kJetCoeffs(2),1,1);
S2 = dGaussScaleSpace(I2,kJetCoeffs(2),1,1);

M1 = diffStructure('M',S1,[1 2]);
M2 = diffStructure('M',S2,[1 2]);
M1norm = pixelNormalization(M1,'gaussian',[10 10]);
M2norm = pixelNormalization(M2,'gaussian',[10 10]);

C1 = M1{1}(cutout{:});
C2 = M2{1}(cutout{:});
C1norm = M1norm{1}(cutout{:});
C2norm = M2norm{1}(cutout{:});
maxC = max([C1(:); C2(:)]);
maxCnorm = max([C1norm(:); C2norm(:)]);

path = '../report/img/pixelNormalizationExample1.png';
imwrite(I1rgb(cutout{:},:),path);
path = '../report/img/pixelNormalizationExample2.png';
imwrite(I2rgb(cutout{:},:),path);

path = '../report/img/pixelNormalizationExample3.png';
imwrite(C1 / maxC,path);
path = '../report/img/pixelNormalizationExample4.png';
imwrite(C2 / maxC,path);

path = '../report/img/pixelNormalizationExample5.png';
imwrite(C1norm / maxCnorm,path);
path = '../report/img/pixelNormalizationExample6.png';
imwrite(C2norm / maxCnorm,path);
% 
% figure;
% imshow(M1{1}(cutout{:}),[]);
% figure;
% imshow(M2{1}(cutout{:}),[]);
% 
% figure;
% imshow(M3{1}(cutout{:}),[]);
% figure;
% imshow(M4{1}(cutout{:}),[]);