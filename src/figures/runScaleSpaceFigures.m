clc, clear all, close all

load('cellHistExample')

figure
visualizeScaleSpaces({L.none},scales,[0 1],P,validP);
hold on;
c = colorbar;
ylabel(c,'Grayscale intensity')
set(gcf,'color','w');
path = '../report/img/cellHistScaleSpacesP.pdf';
export_fig('-r300',path);

figure
visualizeScaleSpaces(Vscales,scales,[-pi pi]);
colormap('hsv')
c = colorbar;
ylabel(c,'Gradient orientation')
set(gcf,'color','w');
path = '../report/img/cellHistScaleSpacesV.pdf';
export_fig('-r300',path);

figure
visualizeScaleSpaces(Mscales,scales,[0 0.3]);
c = colorbar;
ylabel(c,'Gradient magnitude')
set(gcf,'color','w');
path = '../report/img/cellHistScaleSpacesM.pdf';
export_fig('-r300',path);

figure
visualizeScaleSpaces(MscalesNorm,scales,[]);
c = colorbar;
ylabel(c,'Normalized gradient magnitude')
set(gcf,'color','w');
path = '../report/img/cellHistScaleSpacesMnorm.pdf';
export_fig('-r300',path);

figure
visualizeScaleSpaces(vector2cells(maskC,Isizes),scales,[0 1]);
path = '../report/img/cellHistScaleSpacesMask.pdf';
export_fig('-r300',path);

B = zeros(size(V,1),nBin);
B(:) = ndBinWeights(V(:),binC,binF,binR, ...
    'period',period,'wBin',wRenorm) .* repmat(M(:),[1 nBin]);
    ½
for i = 1:binCount
    figure
    visualizeScaleSpaces(vector2cells(B(:,i),Isizes),scales,[]);
    c = colorbar;
    ylabel(c,'Bin value')
    set(gcf,'color','w');
    path = sprintf('../report/img/cellHistScaleSpacesBin%.2d.pdf',i);
    export_fig('-r300',path);
end

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
visualizeScaleSpaces(Iw.data,scales,[],zeros(0,4),zeros(0,1),true);
c = colorbar;
ylabel(c,'Spatial weights')
set(gcf,'color','w');
path = '../report/img/cellHistScaleSpacesSpatialWeights.pdf';
export_fig('-r300',path);