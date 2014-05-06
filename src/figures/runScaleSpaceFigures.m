clc, clear all

load('cellHistExample')

figure
visualizeScaleSpaces({L.none},scales,[0 1],1,P,validP);
% path = '../report/img/cellHistScaleSpacesP.png';
% saveas(gcf,path), cropPng(path)

figure
visualizeScaleSpaces(Vscales,scales,[-pi pi],-0.7*pi);
colormap('hsv')
path = '../report/img/cellHistScaleSpacesV.png';
saveas(gcf,path), cropPng(path)

figure
visualizeScaleSpaces(Mscales,scales,[0 0.4],1);
path = '../report/img/cellHistScaleSpacesM.png';
saveas(gcf,path), cropPng(path)

figure
visualizeScaleSpaces(MscalesNorm,scales,[],max(M));
path = '../report/img/cellHistScaleSpacesMnorm.png';
saveas(gcf,path), cropPng(path)

figure
visualizeScaleSpaces(vector2cells(maskC,Isizes),scales,[0 1],1)
path = '../report/img/cellHistScaleSpacesMask.png';
saveas(gcf,path), cropPng(path)

figure
visualizeScaleSpaces(vector2cells(B(:,1),Isizes),scales,[],max(B(:)))
path = '../report/img/cellHistScaleSpacesBin1.png';
saveas(gcf,path), cropPng(path)