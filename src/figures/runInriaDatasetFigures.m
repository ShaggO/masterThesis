clc, clear all

d = kJetCoeffs(2);
scales = 1;
rescale = 1;
smooth = 1;

binCountT = 100;
periodT = 2*pi;
binSigmaT = 2*pi ./ (2*8);
[binFT, binRT] = ndFilter('gaussian',binSigmaT);
binCT = createBinCenters(-pi,pi,binCountT);

binCountS = 100;
periodS = 0;
binSigmaS = 2 ./ (2*8);
[binFS, binRS] = ndFilter('gaussian',binSigmaS);
binCS = createBinCenters(-1,1,binCountS);

load('paths')
load([inriaDataSet '/inriaTrain']);

Mtotal = zeros(128,64);
Stotal = Mtotal;
Ctotal = Mtotal;
BTtotal = zeros([128 64 binCountS]);
BStotal = BTtotal;
for i = 1:numel(posTrain)
    disp([num2str(i) '/' num2str(numel(posTrain))])
    I = rgb2gray(im2single(posTrain(i).image));
    L = dGaussScaleSpace(I,d,scales,rescale,smooth);
    L = structfun(@(x) x(4:end-3,4:end-3),L,'UniformOutput',0); % remove image border
    T = diffStructure('Theta',L,1);
    S = diffStructure('S',L,1);
%     M = diffStructure('M',L,1);
%     C = diffStructure('C',L,1);
%     Mtotal = Mtotal + M{1};
%     Stotal = Stotal + S{1};
%     Ctotal = Ctotal + C{1};
    BT = ndBinWeights(T{1}(:),binCT,binFT,binRT,'period',periodT);
    BTtotal = BTtotal + reshape(BT,[128 64 binCountT]);
    BS = ndBinWeights(S{1}(:),binCS,binFS,binRS,'period',periodS);
    BStotal = BStotal + reshape(BS,[128 64 binCountS]);
end

% Mtotal = Mtotal / max(Mtotal(:));
% imwrite(Mtotal,'../report/img/inriaPosTrainMeanM.png')
% 
% Stotal = (Stotal - min(Stotal(:))) / (max(Stotal(:)) - min(Stotal(:)));
% imwrite(Stotal,'../report/img/inriaPosTrainMeanS.png')
% 
% Ctotal = Ctotal / max(Ctotal(:));
% imwrite(Ctotal,'../report/img/inriaPosTrainMeanC.png')

[~,Tmode] = max(BTtotal,[],3);
figure
imshow(imresize(binCT(Tmode),5,'box'),[])
colormap('hsv')
colorbar

[~,Smode] = max(BStotal,[],3);
figure
imshow(imresize(binCS(Smode),5,'box'),[])
colormap('jet')
colorbar