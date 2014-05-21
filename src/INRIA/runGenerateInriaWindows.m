clc, clear all

rng(1,'combRecursive');
windowsPerImage = 10;
load('paths')

%% Positive training images
relDir = '96X160H96/Train/pos';
contents = dir([inriaDataSet '/' relDir]);
n = numel(contents)-2;
posTrain = struct('image',cell(n,1),'path',cell(n,1));
for i = 1:n
    relPath = [relDir '/' contents(i+2).name];
    I = imread([inriaDataSet '/' relPath]);
    posTrain(i).image = I(14:end-13,14:end-13,:);
    posTrain(i).path = relPath;
end

%% Positive test images
relDir = '70X134H96/Test/pos';
contents = dir([inriaDataSet '/' relDir]);
n = numel(contents)-2;
posTest = struct('image',cell(n,1),'path',cell(n,1));
for i = 1:n
    relPath = [relDir '/' contents(i+2).name];
    I = imread([inriaDataSet '/' relPath]);
    posTest(i).image = I;
    posTest(i).path = relPath;
end

%% Negative training images
relDir = 'Train/neg';
contents = dir([inriaDataSet '/' relDir]);
n = numel(contents)-2;
negTrain = struct('image',cell(10,n),'path',cell(10,n));
for i = 1:n
    relPath = [relDir '/' contents(i+2).name];
    I = imread([inriaDataSet '/' relPath]);
    for j = 1:windowsPerImage
        y = randi(size(I,1)-133);
        x = randi(size(I,2)-69);
        negTrain(j,i).image = I(y+(0:133),x+(0:69),:);
        negTrain(j,i).path = relPath;
    end
end
negTrain = negTrain(:);

%% Negative test images
relDir = 'Test/neg';
contents = dir([inriaDataSet '/' relDir]);
n = numel(contents)-2;
negTest = struct('image',cell(10,n),'path',cell(10,n));
for i = 1:n
    relPath = [relDir '/' contents(i+2).name];
    I = imread([inriaDataSet '/' relPath]);
    for j = 1:windowsPerImage
        y = randi(size(I,1)-133);
        x = randi(size(I,2)-69);
        negTest(j,i).image = I(y+(0:133),x+(0:69),:);
        negTest(j,i).path = relPath;
    end
end
negTest = negTest(:);

save([inriaDataSet '/inriaTrain'],'posTrain','negTrain')
save([inriaDataSet '/inriaTest'],'posTest','negTest')