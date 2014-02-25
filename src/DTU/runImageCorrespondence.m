clc, clear all

imNumKey = 25;
setNum = 1;
imNum = [1 12 24 26 37 49];
liNum = 1;

method(1) = methodStruct('vl',{'peakthreshold',10}, ...
    'sift',{'colour','gray'},{'rx-'});
method(2) = methodStruct('vl',{'peakthreshold',10}, ...
    'sift',{'colour','rgb bin'},{'gx-'});
method(3) = methodStruct('vl',{'peakthreshold',10}, ...
    'sift',{'colour','rgb'},{'go-'});
method(4) = methodStruct('vl',{'peakthreshold',10}, ...
    'sift',{'colour','opponent'},{'bo-'});
method(5) = methodStruct('vl',{'peakthreshold',10}, ...
    'sift',{'colour','gaussian opponent'},{'ko-'});

figure('units','normalized','outerposition',[0 0 1 1])
axis([imNum(1)-1 imNum(end)+1 0 1])
hold on
for i = 1:numel(method)
    m = method(i);
    [mFunc, mName{i}] = parseMethod(m);
    mDir = ['DTU/results/' mName{i}];
    matches(i,:) = imageCorrespondence(setNum,imNum,liNum,mFunc,mDir);
    after = find(imNum > imNumKey,1);
    plot(imNum(1:after-1),[matches(i,1:after-1).Area],m.plotParams{:})
    plot(imNum(after:end),[matches(i,after:end).Area],m.plotParams{:})
end

legend([mName],'location','southeast','interpreter','none')