clc, clear all

nWindows = 40;
seed = 1*10^4;
name = {'Go','Si'};
normType = {'none','pixel','pixelvar'};

data = inriaData(nWindows,seed);

for i = 1:numel(name)
    params = load(['results/optimize/inriaParameters' name{i}]); % settings
    [~,~,PRAUC(i)] = inriaOptimizeEnum(data,'',params.method,params.svmArgs, ...
        'normType',normType);
end

save('inriaPixelNorm','PRAUC','name','normType','params','nWindows','seed')