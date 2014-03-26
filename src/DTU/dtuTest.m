function dtuTest(setNum,method,display)
%DTUTEST Evaluates given methods by the image correspondence problem on the
% DTU dataset. Plots the average ROC AUC and PR AUC over given image sets
% for each method.
if nargin < 3
    display = true;
end

imNumKey = 25;
imNum = [1 12 24 26 37 49];
liNum = 'diffuse';
before = find(imNum < imNumKey,1,'last');
aucSize = [1 before numel(setNum)];

tic
for i = 1:numel(method)
    m = method(i);
    [mFunc, mName{i}] = parseMethod(m);
    disp([timestamp() ' Method ' num2str(i) '/' num2str(numel(method)) ': ' mName{i}])
    for j = 1:numel(setNum)
        s = setNum(j);
        disp([timestamp() ' Set ' num2str(j) '/' num2str(numel(setNum))])
        matches(i,:,j) = imageCorrespondence(s,imNum,liNum,mFunc,mName{i});
    end
end

if display
    figure('units','normalized','outerposition',[0 0 1 1])
    axis([imNum(1)-1 imNum(end)+1 0 1])
    hold on
    for i = 1:numel(method)
        auc1 = sum(reshape([matches(i,1:before,:).ROCAUC],aucSize),3)/numel(setNum);
        auc2 = sum(reshape([matches(i,before+1:end,:).ROCAUC],aucSize),3)/numel(setNum);
        h(i) = plot(imNum(1:before),auc1,method(i).plotParams{:});
        plot(imNum(before+1:end),auc2,method(i).plotParams{:})
    end
    title('ROC AUC')
    legend(h,mName,'location','southeast','interpreter','none')

    figure('units','normalized','outerposition',[0 0 1 1])
    axis([imNum(1)-1 imNum(end)+1 0 1])
    hold on
    for i = 1:numel(method)
        auc1 = sum(reshape([matches(i,1:before,:).PRAUC],aucSize),3)/numel(setNum);
        auc2 = sum(reshape([matches(i,before+1:end,:).PRAUC],aucSize),3)/numel(setNum);
        h(i) = plot(imNum(1:before),auc1,method(i).plotParams{:});
        plot(imNum(before+1:end),auc2,method(i).plotParams{:})
    end
    title('PR AUC')
    legend(h,mName,'location','southeast','interpreter','none')
end
