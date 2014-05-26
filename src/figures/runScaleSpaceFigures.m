clc, clear all, close all

load('cellHistExampleGo')

figure
visualizeScaleSpaces({L.none},scales,[0 1],gray(256),'Grayscale intensity',P,validP);
set(gcf,'color','w');
path = '../report/img/cellHistScaleSpacesP.pdf';
export_fig('-r300',path);

figure
visualizeScaleSpaces(Vscales,scales,[-pi pi],hsv(256),'Gradient orientation');
set(gcf,'color','w');
path = '../report/img/cellHistScaleSpacesV.pdf';
export_fig('-r300',path);

figure
visualizeScaleSpaces(Mscales,scales,[0 0.3],gray(256),'Gradient magnitude');
set(gcf,'color','w');
path = '../report/img/cellHistScaleSpacesM.pdf';
export_fig('-r300',path);

figure
visualizeScaleSpaces(MscalesNorm,scales,[],gray(256),'Normalized gradient magnitude');
set(gcf,'color','w');
path = '../report/img/cellHistScaleSpacesMnorm.pdf';
export_fig('-r300',path);

%% Spatial weights
W = zeros(sum(prod(Isizes,2)),1);
for i = 1:numel(C.data)
    for j = 1:size(C.data{i},3)
        for k = 1:size(C.data{i},4)
            W(C.data{i}(:,:,j,k)) = max(W(C.data{i}(:,:,j,k)), ...
                Wcell.data{i}(:,:,j,k));
        end
    end
end
Iw = varArray.newVector(W,Isizes,C.map);

figure
visualizeScaleSpaces(Iw.data,scales,[],gray(256),'Spatial weights',zeros(0,4),zeros(0,1),true);
set(gcf,'color','w');
path = '../report/img/cellHistScaleSpacesSpatialWeights.pdf';
export_fig('-r300',path);

%% Bin values
B = zeros(size(V,1),nBin);
B(:) = ndBinWeights(V(:),binC,binF,binR, ...
    'period',period,'wBin',wRenorm) .* repmat(M(:),[1 nBin]);
for i = 1:binCount
    figure
    visualizeScaleSpaces(vector2cells(B(:,i),Isizes),scales,[],gray(256),'Bin values');
    set(gcf,'color','w');
    path = sprintf('../report/img/cellHistScaleSpacesBin%.2d.pdf',i);
    export_fig('-r300',path);
end

%% Shape index

clear all
load('cellHistExampleSi')

figure
visualizeScaleSpaces(Vscales,scales,[-1 1],jet(256),'Shape index');
set(gcf,'color','w');
path = '../report/img/cellHistScaleSpacesS.pdf';
export_fig('-r300',path);

figure
visualizeScaleSpaces(Mscales,scales,[0 0.3],gray(256),'Curvedness');
set(gcf,'color','w');
path = '../report/img/cellHistScaleSpacesC.pdf';
export_fig('-r300',path);

figure
visualizeScaleSpaces(MscalesNorm,scales,[],gray(256),'Normalized curvedness');
set(gcf,'color','w');
path = '../report/img/cellHistScaleSpacesCnorm.pdf';
export_fig('-r300',path);