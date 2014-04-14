clc, clear all

Isizes = [1200 1600 1; 1200 1600 1];
F = [200.5 500 1];
scales = [1 2];
rescale = 0;
P = scaleSpaceFeatures(F,scales,rescale)
% P = [300 500 1 1; 800 200 1 2; 250 250 2 1];
gridType = 'polar';
gridSize = [8 2];
gridSpacing = 50;
centerType = 'gaussian';
centerSigma = [10 10];
cellType = 'gaussian';
cellSigma = [5 5];
    
[C,W,validP] = createCells(Isizes,P,gridType,gridSize,gridSpacing,...
    centerType,centerSigma,cellType,cellSigma);
map = C.map
Cpart = C.partData(1);
Wpart = W.partData(1);
% Cpart = Cpart(Cpart <= 1200*1600);
% C = C(C > 1200*1600)-1200*1600;

I = zeros(Isizes(1,1:2));
I(Cpart) = Wpart;
figure
imshow(I,[])