function D = hogsi(I, P, sigma, nBlock, nCell, bins)
% Computes a HOGSI descriptor
% Input:
% I     Image
% P     n x 2 matrix of interest points
% Output:
% D     n x m matrix of descriptors

N = size(P,1);
D = zeros(N,bins);
hsize = ceil(6*sigma);

Ix = imfilter(I,gauss(hsize,sigma,'x'),'replicate','conv');
Iy = imfilter(I,gauss(hsize,sigma,'y'),'replicate','conv');
Theta = atan2(Iy, Ix);
M = sigma^2 * sqrt(Ix .^ 2 + Iy .^ 2);

for n = 1:N
    p = P(n,:);
    for i = 1:nBlock
        for j = 1:nBlock
            iStart = p(1) - floor((nBlock*nCell-1)/2) + (i-1)*nCell;
            iRange = iStart + (0:nCell-1);
            jStart = p(2) - floor((nBlock*nCell-1)/2) + (j-1)*nCell;
            jRange = jStart + (0:nCell-1);
            blockOffset = (sub2ind([nBlock nBlock],i,j)-1)*bins;
            h = weightedHist(Theta(iRange,jRange),M(iRange,jRange), ...
                linspace(-pi,pi,bins+1));
            D(n,blockOffset + (1:bins)) = h;
            
            plot([jRange(1) jRange(end) jRange(end) jRange(1) jRange(1)],...
                [iRange(1) iRange(1) iRange(end) iRange(end) iRange(1)],'r-')
            for k = 1:bins
                theta = -pi + pi/bins + (k-1)*2*pi/bins;
                plot(jStart + nCell/2 + 3*[0 cos(theta)*h(k)], ...
                    iStart + nCell/2 + 3*[0 sin(theta)*h(k)], 'r-')
            end
        end
    end
%     plot(p(2),p(1),'cx','linewidth',10)
end
% quiver(1:size(I,2),1:size(I,1),Ix,Iy);

end