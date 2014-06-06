clc, clear all

scaleBase = 2^(1/3);
scaleOffset = 0.5;
sigmaRange = [1 256];
colour = 'gray';
d = kJetCoeffs(2);
rescale = 1/2;
smooth = true;
chain = 1;
pixelDiff = 1;

scales = approxScales(sigmaRange,scaleBase,scaleOffset);

[imNumKey,liNumKey,imNumPaths,liNumPaths,pathLabels] = dtuPaths('test');

load('paths')
gcp;
parfor setNum = 1:60
    time = tic;
    disp([timestamp(time) ' Set ' num2str(setNum) '/60'])
    for pathType = 0:6
        if pathType == 0
            imMesh = imNumKey;
            liMesh = liNumKey;
        else
            [imMesh,liMesh] = meshgrid(imNumPaths{pathType},liNumPaths{pathType});
        end

        for m = 1:numel(imMesh)
            disp([timestamp(time) ' image: ' num2str(m) '/' num2str(numel(imMesh))]);
            imNum = imMesh(m);
            liNum = liMesh(m);
            I = loadDtuImage(setNum,imMesh(m),liMesh(m));
            I = colourTransform(im2single(I),colour);
            hash = num2str(imageHash(I(:)));

            sDir = [dtuResults '/scaleSpaces'];
            sPath = [sDir '/' hash '.mat'];

            if ~exist(sDir,'dir')
                mkdir(sDir)
            end
            [S,Isizes] = dGaussScaleSpace(I,d,scales,rescale,smooth);
            parSave(sPath,'S',S,'Isizes',Isizes,'scales',scales,...
                'scaleBase',scaleBase,'scaleOffset',scaleOffset,...
                'sigmaRange',sigmaRange,'colour',colour,'d',d,...
                'rescale',rescale,'chain',chain,'pixelDiff',pixelDiff,...
                'setNum',setNum,'imNum',imNum,'liNum',liNum);
        end
    end
end
toc
