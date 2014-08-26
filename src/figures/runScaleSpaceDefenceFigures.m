clc, clear

%I = imread('..\data\inrIAPerson\Train\neg\no_person__no_bike_183.png');
I = imread('../defence/img/shoeOriginal.jpg');
I = rgb2gray(im2double(I));

scales = 2.^(0:8);
S = dGaussScaleSpace(I,[0 0],scales,0,1);

imwrite(I,'../defence/img/scaleSpaceTheory_0.png');
for i = 1:numel(scales)
    imwrite(S(i).none,['../defence/img/scaleSpaceTheory_' num2str(scales(i)) '.png']);
end

for i = [1 4]
    DoG = S(i+1).none - S(i).none;
    DoG = (DoG + 0.2) / 0.4;
    imwrite(DoG,['../defence/img/scaleSpaceTheory_' num2str(scales(i+1)) '-' num2str(scales(i)) '.png']);
end
