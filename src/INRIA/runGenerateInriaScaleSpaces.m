clc, clear all

scaleBase = 2^(1/3);
scaleOffset = 0;
sigmaRange = [1 16];
colour = 'gray';
d = kJetCoeffs(2);
rescale = 1;
smooth = false;
chain = 1;
pixelDiff = 1;

scales = approxScales(sigmaRange,scaleBase,scaleOffset);

load('paths')
load([inriaDataSet '/inriaTrain']);
load([inriaDataSet '/inriaTest']);
images = [posTrain; negTrain; posTest; negTest];

sDir = [dtuResults '/scaleSpaces'];
if ~exist(sDir,'dir')
    mkdir(sDir)
end

before = numel(dir(sDir));
tic

for i = 1:numel(images)
    img = images(i);
    if mod(i,100) == 0
        disp([timestamp() ' Image ' num2str(i) '/' num2str(numel(images))]);
    end
    I = colourTransform(im2single(img.image),colour);
    hash = num2str(imageHash(I(:)));

    sPath = [sDir '/' hash '.mat'];
    [S,Isizes] = dGaussScaleSpace(I,d,scales,rescale,smooth,chain,pixelDiff);
    parSave(sPath,'S',S,'Isizes',Isizes,'scales',scales,...
        'scaleBase',scaleBase,'scaleOffset',scaleOffset,...
        'sigmaRange',sigmaRange,'colour',colour,'d',d,...
        'rescale',rescale,'chain',chain,'pixelDiff',pixelDiff,...
        'smooth',smooth,'imgPath',img.path);
end
after = numel(dir(sDir));

disp(['Number of images: ' num2str(numel(images))]);
disp(['Number of files created: ' num2str(after - before)]);
toc
