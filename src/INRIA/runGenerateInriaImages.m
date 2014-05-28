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
negTrain = struct('image',cell(n,1),'path',cell(n,1));
for i = 1:n
    relPath = [relDir '/' contents(i+2).name];
    I = imread([inriaDataSet '/' relPath]);
    negTrain(i).image = I;
    negTrain(i).path = relPath;
end

%% Negative test images
relDir = 'Test/neg';
contents = dir([inriaDataSet '/' relDir]);
n = numel(contents)-2;
negTest = struct('image',cell(n,1),'path',cell(n,1));
for i = 1:n
    relPath = [relDir '/' contents(i+2).name];
    I = imread([inriaDataSet '/' relPath]);
    negTest(i).image = I;
    negTest(i).path = relPath;
end

save([inriaDataSet '/inriaTrainFull'],'posTrain','negTrain')
save([inriaDataSet '/inriaTestFull'],'posTest','negTest')
