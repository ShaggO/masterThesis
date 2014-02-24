clc, clear all

method.detector = 'vl';
method.detectorArgs = {'peakthreshold',10};
method.descriptor = 'sift';
method.descriptorArgs = {'colour','gaussian opponent'};
[mFunc, mName] = parseMethod(method);
mDir = ['DTU/results/' mName];

setNum = 1;
imNum = [1 12 24];
liNum = 1;

matches = imageCorrespondence(setNum,imNum,liNum,mFunc,mDir);

figure
plot(imNum,[matches.Area],'bo-')
% hold on
% plot(imNum,[matches.RecallRate],'ro-')
h = title(mName);
set(h,'interpreter','none')
legend('AUC')
axis([0 50 0 1])