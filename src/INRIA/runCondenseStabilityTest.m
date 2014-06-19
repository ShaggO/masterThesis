clear all; clc;
nHard = 10^5;

nWindows = [1 2 5 10 20 40 60];
seed = (1:10)*10^4;
%name = {'Go','Si','GoSi','Hog','HogDT'};
name = {'Go','Si'};

PRAUC = zeros(numel(nWindows),numel(name),numel(seed));
ROCAUC = PRAUC;
start = tic;
for i = 1:numel(name)
    for j = 1:numel(nWindows)
        for k = 1:numel(seed)
            fileName = ['results/inriaTestSvm' name{i} '100k_' num2str(nWindows(j)) '_' num2str(seed(k)) '.mat'];
            results = load(fileName);
            PRAUC(j,i,k) = results.PRAUC;
            ROCAUC(j,i,k) = results.ROCAUC;
        end
    end
end
stop = toc(start)

save('results/inriaStabilityTest','nHard','nWindows','name','seed','PRAUC','ROCAUC');
