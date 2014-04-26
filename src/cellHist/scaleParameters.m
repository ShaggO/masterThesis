function [gridSpacing,centerSigma,cellSigma,binSigma,normSigma] = ...
    scaleParameters(rescale,gridType,gridSize,gridRadius,centerSigma, ...
    cellFilter,cellSigma,binSigma,binCount,normType,normSigma,left,right)
%SCALEPARAMETERS Scale parameters and interest points based on relative
%definitions and rescale factor

% Rescale factor
if rescale > 0
    gridRadius = rescale * gridRadius;
    normSigma = rescale * normSigma;
end

% Relative definitions
if strcmp(gridType,'square') % cartesian grid
    gridSpacing = 2*gridRadius ./ gridSize;
elseif any(strcmp(gridType,{'polar','concentric polar'}))
    % polar grid without central point
    gridSpacing = 2*gridRadius ./ (2*gridSize(2));
elseif any(strcmp(gridType,{'polar central','concentric polar central'}))
    % polar grid with central point
    gridSpacing = 2*gridRadius ./ (2*gridSize(2)+1);
end
if any(strcmp(cellFilter,{'gaussian','triangle','box'}))
    cellSigma = cellSigma .* gridSpacing/2;
else % polar cell filter
    assert(numel(gridSpacing) == 1, ...
        'Polar cell filters must be used with polar grids.')
    cellSigma = cellSigma .* [pi/gridSize(1) gridSpacing/2];
end
centerSigma = centerSigma .* gridRadius;
binSigma = binSigma .* (right-left) ./ (2*binCount);
if strcmp(normType,'block')
    normSigma = normSigma .* gridRadius/2;
end

end