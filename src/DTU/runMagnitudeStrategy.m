clc, clear all

I = imread('C:\Users\Ben\Documents\GitHub\masterThesis\src\DTU\img1200x1600\SET001\Img001_diffuse.bmp');
I = rgb2gray(im2double(I));

d = kJetCoeffs(3);
L = dGaussScaleSpace(I,d,1,0);
for i = fieldnames(L)'
    L.(char(i)) = L.(char(i)){:};
end

Theta = diffStructure('Theta',L);
tic
M = diffStructure('M',L);
toc
S = diffStructure('S',L);
C = diffStructure('C',L);
j2 = diffStructure('j2',L,1);
test = diffStructure('test',L,1);

figure
imshow(test,[0 0.05])

%% Rotated

L = dGaussScaleSpace(imrotate(I,30,'test'),d,1,0);
for i = fieldnames(L)'
    L.(char(i)) = L.(char(i)){:};
end

Theta = diffStructure('Theta',L);
M = diffStructure('M',L);
S = diffStructure('S',L);
C = diffStructure('C',L);
j2 = diffStructure('j2',L,1);
test = diffStructure('test',L,1);

figure
imshow(imrotate(test,-30,'test'),[0 0.05])