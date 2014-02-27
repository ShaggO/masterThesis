clc, clear all

imNumKey = 25;
setNum = 4;
imNum = [1 12 24 26 37 49];
liNum = 1;

peakThreshold = 5*10^4;
%method(1) = methodStruct( ...
%    'vl',{'method','MultiscaleHarris','peakthreshold',peakThreshold}, ...
%    'sift',{'colour','gray'},{'rx-'});
%method(2) = methodStruct( ...
%    'vl',{'method','MultiscaleHarris','peakthreshold',peakThreshold}, ...
%    'sift',{'colour','rgb'},{'go-'});
%method(3) = methodStruct( ...
%    'vl',{'method','MultiscaleHarris','peakthreshold',peakThreshold}, ...
%    'sift',{'colour','opponent'},{'bo-'});
method(1) = methodStruct( ...
    'vl',{'method','MultiscaleHarris','peakthreshold',peakThreshold}, ...
    'sift',{'colour','gaussian opponent'},{'ko-'});
%method(1) = methodStruct( ...
%    'vl',{'method','MultiscaleHarris','peakthreshold',peakThreshold}, ...
%    'k-jet',{'k',3,'sigma',2,'domain','spatial'},{'co-'})

figure('units','normalized','outerposition',[0 0 1 1])
axis([imNum(1)-1 imNum(end)+1 0 1])
hold on
tic
for i = 1:numel(method)
    m = method(i);
    [mFunc, mName{i}] = parseMethod(m);
    disp(['[' num2str(toc) '] Method ' num2str(i) '/' num2str(numel(method)) ': ' mName{i}])
    mDir = ['DTU/results/' mName{i}];
    matches(i,:) = imageCorrespondence(setNum,imNum,liNum,mFunc,mDir);
    before = find(imNum < imNumKey,1,'last');
    h(i) = plot(imNum(1:before),[matches(i,1:before).Area],m.plotParams{:});
    plot(imNum(before+1:end),[matches(i,before+1:end).Area],m.plotParams{:})
end

legend(h,mName,'location','southeast','interpreter','none')
