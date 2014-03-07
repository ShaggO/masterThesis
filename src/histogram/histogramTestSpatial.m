% Test spatial weighting of histograms
clc, clear all;
sigma = [1 1];

I = rand(11,11);

[coordX, coordY] = meshgrid(1:11,1:11);

w = spatialWeights([coordX(:) coordY(:)],[6 6],'gaussian',sigma);

figure();
surf(coordX,coordY,reshape(w,size(I)));

[f, r] = ndFilter('gaussian',0.1);
c = createBinCenters(0,1,10);
h = ndHist(I(:),w,c,f,r);

figure;
plot([c c]',[h zeros(size(c))]','-b');
