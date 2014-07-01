clc, clear all

data = inriaData;
images = data.loadCache('posTest');
Irgb = images(330).image;

vars = load('cellHistExampleGoInria.mat');
test = load('results/inriaTestSvmGoFinal');
maxSvmW = max(reshape(test.svm.w,16,[]),[],1);
minSvmW = -min(reshape(test.svm.w,16,[]),[],1);

figure
imshow(Irgb)
set(gcf,'position',[600 250 70*3 134*3])
hold on
drawCircle(vars.cells(:,1)+vars.F(1),vars.cells(:,2)+vars.F(2),vars.gridSize,'b')
saveTightFigure(gcf,'../report/img/inriaExampleCells.pdf')

GO = visualizeGoHist(vars.cells+repmat(vars.F(1:2),size(vars.cells,1),1),vars.binC,vars.gridSize);
GOx = reshape(GO(:,1,:),2,[]);
GOy = reshape(GO(:,2,:),2,[]);
Dnorm = vars.D / max(vars.D);
[~,idx] = sort(Dnorm,'ascend');
%idx = idx(Dnorm(idx) > 0.01);


figure
colours = double(Dnorm(idx))' * [1 1 1];
set(gcf,'DefaultAxesColorOrder',colours)
imshow(zeros(size(vars.I)))
hold on;
set(gcf,'position',[600 250 70*3 134*3])
plot(GOx(:,idx),GOy(:,idx),'linewidth',2)
saveTightFigure(gcf,'../report/img/inriaExampleDescriptor.pdf')


DnormW = double(vars.D .* test.svm.w);
DnormW = DnormW / max(DnormW);
[~,idx] = sort(DnormW);
idx = idx(DnormW(idx) > 0);

figure
colours = double(DnormW(idx))' * [1 1 1];
set(gcf,'DefaultAxesColorOrder',colours);
imshow(zeros(size(vars.I)))
hold on
set(gcf,'position',[600 250 70*3 134*3])
plot(GOx(:,idx),GOy(:,idx),'linewidth',2)
saveTightFigure(gcf,'../report/img/inriaExampleDescriptorSvm.pdf')


DnormW = double(vars.D .* test.svm.w);
DnormW = DnormW / min(DnormW);
[~,idx] = sort(DnormW);
idx = idx(DnormW(idx) > 0);

figure
colours = double(DnormW(idx))' * [1 1 1];
set(gcf,'DefaultAxesColorOrder',colours);
imshow(zeros(size(vars.I)))
hold on
set(gcf,'position',[600 250 70*3 134*3])
plot(GOx(:,idx),GOy(:,idx),'linewidth',2)
saveTightFigure(gcf,'../report/img/inriaExampleDescriptorSvmNeg.pdf')

%% Positive SVM weights
figure
Isvm = zeros(size(Irgb,1),size(Irgb,2));
for i = 1:size(vars.C.data{1},3)
    Isvm(vars.C.data{1}(:,:,i)) = Isvm(vars.C.data{1}(:,:,i)) + ...
        vars.Wcell.data{1}(:,:,i) .* maxSvmW(i);
end
imshow(Isvm,[])
set(gcf,'position',[600 250 70*3 134*3])
saveTightFigure(gcf,'../report/img/inriaExampleDescriptorSvmMax.pdf')

%% Negative SVM weights
figure
Isvm = zeros(size(Irgb,1),size(Irgb,2));
for i = 1:size(vars.C.data{1},3)
    Isvm(vars.C.data{1}(:,:,i)) = Isvm(vars.C.data{1}(:,:,i)) + ...
        vars.Wcell.data{1}(:,:,i) .* minSvmW(i);
end
imshow(Isvm,[])
set(gcf,'position',[600 250 70*3 134*3])
saveTightFigure(gcf,'../report/img/inriaExampleDescriptorSvmMin.pdf')