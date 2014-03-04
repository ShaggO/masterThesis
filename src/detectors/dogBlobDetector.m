function points = dogBlobDetector(I, sigma, k, threshold)

hsize = 2*floor(6*k*sigma/2)+1;
H = dGauss2d(0,0,hsize,k*sigma) - dGauss2d(0,0,hsize,sigma);
J = imfilter(I,H,'replicate','conv');

[minima, maxima] = findExtrema(J);

% [~, sort_index] = sort(abs(J(:)) .* minima(:),'descend');
% [X,Y] = ind2sub(size(J), sort_index(1:points/2));
% bright = [X Y];
% 
% [~, sort_index] = sort(abs(J(:)) .* maxima(:),'descend');
% [X,Y] = ind2sub(size(J), sort_index(1:points/2));
% dark = [X Y];
%
% points = [bright; dark];

[Y,X] = find((abs(J) >= threshold) & (minima | maxima));
points = [X Y repmat(sigma,[size(X,1) 1])];

end