% function [] = imageCorrespondence()
clc, clear all

EdgeThresh = 4;
dFunc = @(I) getSiftFeatures(I,EdgeThresh);
dDir = ['DTU/descriptors/sift-' num2str(EdgeThresh)];

match.setNum = 1;
match.imNum = 1;
match.liNum = 1;
imNumKey = 25;

[match.coord,D1] = dtuFeatures(dFunc, match.setNum, match.imNum, match.liNum, dDir);
[match.coordKey,D2] = dtuFeatures(dFunc, match.setNum, imNumKey, match.liNum, dDir);

[match.matchIdx, match.dist] = featureMatch(D1,D2);
match.distRatio = match.dist(:,1) ./ match.dist(:,2);
match.area = repmat([0.16 0 0.16],[size(D1,1) 1]);
match.areaKey = repmat([0.16 0 0.16],[size(D2,1) 1]);

match = evalCorrespondence(match);

save('match.mat','match')