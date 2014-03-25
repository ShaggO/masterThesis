clc, clear all

I = im2double(imread(dtuImagePath(1,1,'diffuse')));
J = colourTransform(I,'c-colour');
r1 = [min(min(J(:,:,1))) max(max(J(:,:,1)))]
r2 = [min(min(J(:,:,2))) max(max(J(:,:,2)))]
r3 = [min(min(J(:,:,3))) max(max(J(:,:,3)))]

figure('units','normalized','outerposition',[0 0 1 1])
subplot(221)
imshow(I)
subplot(222)
imshow(J(:,:,1),[0 1])
subplot(223)
imshow(J(:,:,2),[0 1])
subplot(224)
imshow(J(:,:,3),[0 1])