clc, clear all

setNum = 16;
imNum = 1;
liNum = 0;

peakThresholdDog = 6.5;
peakThresholdHarris = 10^4;
matchCache = 1;
desSave = 1;

test = load('results/optimize/DTUparamsTest');
method = test.chosenGoSi;

t = 0.8;

[mFunc, mName] = parseMethod(method);
match = imageCorrespondence(setNum,imNum,liNum,{mFunc},{mName},...
    method.cache,desSave);

%% Matches figure

% Load paths for the data
load('paths');

imArgin = {match.setNum, match.imNum, match.liNum};
[imRes.X,imRes.D] = dtuFeatures(imArgin{:},mFunc,false);
[keyRes.X,keyRes.D] = dtuFeatures(match.setNum,25,0,mFunc,false);
I = loadDtuImage(imArgin{:});
Ikey = loadDtuImage(match.setNum, 25, match.liNum);

T = [0; sort(match.distRatio,'ascend')];

idx = find(T < t,1,'last');

Pidx = match.distRatio <= t;
TPidx = Pidx & (match.CorrectMatch == 1);
FPidx = Pidx & (match.CorrectMatch == -1);
UPidx = Pidx & (match.CorrectMatch == 0);
TNidx = ~Pidx & (match.CorrectMatch == -1);
FNidx = ~Pidx & (match.CorrectMatch == 1);
UNidx = ~Pidx & (match.CorrectMatch == 0);

TPmatchesX = [match.coord(TPidx,1)'; size(I,2)+100+match.coordKey(match.matchIdx(TPidx,1),1)'];
TPmatchesY = [match.coord(TPidx,2)'; match.coordKey(match.matchIdx(TPidx,1),2)'];

FPmatchesX = [match.coord(FPidx,1)'; size(I,2)+100+match.coordKey(match.matchIdx(FPidx,1),1)'];
FPmatchesY = [match.coord(FPidx,2)'; match.coordKey(match.matchIdx(FPidx,1),2)'];

figure
set(gcf,'color','white')
imshow([I ones(size(I,1),100,3) Ikey])
hold on
plot(TPmatchesX,TPmatchesY,'g.-')
plot(FPmatchesX,FPmatchesY,'r.-')
% plot(match.coord(UPidx,1),match.coord(UPidx,2),'y.')
hold off
export_fig('-r300','../report/img/imageCorrespondenceMatches.pdf');
title('Classified as positive matches')