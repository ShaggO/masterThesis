clc, clear all

load('cellHistExample')

figure
visualizeScaleSpaces({L.none},scales,[0 1],1,P,validP);
saveas(gcf,'../report/img/cellHistScaleSpacesP.png')

figure
visualizeScaleSpaces(Vscales,scales,[-pi pi],-0.7*pi);
colormap('hsv')
saveas(gcf,'../report/img/cellHistScaleSpacesV.png')

figure
visualizeScaleSpaces(Mscales,scales,[0 0.4],1);
saveas(gcf,'../report/img/cellHistScaleSpacesM.png')

figure
visualizeScaleSpaces(MscalesNorm,scales,[],max(M));
saveas(gcf,'../report/img/cellHistScaleSpacesMnorm.png')