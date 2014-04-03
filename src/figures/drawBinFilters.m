function [] = drawBinFilters(binType,binSigma,left,right,binCount,binCArgin,period,colour)

% scale binSigma
binSigma = binSigma .* (right-left) ./ binCount;

[binF, ~] = ndFilter(binType,binSigma);
binC = createBinCenters(left,right,binCount,binCArgin{:});
wRenorm = renormWeights(binType,binSigma,left,right,period > 0,binC);

x = linspace(left,right,1000)';

hold on
for i = 1:binCount
    y(:,i) = wRenorm(i)*binF(abs(x-binC(i)));
    plot(x,y(:,i),colour{i})
end
axis([left right 0 1.2*binCount/(right-left)])

end

