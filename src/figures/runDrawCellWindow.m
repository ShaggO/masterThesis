clc, clear all

gridRadius = 5;
Isizes = [8*gridRadius+1 8*gridRadius+1 1];
F = [4*gridRadius+1 4*gridRadius+1 1];
scales = 1;
rescale = 0;
P = scaleSpaceFeatures(F,scales,rescale);
% P = [300 500 1 1; 800 200 1 2; 250 250 2 1];
gridType = 'polar central';
gridSize = [0 0];
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
axis([1 Isizes(1) 1 Isizes(2) 0 max(Wcell.vector)])
colormap jet
view([1 2 3])
axis off
hold on

Cpart = C.data{1};
Wpart = Wcell.data{1};
for j = 1:size(Cpart,3)
    I = zeros(Isizes(1,1:2));
    I(Cpart(:,:,j)) = Wpart(:,:,j);
    surf(I,'FaceAlpha',1,'EdgeColor','none');
    colormap('jet')
    x = F(1,1) + cos(linspace(-pi,pi,100))*gridRadius;
    y = F(1,2) + sin(linspace(-pi,pi,100))*gridRadius;
    h1 = plot3(x,y,ones(size(x))*0.62*max(Wcell.vector),'k-','linewidth',1);
    x = F(1,1) + cos(linspace(-pi,pi,100))*3*gridRadius;
    y = F(1,2) + sin(linspace(-pi,pi,100))*3*gridRadius;
    h2 = plot3(x,y,ones(size(x))*0.02*max(Wcell.vector),'y-','linewidth',1);
%     legend([h1 h2],{'\sigma','3\sigma'},'location','northeast')
end

set(gcf,'color','w');
path = '../report/img/cellWindow.pdf';
export_fig('-r300',path);