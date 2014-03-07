function [X,D] = getGHistDescriptors(I,F,patchSize,spatialType,spatialSigma,binType,binSigma,binCount)

Ix = imfilter(I,dGauss2D(1,0,hsize,sigma),'replicate','conv');
Iy = imfilter(I,dGauss2D(0,1,hsize,sigma),'replicate','conv');
Theta = atan2(Iy, Ix);
M = sigma^2 * sqrt(Ix .^ 2 + Iy .^ 2);
%%
%% TODO
%% Add code for point extraction from the angles and magnitudes
%%

[coordX, coordY] = meshgrid(1:patchSize(2),1:patchSize(1));

w = spatialWeights([coordX(:) coordY(:)],(patchSize+1)/2,spatialType,spatialSigma);

[f, r] = ndFilter(binType,binSigma);

c = createBinCenters(0,2*pi,binCount);

D = ndHist(Theta,w,c,f,r,2*pi)';

end
