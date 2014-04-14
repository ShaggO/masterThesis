function matches = imageCorrespondence(setNum, imNum, liNum, mFunc, mName, cache)

if nargin < 6
    cache = 1;
end

% Load paths for the data
load('paths');

imNumKey = 25;
liNumKey = 0;
N = numel(setNum)*numel(imNum)*numel(liNum)*numel(mFunc);
imSize = size(imread(dtuImagePath(setNum(1),imNum(1),liNum(1))));

n = 0;
for s = setNum
    for i = imNum
        for l = liNum
            for m = 1:numel(mFunc)
                mDir = [dtuResults '/' mName{m}];
                n = n + 1;
                disp([timestamp() ' Image ' num2str(n) '/' num2str(N)]);
                matchPath = [mDir '/matches_' dtuImageName(s,i,l)];

                loaded = false;
                if cache(m)
                    [loaded,matchLoad] = loadIfExist(matchPath,'file');
                end
                if loaded
                    disp('Matches loaded');
                    match = matchLoad.match;
                else
                    match.setNum = s;
                    match.imNum = i;
                    match.liNum = l;
                    match.imSize = imSize;

                    [match.coord,D1] = dtuFeatures(match.setNum,match.imNum,match.liNum,mFunc{m});
                    [match.coordKey,D2] = dtuFeatures(match.setNum,imNumKey,liNumKey,mFunc{m});

                    [match.matchIdx, match.dist] = featureMatch(D1,D2);
                    match.distRatio = match.dist(:,1) ./ (match.dist(:,2) + eps);
                    match.area = repmat([0.16 0 0.16],[size(D1,1) 1]);
                    match.areaKey = repmat([0.16 0 0.16],[size(D2,1) 1]);

                    match = evalCorrespondence(match);

                    % Save to file
                    if ~exist(mDir,'dir')
                        mkdir(mDir)
                    end
                    save(matchPath,'match')
                end

                matches(n) = match;
            end
        end
    end
end
