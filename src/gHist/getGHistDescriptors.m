function [X,D] = getGHistDescriptors(I,F,patchSize,spatialType,spatialSigma,binType,binSigma,binCount)

I = rgb2gray(im2double(I));

% Assume single-scale detected points
sigma = F(1,3);
hsize = ceil(6*sigma);
Ix = imfilter(I,dGauss2d(1,0,hsize,sigma),'replicate','conv');
Iy = imfilter(I,dGauss2d(0,1,hsize,sigma),'replicate','conv');
Theta = atan2(Iy, Ix);
M = sigma^2 * sqrt(Ix .^ 2 + Iy .^ 2);

[coordX, coordY] = meshgrid(1:patchSize(2),1:patchSize(1));
w = spatialWeights([coordX(:) coordY(:)], patchSize, spatialType, spatialSigma);
[f, r] = ndFilter(binType,binSigma);
c = createBinCenters(0,2*pi,binCount);
[patchX,patchY] = meshgrid(-(patchSize(1)-1)/2:(patchSize(1)-1)/2,...
                    -(patchSize(2)-1)/2:(patchSize-1)/2);

D = zeros(size(F,1),binCount);

for i = 1:size(F,1)
    x = interp2(Theta,F(i,1)+patchX,F(i,2)+patchY,'bilinear');
    m = interp2(M,F(i,1)+patchX,F(i,2)+patchY,'bilinear');
    D(i,:) = ndHist(x(:),m(:).*w,c,f,r,2*pi);
end

X = F(:,1:2);

end
