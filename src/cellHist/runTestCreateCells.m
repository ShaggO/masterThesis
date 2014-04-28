clc, clear all

Isizes = [401 401 1];
F = [200 200 1];
scales = 1;
rescale = 0;
P = scaleSpaceFeatures(F,scales,rescale);
% P = [300 500 1 1; 800 200 1 2; 250 250 2 1];
gridType = 'polar central';
gridSize = [8 2];
gridSpacing = 55;
centerFilter = 'gaussian';
centerSigma = (gridSize(2)+1)*[gridSpacing gridSpacing];
cellFilter = 'polar gaussian';
cellSigma = [pi/gridSize(1) gridSpacing/2];
cellNormStrategy = 0;

[validP,C,Wcell,Wcen] = createCells(Isizes,P,gridType,gridSize,gridSpacing,...
    centerFilter,centerSigma,cellFilter,cellSigma,cellNormStrategy);

% I = zeros(Isizes(1,1:2));
% I(Cpart) = Wpart;
% figure
% imshow(I,[])

figure
axis([1 401 1 401 0 3*max(Wcell.vector)])
colormap jet
view([1 2 3])
axis off
hold on

Itotal = zeros(Isizes(1,1:2));
for i = 1:numel(C.data)
    Cpart = C.data{i};
    Wpart = Wcell.data{i};
    for j = 1:size(Cpart,3)
        I = zeros(Isizes(1,1:2));
        I(Cpart(:,:,j)) = Wpart(:,:,j);
        surf(I,'FaceAlpha',0.8,'EdgeColor','none');
    end
end