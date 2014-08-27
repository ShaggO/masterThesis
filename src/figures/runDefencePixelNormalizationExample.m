clc, clear all

I1rgb = im2double(imread('../defence/img/shoeOriginal.jpg'));
I1 = rgb2gray(I1rgb);
I2rgb = im2double(imread('../defence/img/shoeDark.jpg'));
I2 = rgb2gray(I2rgb);

%cutout = {520:899,500:1099};

S1 = dGaussScaleSpace(I1,kJetCoeffs(2),1,1,true);
S2 = dGaussScaleSpace(I2,kJetCoeffs(2),1,1,true);

M1 = diffStructure('M',S1,[1 2]);
M2 = diffStructure('M',S2,[1 2]);
M1norm2 = pixelNormalizationVar(M1,'gaussian',[5 5]);
M2norm2 = pixelNormalizationVar(M2,'gaussian',[5 5]);

C1 = M1{1};
C2 = M2{1};
C1norm2 = M1norm2{1};
C2norm2 = M2norm2{1};
maxC = max([C1(:); C2(:)]);
maxCnorm2 = max([C1norm2(:); C2norm2(:)]);

path = '../defence/img/pixelNormalizationExample1.png';
imwrite(I1rgb,path);
path = '../defence/img/pixelNormalizationExample2.png';
imwrite(I2rgb,path);

path = '../defence/img/pixelNormalizationExample3.png';
imwrite(C1 / maxC,path);
path = '../defence/img/pixelNormalizationExample4.png';
imwrite(C2 / maxC,path);

path = '../defence/img/pixelNormalizationExample5.png';
imwrite(C1norm2 / max(C1norm2(:)),path);
path = '../defence/img/pixelNormalizationExample6.png';
imwrite(C2norm2 / max(C2norm2(:)),path);
