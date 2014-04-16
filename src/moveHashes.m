[imNumKey,liNumKey,imNumPaths,liNumPaths,pathLabels] = dtuPaths('train');
pathTypes = 1:6;

imgNum = sum(cellfun(@numel,imNumPaths(pathTypes)) .* ...
    cellfun(@numel,liNumPaths(pathTypes))) * 60;

colour = 'gray';

load('paths');
counter = 0;
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
            hashOld = num2str(imageHashOldest(I(:)));

            sDir = [dtuResults '/scaleSpaces'];
            sPath = [sDir '/' hash '.mat'];
            sPathOld = [sDir '/' hashOld '.mat'];
            if exist(sPathOld,'file')
                disp(['Moved: ' sPathOld 'to: ' sPath]);
                movefile(sPathOld,sPath);
            end
        end
    end
end
