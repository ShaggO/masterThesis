function B = ndBinWeights(V,binC,f,r,varargin)
% NDHIST Compute n-dimensional histogram bin weights
% Input:
%   V       Values to compute weights for   [n,d]
%   binC    Bin centers                     [i,d]
%   f       Bin filter (symmetric around d=0) taking one input: distances to bin center
%                                           [n,d] -> [n,1]
%   r       Bin filter support radius
% Optional input:
%   wBin    Weights on bins                 [i,1]
%   period  Period of periodic dimensions   [1,d]
% Output:
%   B       Bin weights                     [n,i]

nV = size(V,1);
nBins = size(binC,1);

p = inputParser;
addOptional(p, 'wBin', ones(size(binC,1),1), @isnumeric);
addOptional(p, 'period', zeros(1,size(V,2)), @isnumeric);
parse(p,varargin{:});
wBin = p.Results.wBin;
period = p.Results.period;

% Precompute variables for use when the histogram is periodic
periodic = period ~= 0;
pMask = repmat(periodic,[nV 1]);
period = period(periodic);

B = zeros([nV nBins]);
for i = 1:size(binC,1)
    % Compute distance from all points to bin center i
    d = abs(repmat(binC(i,:),[nV 1]) - V);
    if any(periodic)
        % Consider opposite distance if periodic
        d(pMask) = min(d(pMask),period - d(pMask));
    end
    % Find distances within bin filter support radius
    rMask = all(d <= repmat(r,[nV 1]),2);
    dr = d(rMask,:);
    % Compute bin weights
    B(rMask,i) = wBin(i) * f(dr);
end

end
