function matches = imageCorrespondence(setNum, imNum, liNum, mFunc, mName)

imNumKey = 25;
N = numel(setNum)*numel(imNum)*size(liNum,1);

n = 0;
for s = setNum
    for i = imNum
        for l = size(liNum,1)
            n = n + 1;
            disp([timestamp() ' Image ' num2str(n) '/' num2str(N)])
            match.setNum = s;
            match.imNum = i;
            match.liNum = liNum(l,:);
            matchPath = ['DTU/results/' mName '/matches_' dtuImageName(match.setNum,match.imNum,match.liNum)];

            if exist(matchPath,'file')
                load(matchPath)
            else
                [match.coord,D1] = dtuFeatures(match.setNum,match.imNum,match.liNum,mFunc);
                [match.coordKey,D2] = dtuFeatures(match.setNum,imNumKey,match.liNum,mFunc);

                [match.matchIdx, match.dist] = featureMatch(D1,D2);
                match.distRatio = match.dist(:,1) ./ (match.dist(:,2) + eps);
                match.area = repmat([0.16 0 0.16],[size(D1,1) 1]);
                match.areaKey = repmat([0.16 0 0.16],[size(D2,1) 1]);

                match = evalCorrespondence(match);

                % Save to file
                if ~exist(mName,'dir')
                    mkdir(mName)
                end
                save(matchPath,'match')
            end

            matches(n) = match;
        end
    end
end
