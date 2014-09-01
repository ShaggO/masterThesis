clc, clear all

eta = 7;

I1rgb = im2double(imread('../defence/img/shoeOriginal.jpg'));
I1 = rgb2gray(I1rgb);
I2rgb = im2double(imread('../defence/img/shoeShadow.jpg'));
I2 = rgb2gray(I2rgb);

%cutout = {520:899,500:1099};

S1 = dGaussScaleSpace(I1,kJetCoeffs(2),1,1,true);
S2 = dGaussScaleSpace(I2,kJetCoeffs(2),1,1,true);

M1 = diffStructure('M',S1,[1 2]);
M2 = diffStructure('M',S2,[1 2]);
M1norm = pixelNormalization(M1,'gaussian',eta*[1 1]);
M2norm = pixelNormalization(M2,'gaussian',eta*[1 1]);

C1 = M1{1};
C2 = M2{1};
C1norm = M1norm{1};
C2norm = M2norm{1};
maxC = max([C1(:); C2(:)]);
maxCnorm2 = max([C1norm(:); C2norm(:)]);

C1 = 2*C1 / maxC;
C2 = 2*C2 / maxC;
C1norm = 2*C1norm / maxCnorm2;
C2norm = 2*C2norm / maxCnorm2;

path = '../defence/img/pixelNormalizationExample1.png';
imwrite(I1rgb,path);
path = '../defence/img/pixelNormalizationExample2.png';
imwrite(I2rgb,path);

path = '../defence/img/pixelNormalizationExample3.png';
imwrite(C1,path);
path = '../defence/img/pixelNormalizationExample4.png';
imwrite(C2,path);

path = '../defence/img/pixelNormalizationExample5.png';
imwrite(C1norm,path);
path = '../defence/img/pixelNormalizationExample6.png';
imwrite(C2norm,path);

% figure
% subplot(1,2,1)
% imshow(C1norm2 / maxCnorm2)
% subplot(1,2,2)
% imshow(C2norm2 / maxCnorm2)
