clc, clear all

method.detector = 'vl';
method.detectorArgs = {'peakthreshold',10};
method.descriptor = 'sift';
method.descriptorArgs = {'colour','normal'};
[mFunc, mName] = parseMethod(method);
mDir = ['DTU/results/' mName];

match.setNum = 1;
match.imNum = 25;
match.liNum = 1;

[X,D] = dtuFeatures(match.setNum,match.imNum,match.liNum,mFunc,mDir);

I = loadDtuImage(match.setNum,match.imNum,match.liNum);
figure
imshow(I)
hold on
plot(X(:,1),X(:,2),'r.')
