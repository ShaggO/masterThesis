clc, clear

I = imread('..\data\inrIAPerson\Train\neg\no_person__no_bike_183.png');
I = rgb2gray(im2double(I));

scales = 1;
d = kJetCoeffs(3);
L = dGaussScaleSpace(I,d,scales,0,1);
Gx = L(1).x;
Gy = L(1).y;
Gxx = L(1).xx;
Gxy = L(1).xy;
Gyy = L(1).yy;
Gxxx = L(1).xxx;
Gxxy = L(1).xxy;
Gxyy = L(1).xyy;
Gyyy = L(1).yyy;

% D = sqrt(Gxx.^2 + 4*Gxy.^2 - 2*Gxx.*Gyy + Gyy.^2);
% L1 = (Gxx + Gyy - D)/2;
% L2 = (Gxx + Gyy + D)/2;
% Lr = intgrad2(N,D);

N = -Gxx - Gyy;
D = sqrt(4*Gxy.^2 + (Gxx - Gyy).^2);
S = atan(N ./ D);
C = sqrt(Gxx.^2 + 2*Gxy.^2 + Gyy.^2);

% figure, imshow(N,[])
% figure, imshow(D,[])
figure, imshow(S,[])
figure, imshow(C,[])

N = -Gxxx - Gyyy;
D = sqrt(6*(Gxxy.^2 + Gxyy.^2) + (Gxxx - Gyyy).^2);
S = atan(N ./ D);
C = sqrt(Gxxx.^2 + 3*Gxxy.^2 + 3*Gxyy.^2 + Gyyy.^2);

% figure, imshow(N,[])
% figure, imshow(D,[])
figure, imshow(S,[])
figure, imshow(C,[])