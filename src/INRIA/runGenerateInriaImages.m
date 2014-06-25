clc, clear all

rng(1,'combRecursive');
windowsPerImage = 10;
load('paths')

% %% Positive training images
% relDir = '96X160H96/Train/pos';
% contents = dir([inriaDataSet '/' relDir]);
% n = numel(contents)-2;
% images = struct('image',cell(n,1),'path',cell(n,1));
% for i = 1:n
%     relPath = [relDir '/' contents(i+2).name];
%     I = imread([inriaDataSet '/' relPath]);
%     images(i).image = I(14:end-13,14:end-13,:);
%     images(i).path = relPath;
% end
% nPosTrain = n;
% 
% save([inriaDataSet '/inriaPosTrain'],'images')
% 
% %% Positive test images
% relDir = '70X134H96/Test/pos';
% contents = dir([inriaDataSet '/' relDir]);
% n = numel(contents)-2;
% images = struct('image',cell(n,1),'path',cell(n,1));
% for i = 1:n
%     relPath = [relDir '/' contents(i+2).name];
%     I = imread([inriaDataSet '/' relPath]);
%     images(i).image = I;
%     images(i).path = relPath;
% end
% nPosTest = n;
% 
% save([inriaDataSet '/inriaPosTest'],'images')

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

save([inriaDataSet '/inriaNegTrainCutouts'],'images')

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

save([inriaDataSet '/inriaNegTestCutouts'],'images')

% %% Negative training images (full)
% relDir = 'Train/neg';
% contents = dir([inriaDataSet '/' relDir]);
% n = numel(contents)-2;
% images = struct('image',cell(n,1),'path',cell(n,1));
% for i = 1:n
%     relPath = [relDir '/' contents(i+2).name];
%     I = imread([inriaDataSet '/' relPath]);
%     images(i).image = I;
%     images(i).path = relPath;
% end
% nNegTrainFull = n;
% 
% save([inriaDataSet '/inriaNegTrainFull'],'images')
% 
% %% Negative test images (full)
% relDir = 'Test/neg';
% contents = dir([inriaDataSet '/' relDir]);
% n = numel(contents)-2;
% images = struct('image',cell(n,1),'path',cell(n,1));
% for i = 1:n
%     relPath = [relDir '/' contents(i+2).name];
%     I = imread([inriaDataSet '/' relPath]);
%     images(i).image = I;
%     images(i).path = relPath;
% end
% nNegTestFull = n;
% 
% save([inriaDataSet '/inriaNegTestFull'],'images')
% 
% %% Metadata
% 
% save([inriaDataSet '/inriaMetadata'],'nPosTrain','nPosTest','nNegTrainFull','nNegTestFull','windowsPerImage')