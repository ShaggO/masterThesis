clc, clear all

Isizes = [121 121 1];
F = [61 61 1];
scales = 1;
rescale = 0;
P = scaleSpaceFeatures(F,scales,rescale);
% P = [300 500 1 1; 800 200 1 2; 250 250 2 1];
gridType = 'log-polar';
gridSize = [8 2];
gridRadius = 30;
centerFilter = 'none';
centerSigma = [1 1];
cellFilter = 'gaussian';
cellSigma = [1 1];
binSigma = 1;
binCount = 8;
normType = 'pixel';
normSigma = [2 2];
left = -1;
right = 1;
cellNormStrategy = 0;

[gridRadius,centerSigma,cellSigma,binSigma,normSigma] = ...
    scaleParameters(rescale,gridSize,gridRadius,centerSigma, ...
    cellFilter,cellSigma,binSigma,binCount,normType,normSigma,left,right);

[validP,C,Wcell,Wcen] = createCells(Isizes,P,gridType,gridSize,gridRadius,...
    centerFilter,centerSigma,cellFilter,cellSigma,cellNormStrategy);

% I = zeros(Isizes(1,1:2));
% I(Cpart) = Wpart;
% figure
% imshow(I,[])

figure
axis([1 Isizes(1) 1 Isizes(2) log(min(Wcell.vector)) log(max(Wcell.vector))])
colormap jet
view([1 2 3])
axis off
hold on

for i = 1:numel(C.data)
    Cpart = C.data{i};
    Wpart = Wcell.data{i};
    for j = 1:size(Cpart,3)
        I = ones(Isizes(1,1:2)) * log(min(Wcell.vector));
        I(Cpart(:,:,j)) = log(zWpart(:,:,j));
        surf(I,'FaceAlpha',0.8,'EdgeColor','none');
    end
end
