clc, clear all

d = kJetCoeffs(2);
scales = 1;
rescale = 1;
smooth = 0;
normSigmaM = [7.6 7.6];
normSigmaC = [7 7];
normFilter = 'gaussian';

load('paths')
load([inriaDataSet '/inriaPosTrain']);

Mtotal = zeros(128,64);
Ctotal = Mtotal;
for i = 1:numel(images)
    disp([num2str(i) '/' num2str(numel(images))])
    I = rgb2gray(im2single(images(i).image));
    L = dGaussScaleSpace(I,d,scales,rescale,smooth);
    L = structfun(@(x) x(4:end-3,4:end-3),L,'UniformOutput',0); % remove image border
    M = diffStructure('M',L,1);
    M = pixelNormalization(M,normFilter,normSigmaM);
    C = diffStructure('C',L,1);
    C = pixelNormalization(C,normFilter,normSigmaC);
    Mtotal = Mtotal + M{1};
    Ctotal = Ctotal + C{1};
end

Mtotal = Mtotal / max(Mtotal(:));
imwrite(Mtotal,'../report/img/inriaPosTrainMeanMnorm.png')

Ctotal = Ctotal / max(Ctotal(:));
imwrite(Ctotal,'../report/img/inriaPosTrainMeanCnorm.png')
