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
sizeF = [sizeX(1) 1 sizeX(3:end)];

p = inputParser;
addOptional(p, 'wBin', ones(size(binC,1),1), @isnumeric);
addOptional(p, 'period', zeros(1,sizeX(2)), @isnumeric);
parse(p,varargin{:});
wBin = p.Results.wBin;
period = p.Results.period;

% Precompute variables for use when the histogram is periodic
periodic = period ~= 0;
mask = repmat(periodic,sizeF);
pMask = repmat(period(periodic),sizeF);

H = zeros([size(binC,1),1,sizeX(3:end)]);
for i = 1:size(binC,1)
    % Compute distance from all points to bin center
    d = abs(repmat(binC(i,:),sizeF) - x);
    if any(periodic)
        % Consider opposite distance if periodic
        d(mask) = min(d(mask),pMask(:) - d(mask));
    end
    % Find distances within bin filter support radius
    % note: this mask does not include the second dimension by design
    rMask = all(d <= repmat(r,sizeF),2);
    % Compute bin value
    dr = d(permute(repmat(rMask,[1 sizeX(2)]),[2 1 3:numel(sizeX)]));
    dr = permute(reshape(dr,sizeX(2),[]),[2 1]);
    fd = zeros(sizeF);
    fd(rMask) = fHandle(dr);
    H(i,1,:,:) = repmat(wBin(i),[1 1 sizeX(3:end)]) .* sum(wX .* fd,1);
end

end
