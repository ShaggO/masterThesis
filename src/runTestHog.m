clc, clear

im = 255*imnorm(single(dGauss2d(0,0,39,20)));

cellSize = 8 ;
hog = vl_hog(im, cellSize, 'verbose') ;

imhog = vl_hog('render', hog, 'verbose') ;
figure ; imagesc(imhog) ; colormap gray ;