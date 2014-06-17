clc, clear all

rng(2,'combRecursive');
windowsPerImage = 10;
load('paths')

%% Negative training images (cutouts)
relDir = 'Train/neg';
contents = dir([inriaDataSet '/' relDir]);
n = numel(contents)-2;
images = struct('image',cell(10,n),'path',cell(10,n));
for i = 1:n
    relPath = [relDir '/' contents(i+2).name];
    I = imread([inriaDataSet '/' relPath]);
    for j = 1:windowsPerImage
        y = randi(size(I,1)-133);
        x = randi(size(I,2)-69);
        images(j,i).image = I(y+(0:133),x+(0:69),:);
        images(j,i).path = relPath;
    end
end
images = images(:);
nNegTrainCutouts = n;

save([inriaDataSet '/inriaNegTrainCutouts2'],'images')

%% Negative test images (cutouts)
relDir = 'Test/neg';
contents = dir([inriaDataSet '/' relDir]);
n = numel(contents)-2;
images = struct('image',cell(10,n),'path',cell(10,n));
for i = 1:n
    relPath = [relDir '/' contents(i+2).name];
    I = imread([inriaDataSet '/' relPath]);
    for j = 1:windowsPerImage
        y = randi(size(I,1)-133);
        x = randi(size(I,2)-69);
        images(j,i).image = I(y+(0:133),x+(0:69),:);
        images(j,i).path = relPath;
    end
end
images = images(:);
nNegTestCutouts = n;

save([inriaDataSet '/inriaNegTestCutouts2'],'images')