clc, clear all

% Load paths for the data
load('paths');

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

%% Best matches

imArgin = {match.setNum, match.imNum, match.liNum};
[imRes.X,imRes.D] = dtuFeatures(imArgin{:},mFunc,false);
[keyRes.X,keyRes.D] = dtuFeatures(match.setNum,25,0,mFunc,false);
I = loadDtuImage(imArgin{:});
Ikey = loadDtuImage(match.setNum, 25, match.liNum);

T = [0; sort(match.distRatio,'ascend')];

Pidx = match.distRatio <= t;
TPidx = Pidx & (match.CorrectMatch == 1);
FPidx = Pidx & (match.CorrectMatch == -1);
UPidx = Pidx & (match.CorrectMatch == 0);
TNidx = ~Pidx & (match.CorrectMatch == -1);
FNidx = ~Pidx & (match.CorrectMatch == 1);
UNidx = ~Pidx & (match.CorrectMatch == 0);

TPmatchesX = [imRes.X(TPidx,1)'; size(I,2)+100+keyRes.X(match.matchIdx(TPidx,1),1)'];
TPmatchesY = [imRes.X(TPidx,2)'; keyRes.X(match.matchIdx(TPidx,1),2)'];
TPmatchesS = [imRes.X(TPidx,3)'; keyRes.X(match.matchIdx(TPidx,1),3)'];

FPmatchesX = [imRes.X(FPidx,1)'; size(I,2)+100+keyRes.X(match.matchIdx(FPidx,1),1)'];
FPmatchesY = [imRes.X(FPidx,2)'; keyRes.X(match.matchIdx(FPidx,1),2)'];
FPmatchesS = [imRes.X(FPidx,3)'; keyRes.X(match.matchIdx(FPidx,1),3)'];

figure
set(gcf,'color','white')
imshow([I ones(size(I,1),100,3) Ikey])
hold on
plot(TPmatchesX,TPmatchesY,'g-')
drawCircle(TPmatchesX(:),TPmatchesY(:),TPmatchesS(:),'g')
plot(FPmatchesX,FPmatchesY,'r-')
drawCircle(FPmatchesX(:),FPmatchesY(:),FPmatchesS(:),'r')
% plot(imRes.X(UPidx,1),imRes.X(UPidx,2),'y.')
export_fig('-r300','../report/img/imageCorrespondenceMatches.pdf');
% open('../report/img/imageCorrespondenceMatches.pdf')

%% Example of correct match

matches = find(match.CorrectMatch == 1);
idx = matches(1);
disp(['Incorrect match dists: ' nums2str(match.dist(idx,:)) ', ratio: ' num2str(match.distRatio(idx))])

firstMatchX = [imRes.X(idx,1)'; size(I,2)+100+keyRes.X(match.matchIdx(idx,1),1)'];
firstMatchY = [imRes.X(idx,2)'; keyRes.X(match.matchIdx(idx,1),2)'];
firstMatchS = [imRes.X(idx,3)'; keyRes.X(match.matchIdx(idx,1),3)'];

secondMatchX = [imRes.X(idx,1)'; size(I,2)+100+keyRes.X(match.matchIdx(idx,2),1)'];
secondMatchY = [imRes.X(idx,2)'; keyRes.X(match.matchIdx(idx,2),2)'];
secondMatchS = keyRes.X(match.matchIdx(idx,2),3)';

figure
set(gcf,'color','white')
imshow([I ones(size(I,1),100,3) Ikey])
hold on
plot(firstMatchX,firstMatchY,'g-')
theta = atan2d(firstMatchY(2)-firstMatchY(1),firstMatchX(2)-firstMatchX(1));
h = text(mean(firstMatchX)+60*sind(theta),mean(firstMatchY)+60*cosd(theta),'1');
set(h,'color','g','HorizontalAlignment','center','VerticalAlignment','middle','fontsize',30)
plot(secondMatchX,secondMatchY,'r-')
drawCircle(firstMatchX(:),firstMatchY(:),firstMatchS(:),'g')
drawCircle(secondMatchX(:),secondMatchY(:),secondMatchS(:),'r')
theta = atan2d(secondMatchY(2)-secondMatchY(1),secondMatchX(2)-secondMatchX(1));
h = text(mean(secondMatchX)+60*sind(theta),mean(secondMatchY)-60*cosd(theta),'2');
set(h,'color','r','HorizontalAlignment','center','VerticalAlignment','middle','fontsize',30)
export_fig('-r300','../report/img/imageCorrespondenceCorrectMatch.pdf');

%% Example of incorrect match

matches = find(match.CorrectMatch == -1);
idx = matches(120);
disp(['Incorrect match dists: ' nums2str(match.dist(idx,:)) ', ratio: ' num2str(match.distRatio(idx))])

firstMatchX = [imRes.X(idx,1)'; size(I,2)+100+keyRes.X(match.matchIdx(idx,1),1)'];
firstMatchY = [imRes.X(idx,2)'; keyRes.X(match.matchIdx(idx,1),2)'];
firstMatchS = [imRes.X(idx,3)'; keyRes.X(match.matchIdx(idx,1),3)'];

secondMatchX = [imRes.X(idx,1)'; size(I,2)+100+keyRes.X(match.matchIdx(idx,2),1)'];
secondMatchY = [imRes.X(idx,2)'; keyRes.X(match.matchIdx(idx,2),2)'];
secondMatchS = keyRes.X(match.matchIdx(idx,2),3)';

figure
set(gcf,'color','white')
imshow([I ones(size(I,1),100,3) Ikey])
hold on
plot(firstMatchX,firstMatchY,'r-')
theta = atan2d(firstMatchY(2)-firstMatchY(1),firstMatchX(2)-firstMatchX(1));
h = text(mean(firstMatchX)+100*sind(theta),mean(firstMatchY)+100*cosd(theta),'1');
set(h,'color','r','HorizontalAlignment','center','VerticalAlignment','middle','fontsize',30)
plot(secondMatchX,secondMatchY,'r-')
drawCircle(firstMatchX(:),firstMatchY(:),firstMatchS(:),'r')
drawCircle(secondMatchX(:),secondMatchY(:),secondMatchS(:),'r')
theta = atan2d(secondMatchY(2)-secondMatchY(1),secondMatchX(2)-secondMatchX(1));
h = text(mean(secondMatchX)+60*sind(theta),mean(secondMatchY)-60*cosd(theta),'2');
set(h,'color','r','HorizontalAlignment','center','VerticalAlignment','middle','fontsize',30)
export_fig('-r300','../report/img/imageCorrespondenceIncorrectMatch.pdf');
% 
% %% ROC- and PR-curves
% 
% figure
% set(gcf,'color','white')
% hold on
% box on
% area(match.ROC(:,1),match.ROC(:,2),'facecolor',[0.9 0.9 1])
% plot(match.ROC(:,1),match.ROC(:,2),'b-','linewidth',2)
% set(gca,'Xtick',0:0.2:1,'Ytick',0:0.2:1)
% plot([0 1],[0 1],'k--')
% text(0.5,0.1,['ROC AUC: ' num2str(match.ROCAUC,2)],'horizontalalignment','center')
% xlabel('Fall-out (FPR)')
% ylabel('Recall (TPR)')
% axis image
% axis([0 1 0 1])
% export_fig('-r300','../report/img/imageCorrespondenceROC.pdf');
% 
% figure
% set(gcf,'color','white')
% hold on
% box on
% area(match.PR(:,2),1-match.PR(:,1),'facecolor',[0.9 0.9 1])
% plot(match.PR(:,2),1-match.PR(:,1),'b-','linewidth',2)
% set(gca,'Xtick',0:0.2:1,'Ytick',0:0.2:1)
% text(0.5,0.1,['PR AUC: ' num2str(match.PRAUC,2)],'horizontalalignment','center')
% xlabel('Recall (TPR)')
% ylabel('Precision')
% axis image
% axis([0 1 0 1])
% export_fig('-r300','../report/img/imageCorrespondencePR.pdf');