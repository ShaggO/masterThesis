clc, clear all

I = imread('coins.png');
J = single(I);

[F1,~] = vl_sift(J)

[F2,~] = vl_covdet(J,'edgethreshold',1.5,'method',)

figure
imshow(I)
hold on
plot(F1(1,:),F1(2,:),'r.')
figure
imshow(I)
hold on
plot(F2(1,:),F2(2,:),'r.')