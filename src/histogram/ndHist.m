function [H] = ndHist(x,weights,binC,fHandle,r,varargin)
% NDHIST Create a n-dimensional histogram
% Params:
%   x       Values to make a histogram for  [n,d,...]
%   weights Weights on values x             [n,1,...]
%   binC    Bin centers                     [i,d,...]
%   fHandle Bin filter (symmetric around d=0) taking one input: distances to bin center
%                                           [n,d,...] -> [n,1,...]
%   r       Bin filter support radius
% Optional parameter:
%   period  Period of periodic values

sizeX = size(x);

p = inputParser;
addOptional(p, 'period', zeros(1,sizeX(2)), @isnumeric);
parse(p,varargin{:});
period = p.Results.period;

% Precompute variables for use when the histogram is periodic
periodic = period ~= 0;
mask = repmat(periodic,[sizeX(1) 1 sizeX(3:end)]);
pMask = repmat(period(periodic),[sizeX(1) 1 sizeX(3:end)]);

H = zeros([size(binC,1),1,sizeX(3:end)]);
for i = 1:size(binC,1)
    d = abs(repmat(binC(i,:),[sizeX(1) 1 sizeX(3:end)]) - x);
    if any(periodic)
        d(mask) = min(d(mask),pMask(:) - d(mask));
    end
    rMask = all(d <= repmat(r,[sizeX(1) 1 sizeX(3:end)]),2);
    H(i,1,:,:) = sum(rMask .* weights .* fHandle(d),1); % optimize later!
end

end
