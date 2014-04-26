clc, clear all, close all

Irgb = loadDtuImage(1,12,0);
I = rgb2gray(im2single(Irgb));

[F,D,info] = vl_covdet(255*I,...
    'PeakThreshold',6.5,...
    'EdgeThreshold',10,...
    'OctaveResolution',3);

d = [0 0; kJetCoeffs(2)];
scales = 2^(1/3) .^ (0:20);
rescale = 2;
[L,Isizes] = dGaussScaleSpace(I,d,scales,rescale);

% figure
% vl_plotss(info.gss)
% figure
% vl_plotss(info.css)

figure
imshow(info.gss.data{4}(:,:,5),[])

figure
imshow(L(12).none,[])