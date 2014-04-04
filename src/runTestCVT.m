clc, clear all

Irgb = imread(dtuImagePath(1,1,'diffuse'));
I = rgb2gray(im2single(Irgb));
points = detectBRISKFeatures(I);

figure
imshow(Irgb); hold on;
plot(points);

S = dGaussScaleSpace(I,[0 0],11,0);
figure
imshow(S.none)

D1 = extractFeatures(I,points,'Method','SURF');
% D1 = D1.Features;

s = SURFPoints(points.Location,'Scale',points.Scale);
D2 = extractFeatures(I,s,'Method','SURF');
% D2 = D2.Features;

b = BRISKPoints(points.Location,'Scale',points.Scale);
D3 = extractFeatures(I,b,'Method','BRISK');
D3 = D3.Features;