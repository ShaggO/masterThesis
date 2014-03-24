function [H] = ndHist(x,wX,binC,fHandle,r,varargin)
% NDHIST Create a n-dimensional histogram
% Params:
%   x       Values to make a histogram for  [n,d,...]
%   wX      Weights on values x             [n,1,...]
%   binC    Bin centers                     [i,d]
%   fHandle Bin filter (symmetric around d=0) taking one input: distances to bin center
%                                           [n,d,...] -> [n,1,...]
%   r       Bin filter support radius
% Optional parameter:
%   wBin    Weights on bins                 [i,1]
%   period  Period of periodic values

sizeX = size(x);

p = inputParser;
addOptional(p, 'wBin', ones(size(binC,1),1), @isnumeric);
addOptional(p, 'period', zeros(1,sizeX(2)), @isnumeric);
parse(p,varargin{:});
wBin = p.Results.wBin;
period = p.Results.period;

% Precompute variables for use when the histogram is periodic
periodic = period ~= 0;
mask = repmat(periodic,[sizeX(1) 1 sizeX(3:end)]);
pMask = repmat(period(periodic),[sizeX(1) 1 sizeX(3:end)]);

H = zeros([size(binC,1),1,sizeX(3:end)]);
for i = 1:size(binC,1)
    % Compute distance from all points to bin center
    d = abs(repmat(binC(i,:),[sizeX(1) 1 sizeX(3:end)]) - x);
    if any(periodic)
        % Consider opposite distance if periodic
        d(mask) = min(d(mask),pMask(:) - d(mask));
    end
    % Find distances within bin filter support radius
    rMask = all(d <= repmat(r,[sizeX(1) 1 sizeX(3:end)]),2);
    % Compute bin value
    fd = zeros(size(d));
    fd(rMask) = fHandle(d(rMask));
    H(i,1,:,:) = repmat(wBin(i),[1 1 sizeX(3:end)]) .* sum(wX .* fd,1);
end

end
