function [X,D] = inriaDescriptors(images,mFunc,runInParallel)

if nargin < 3
    runInParallel = false;
end

p = load('paths');
inriaResults = p.inriaResults;

X = cell(numel(images),1);
D = X;
if runInParallel
    gcp;
    parfor i = 1:numel(images)
        disp(['Image ' num2str(i) '/' num2str(numel(images))]);
        I = im2single(images(i).image);
        [X{i},D{i}] = mFunc(I,inriaResults,i,false);
    end
else
    for i = 1:numel(images)
        disp(['Image ' num2str(i) '/' num2str(numel(images))]);
        I = im2single(images(i).image);
        [X{i},D{i}] = mFunc(I,inriaResults,i,false);
    end
end
X = cell2mat(X);
D = cell2mat(D);

end