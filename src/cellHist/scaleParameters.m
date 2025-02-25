function [gridRadius,centerSigma,cellSigma,binSigma,normSigma] = ...
    scaleParameters(rescale,gridSize,gridRadius,centerSigma, ...
    cellFilter,cellSigma,binSigma,binCount,normType,normSigma,left,right)
%SCALEPARAMETERS Scale parameters and interest points based on relative
%definitions and rescale factor

% Rescale factor
if rescale > 0
    gridRadius = rescale * gridRadius;
    normSigma = rescale * normSigma;
end

centerSigma = centerSigma .* gridRadius;
binSigma = binSigma .* (right-left) ./ (2*binCount);
if strcmp(normType,'block')
    normSigma = normSigma .* gridRadius/2;
end

end