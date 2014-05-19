clc, clear all

for i = 1:924
    I = loadMitImage(i);
    hog = vl_hog(single(I),8);
    D(i,:) = double(hog(:));
end

labels = [ones(400,1); 2*ones(400,1)];
Dtrain = D(1:800,:);
svm = svmtrain(labels,Dtrain);

svmpredict(ones(100,1),D(801:900,:),svm)