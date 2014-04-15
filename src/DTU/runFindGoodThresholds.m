clc, clear all

I = rgb2gray(im2double(loadDtuImage(1,1,'diffuse')));
sigma = 1:10;
threshold = [0.085 0.1 linspace(0.1,0.01,8)];

for i = 1:numel(sigma)
    s = sigma(i);
    n(i) = size(dogBlobDetector(I,s,2,threshold(i)),1);
end

figure
plot(sigma,n)
