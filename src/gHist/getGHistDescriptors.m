function [X,D] = getGHistDescriptors(I,F, ...
    blockSize,cellSize,spatialType,spatialSigma,binType,binSigma,binCount)
% GETGHISTDESCRIPTORS Customizable descriptor based on cells of gradient
% histograms.
%
% Input:
%   I               RGB image
%   F               Detected features
%   blockSize       Number of cells in x and y direction
%   cellSize        Number of pixels in each cell in x and y direction
%   spatialType     Type of spatial filter (on distance from cell center)
%   spatialSigma    Variance of spatial filter
%   binType         Type of bin filter (on distance from bin center)
%   binSigma        Variance of bin filter
%   binCount        Number of bins

I = rgb2gray(im2double(I));

% Remove features too close to border
minCoords = 1 + (cellSize-1)/2 + (blockSize-1)/2 .* cellSize;
maxCoords = flip(size(I)) - minCoords + 1;

F = F(F(:,1) >= minCoords(1) & F(:,1) <= maxCoords(1) & ...
    F(:,2) >= minCoords(2) & F(:,2) <= maxCoords(2),:);

% Assume single-scale detected points
sigma = F(1,3);
hsize = ceil(6*sigma);
Ix = imfilter(I,dGauss2d(1,0,hsize,sigma),'replicate','conv');
Iy = imfilter(I,dGauss2d(0,1,hsize,sigma),'replicate','conv');
Theta = atan2(Iy, Ix);
M = sigma^2 * sqrt(Ix .^ 2 + Iy .^ 2);

[coordX, coordY] = meshgrid(1:cellSize(2),1:cellSize(1));
w = spatialWeights([coordX(:) coordY(:)],cellSize,spatialType,spatialSigma);
[f, r] = ndFilter(binType,binSigma);
c = createBinCenters(0,2*pi,binCount);
[patchX,patchY] = meshgrid(-(cellSize(1)-1)/2:(cellSize(1)-1)/2,...
    -(cellSize(2)-1)/2:(cellSize-1)/2);

D = zeros(size(F,1),prod(blockSize)*binCount);

Px = zeros(size(F,1),prod(cellSize),prod(blockSize));
Py = Px;

for j = 1:prod(blockSize)
    [cellX,cellY] = ind2sub(blockSize,j);
    x = F(:,1) + (cellX-(blockSize(1)+1)/2)*cellSize(1);
    y = F(:,2) + (cellY-(blockSize(2)+1)/2)*cellSize(2);
    Px(:,:,j) = repmat(x,[1 numel(patchX)]) + repmat(patchX(:)',[numel(x) 1]);
    Py(:,:,j) = repmat(y,[1 numel(patchY)]) + repmat(patchY(:)',[numel(y) 1]);
end

theta = interp2(Theta,Px,Py,'bilinear');
m = interp2(M,Px,Py,'bilinear');

for i = 1:size(F,1)
    h = ndHist(permute(theta(i,:,:),[2 1 3]),permute(m(i,:,:),[2 1 3]).*repmat(w,[1 1 size(m,3)]),c,f,r,2*pi);
    for j = 1:prod(blockSize)
        D(i,(j-1)*binCount+(1:binCount)) = h(:,:,j);
    end
end

X = F(:,1:2);

end
