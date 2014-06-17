clc, clear all

% Load INRIA image data object
data = inriaData;
data.loadCache('all');

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
images = [data.posTrain; data.negTrainCutouts; data.negTrainFull; data.posTest; data.negTestCutouts; data.negTestFull];
%images = [data.negTrainFull; data.negTestFull];

sDir = [dtuResults '/scaleSpaces'];
if ~exist(sDir,'dir')
    mkdir(sDir)
end

before = numel(dir(sDir));
start = tic

parfor i = 1:numel(images)
    img = images(i);
    if mod(i,100) == 0
        disp([timestamp(start) ' Image ' num2str(i) '/' num2str(numel(images))]);
    end
    I = colourTransform(im2single(img.image),colour);
    hash = num2str(imageHash(I(:)));

    sPath = [sDir '/' hash '.mat'];
    [S,Isizes] = dGaussScaleSpace(I,d,scales,rescale,smooth);
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
