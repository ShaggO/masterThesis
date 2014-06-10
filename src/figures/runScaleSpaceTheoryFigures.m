clc, clear

I = imread('..\data\inrIAPerson\Train\neg\no_person__no_bike_183.png');
I = rgb2gray(im2double(I));

scales = 2.^(0:5);
S = dGaussScaleSpace(I,[0 0],scales,0,1);

imwrite(I,'../report/img/scaleSpaceTheory_0.png');
for i = 1:numel(scales)
    imwrite(S(i).none,['../report/img/scaleSpaceTheory_' num2str(scales(i)) '.png']);
end