function [gridSpacing,centerSigma,cellSigma,binSigma,normSigma] = ...
    scaleParameters(rescale,gridType,gridSize,gridRadius,centerSigma,cellSigma,...
    binSigma,binCount,normType,normSigma,left,right)
%SCALEPARAMETERS Scale parameters and interest points based on relative
%definitions and rescale factor

% Relative definitions
switch gridType
    case 'square'
        gridSpacing = 2*gridRadius ./ gridSize;
    otherwise % polar or concentric polar
        gridSpacing = 2*gridRadius ./ (2*gridSize(2)+1);
end
centerSigma = centerSigma .* gridRadius;
cellSigma = cellSigma .* gridSpacing/2;
binSigma = binSigma .* (right-left) ./ (2*binCount);
if strcmp(normType,'block')
    normSigma = normSigma .* gridRadius/2;
end

% Rescale factor
if rescale > 0
    gridSpacing = rescale * gridSpacing;
    centerSigma = rescale * centerSigma;
    cellSigma = rescale * cellSigma;
    normSigma = rescale * normSigma;
end

end

