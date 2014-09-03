clc, clear all

A = imread('C:\Users\Ben\Documents\GitHub\masterThesis\data\DTU\img1200x1600\scene007\001_00.png');
B = imread('C:\Users\Ben\Documents\GitHub\masterThesis\data\DTU\img1200x1600\scene007\049_00.png');
I = [A(:,800:1600,:) 255*ones(1200,50,3) B(:,600:1400,:)];
I = imadjust(I,[0 1],[0.2 1]);

figure
imshow(I)
hold on
plot([524 1300],[284 215],'g-','linewidth',3)
saveTightFigure(gcf,'../defence/img/introductionIC.pdf')

C = imread('C:\Users\Ben\Documents\GitHub\masterThesis\data\INRIAPerson\Test\pos\crop001604.png');
I = C(87:end,:,:);
I = imadjust(I,[0 1],[0.2 1]);
x = [372 365-86]; 
w = 3.3*[[-32 -32 32 32 -32]' [-64 64 64 -64 -64]']; 

figure
imshow(I)
hold on
plot(x(1)+w(:,1),x(2)+w(:,2),'y-','linewidth',3)
saveTightFigure(gcf,'../defence/img/introductionOD.pdf')