function D = inriaDescriptors(images,mFunc,runInParallel)

if nargin < 3
    runInParallel = false;
end

p = load('paths');
inriaResults = p.inriaResults;

D = cell(numel(images),1);
if runInParallel
    gcp
    parfor i = 1:numel(images)
        disp(['Image ' num2str(i) '/' num2str(numel(images))]);
        I = im2single(images(i).image);
        [~,D{i}] = mFunc(I,inriaResults,num2str(i),false);
    end
else
    for i = 1:numel(images)
        disp(['Image ' num2str(i) '/' num2str(numel(images))]);
        I = im2single(images(i).image);
        [~,D{i}] = mFunc(I,inriaResults,num2str(i),false);
    end
end
D = cell2mat(D);

end
