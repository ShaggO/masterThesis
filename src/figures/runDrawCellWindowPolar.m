clc, clear all

gridRadius = 25;
Isizes = [4*gridRadius+1 4*gridRadius+1 1];
F = [2*gridRadius+1 2*gridRadius+1 1];
scales = 1;
rescale = 0;
P = scaleSpaceFeatures(F,scales,rescale);
% P = [300 500 1 1; 800 200 1 2; 250 250 2 1];
gridType = 'polar central';
gridSize = [8 2];
centerFilter = 'none';
centerSigma = [1 1];
cellFilter = 'polar gaussian';
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

[validP,C,Wcell,Wcen,cen] = createCells(Isizes,P,gridType,gridSize,gridRadius,...
    centerFilter,centerSigma,cellFilter,cellSigma,cellNormStrategy);

% I = zeros(Isizes(1,1:2));
% I(Cpart) = Wpart;
% figure
% imshow(I,[])

cutoutX = 11:58;
cutoutY = 29:86;
% cutoutX = 1:Isizes(1);
% cutoutY = 1:Isizes(2);
i = 3;

figure
axis([1 cutoutX(end)+1 1 cutoutY(end)-cutoutY(1)+1 0 max(Wcell.data{i}(:))])
colormap jet
view([1 2 3])
axis off
hold on

Cpart = C.data{i};
Wpart = Wcell.data{i};
for j = 6
    I = zeros(Isizes(1,1:2));
    I(Cpart(:,:,j)) = Wpart(:,:,j);
    surf(I(cutoutX,cutoutY),'FaceAlpha',1,'EdgeColor','none');
    colormap('jet')
    [thetaCen,rhoCen] = cart2pol(cen(j+9,1), cen(j+9,2));
    theta = thetaCen + pi/gridSize(1)*sin(linspace(-pi,pi,100));
    rho = rhoCen + 5*cos(linspace(-pi,pi,100));
    [x,y] = pol2cart(theta,rho);
    plot3(x+F(1,1)-cutoutY(1)+1,y+F(1,2)-cutoutX(1)+1,ones(size(x))*0.62*max(Wcell.data{3}(:)),'k-','linewidth',1);
    theta = thetaCen + 3*pi/gridSize(1)*sin(linspace(-pi,pi,100));
    rho = rhoCen + 15*cos(linspace(-pi,pi,100));
    [x,y] = pol2cart(theta,rho);
    plot3(x+F(1,1)-cutoutY(1)+1,y+F(1,2)-cutoutX(1)+1,ones(size(x))*0.02*max(Wcell.data{3}(:)),'y-','linewidth',1);
end

set(gcf,'color','w');
path = '../report/img/cellWindowPolar.pdf';
export_fig('-r300',path);