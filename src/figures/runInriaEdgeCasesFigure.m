clc, clear all

data = inriaData;
posTest = data.loadCache('posTest');

load('results/inriaTestSvmGoSi100kSeed2','probPos')

[~,idx] = sort(probPos,'descend');

figure
for i = 1:24
    subplot(4,6,i)
    imshow(posTest(idx(i)).image)
end