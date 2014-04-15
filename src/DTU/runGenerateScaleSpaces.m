clc, clear all

scaleBase = 2^(1/3);
sigmaRange = [1 256];
colour = 'gray';
d = kJetCoeffs(2);
rescale = 1/2;
chain = 1;
pixelDiff = 1;

scales = approxScales(sigmaRange,scaleBase);

[imNumKey,liNumKey,imNumPaths,liNumPaths,pathLabels] = dtuPaths();

tic
for setNum = 39:60
    disp([timestamp() ' Set ' num2str(setNum) '/60'])
    for pathType = 0:6
        if pathType == 0
            imMesh = imNumKey;
            liMesh = liNumKey;
        else
            [imMesh,liMesh] = meshgrid(imNumPaths{pathType},liNumPaths{pathType});
        end

        for m = 1:numel(imMesh)
            imNum = imMesh(m);
            liNum = liMesh(m);
            I = loadDtuImage(setNum,imMesh(m),liMesh(m));
            I = colourTransform(im2single(I),colour);
            hash = num2str(imageHash(I(:)));

            load('paths.mat')
            sDir = [dtuResults '\scaleSpaces'];
            sPath = [sDir '\' hash '.mat'];

            if ~exist(sDir,'dir')
                mkdir(sDir)
            end
            [S,Isizes] = dGaussScaleSpace(I,d,scales,rescale,chain,pixelDiff);
            save(sPath,'S','Isizes','scales','scaleBase','sigmaRange', ...
                'colour','d','rescale','chain','pixelDiff', ...
                'setNum','imNum','liNum')
        end
    end
end
toc
