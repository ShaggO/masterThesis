I1 = rgb2gray(im2double(imread(dtuImagePath(1,1,1))));
I2 = rgb2gray(im2double(imread(dtuImagePath(1,1,2))));

S1 = dGaussScaleSpace(I1,kJetCoeffs(1),1,1);
S2 = dGaussScaleSpace(I2,kJetCoeffs(1),1,1);

M1 = diffStructure('M',S1,1);
M1 = M1{1};
M2 = diffStructure('M',S2,1);
M2 = M2{1};

figure;
imshow(M1,[]);
figure;
imshow(M2,[]);

M3 = pixelNormalization(M1,'gaussian',[10 10]);
M4 = pixelNormalization(M2,'gaussian',[10 10]);
figure;
imshow(M3,[]);
figure;
imshow(M4,[]);

figure;
imshow(I1);
figure;
imshow(I2);
