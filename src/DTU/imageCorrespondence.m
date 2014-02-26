function matches = imageCorrespondence(setNum, imNum, liNum, mFunc, mDir)

imNumKey = 25;
N = numel(setNum)*numel(imNum)*numel(liNum);

n = 0;
for s = setNum
    for i = imNum
        for l = liNum
            n = n + 1;
            disp(['[' num2str(toc) '] Image ' num2str(n) '/' num2str(N)])
            match.setNum = s;
            match.imNum = i;
            match.liNum = l;
            matchPath = dtuMatchPath(mDir,match.setNum,match.imNum,match.liNum);
            
            if exist(matchPath,'file')
                load(matchPath)
            else
                [match.coord,D1] = dtuFeatures(match.setNum,match.imNum,match.liNum,mFunc,mDir);
                [match.coordKey,D2] = dtuFeatures(match.setNum,imNumKey,match.liNum,mFunc,mDir);
                
                [match.matchIdx, match.dist] = featureMatch(D1,D2);
                match.distRatio = match.dist(:,1) ./ match.dist(:,2);
                match.area = repmat([0.16 0 0.16],[size(D1,1) 1]);
                match.areaKey = repmat([0.16 0 0.16],[size(D2,1) 1]);
                
                match = evalCorrespondence(match);
                
                % Save to file
                if ~exist(mDir,'dir')
                    mkdir(mDir)
                end
                mPath = dtuMatchPath(mDir,match.setNum,match.imNum,match.liNum);
                save(mPath,'match')
            end
            
            matches(n) = match;
        end
    end
end