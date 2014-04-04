function [gridSpacing,centerSigma,cellSigma,binSigma,normSigma] = ...
    scaleParameters(rescale,gridType,gridSize,gridSpacing,centerSigma,cellSigma,...
    binSigma,binCount,normType,normSigma,left,right)
%SCALEPARAMETERS Scale parameters and interest points based on relative
%definitions and rescale factor

% Relative definitions
switch gridType
    case 'square'
        centerSigma = centerSigma .* gridSize .* gridSpacing / 2;
    otherwise
        centerSigma = centerSigma * gridSize(2) * gridSpacing / 2;
end
cellSigma = cellSigma .* gridSpacing / 2;
binSigma = binSigma .* (right-left) ./ (2*binCount);
if strcmp(normType,'block')
    normSigma = normSigma .* gridSpacing / 2;
end

% Rescale factor
if rescale > 0
    gridSpacing = rescale * gridSpacing;
    centerSigma = rescale * centerSigma;
    cellSigma = rescale * cellSigma;
    normSigma = rescale * normSigma;
end

end

