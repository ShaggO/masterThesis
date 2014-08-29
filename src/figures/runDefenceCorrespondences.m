clc, clear all

% Load paths for the data
load('paths');

setNum = 19;
imNum = 12;
liNum = 0;

peakThresholdDog = 6.5;
peakThresholdHarris = 10^4;
matchCache = 1;
desSave = 1;

test = load('results/optimize/DTUparamsTest');
method = test.chosenGoSi;

t = 0.75;

[mFunc, mName] = parseMethod(method);
match = imageCorrespondence(setNum,imNum,liNum,{mFunc},{mName},...
    method.cache,desSave);

%% Best matches

imArgin = {match.setNum, match.imNum, match.liNum};
[imRes.X,imRes.D] = dtuFeatures(imArgin{:},mFunc,false);
[keyRes.X,keyRes.D] = dtuFeatures(match.setNum,25,0,mFunc,false);
I = loadDtuImage(imArgin{:});
I = I(201:end,351:1200,:);
Ikey = loadDtuImage(match.setNum, 25, match.liNum);
Ikey = Ikey(201:end,351:1200,:);
imRes.X = imRes.X - repmat([350 200 0],[size(imRes.X,1) 1]);
keyRes.X = keyRes.X - repmat([250-size(I,2) 200 0],[size(keyRes.X,1) 1]);

[distRatioSort,idxT] = sort(match.distRatio,'ascend');
T = [0; distRatioSort];

Pidx = match.distRatio <= t;
TPidx = Pidx & (match.CorrectMatch == 1);
FPidx = Pidx & (match.CorrectMatch == -1);
UPidx = Pidx & (match.CorrectMatch == 0);
TNidx = ~Pidx & (match.CorrectMatch == -1);
FNidx = ~Pidx & (match.CorrectMatch == 1);
UNidx = ~Pidx & (match.CorrectMatch == 0);

TPmatchesX = [imRes.X(TPidx,1)'; keyRes.X(match.matchIdx(TPidx,1),1)'];
TPmatchesY = [imRes.X(TPidx,2)'; keyRes.X(match.matchIdx(TPidx,1),2)'];
TPmatchesS = [imRes.X(TPidx,3)'; keyRes.X(match.matchIdx(TPidx,1),3)'];

FPmatchesX = [imRes.X(FPidx,1)'; keyRes.X(match.matchIdx(FPidx,1),1)'];
FPmatchesY = [imRes.X(FPidx,2)'; keyRes.X(match.matchIdx(FPidx,1),2)'];
FPmatchesS = [imRes.X(FPidx,3)'; keyRes.X(match.matchIdx(FPidx,1),3)'];

% Chosen point amongst the correct matches
matches = find(match.CorrectMatch == 1);
CorrectMatchSortIdx = find(match.CorrectMatch(idxT) == 1);
chosenIdx = idxT(CorrectMatchSortIdx(4));

figure
set(gcf,'color','white')
imshow([I ones(size(I,1),100,3) Ikey])
hold on
drawCircle(imRes.X(:,1),imRes.X(:,2),imRes.X(:,3),'g');
drawCircle(keyRes.X(:,1),keyRes.X(:,2),keyRes.X(:,3),'g');
%export_fig('-r300','../defence/img/imageCorrespondenceInterestPoints.pdf');

figure
set(gcf,'color','white')
imshow([I ones(size(I,1),100,3) Ikey])
hold on
drawCircle(imRes.X(chosenIdx,1),imRes.X(chosenIdx,2),imRes.X(chosenIdx,3),'g');
drawCircle(keyRes.X(:,1),keyRes.X(:,2),keyRes.X(:,3),'g');
%export_fig('-r300','../defence/img/imageCorrespondenceExample1.pdf');

figure
set(gcf,'color','white')
imshow([I ones(size(I,1),100,3) Ikey])
hold on;
if numel(TPmatchesX) > 0
    plot(TPmatchesX,TPmatchesY,'g-')
    drawCircle(TPmatchesX(:),TPmatchesY(:),TPmatchesS(:),'g')
end
if numel(FPmatchesX) > 0
    plot(FPmatchesX,FPmatchesY,'r-')
    drawCircle(FPmatchesX(:),FPmatchesY(:),FPmatchesS(:),'r')
end
% plot(imRes.X(UPidx,1),imRes.X(UPidx,2),'y.')
%export_fig('-r300','../defence/img/imageCorrespondenceExample3.pdf');
%open('../defence/img/imageCorrespondenceExample3.pdf');
%% Example of correct match

matches = find(match.CorrectMatch == 1);
CorrectMatchSortIdx = find(match.CorrectMatch(idxT) == 1);
idx = idxT(CorrectMatchSortIdx(4));
disp(['Incorrect match dists: ' nums2str(match.dist(idx,:)) ', ratio: ' num2str(match.distRatio(idx))])

firstMatchX = [imRes.X(idx,1)'; keyRes.X(match.matchIdx(idx,1),1)'];
firstMatchY = [imRes.X(idx,2)'; keyRes.X(match.matchIdx(idx,1),2)'];
firstMatchS = [imRes.X(idx,3)'; keyRes.X(match.matchIdx(idx,1),3)'];

secondMatchX = [imRes.X(idx,1)'; keyRes.X(match.matchIdx(idx,2),1)'];
secondMatchY = [imRes.X(idx,2)'; keyRes.X(match.matchIdx(idx,2),2)'];
secondMatchS = keyRes.X(match.matchIdx(idx,2),3)';

figure
set(gcf,'color','white')
imshow([I ones(size(I,1),100,3) Ikey])
hold on
plot(firstMatchX,firstMatchY,'g-')
theta = atan2d(firstMatchY(2)-firstMatchY(1),firstMatchX(2)-firstMatchX(1))
xChosen = firstMatchX(1)*0.325+firstMatchX(2)*0.675;
yChosen = firstMatchY(1)*0.325+firstMatchY(2)*0.675;
h = text(double(xChosen+60*sind(theta)),double(yChosen+60*cosd(theta)),'1');
set(h,'color','g','HorizontalAlignment','center','VerticalAlignment','middle','fontsize',50)
plot(secondMatchX,secondMatchY,'r-')
drawCircle(firstMatchX(:),firstMatchY(:),firstMatchS(:),'g')
drawCircle(keyRes.X(:,1),keyRes.X(:,2),keyRes.X(:,3),'g');
drawCircle(secondMatchX(2),secondMatchY(2),secondMatchS(:),'r')
theta = atan2d(secondMatchY(2)-secondMatchY(1),secondMatchX(2)-secondMatchX(1));
xChosen = secondMatchX(1)*0.46+secondMatchX(2)*0.54;
yChosen = secondMatchY(1)*0.46+secondMatchY(2)*0.54;
h = text(double(xChosen+60*sind(theta)),double(yChosen-60*cosd(theta)),'2');
set(h,'color','r','HorizontalAlignment','center','VerticalAlignment','middle','fontsize',50)
export_fig('-r300','../defence/img/imageCorrespondenceExample2.pdf');

