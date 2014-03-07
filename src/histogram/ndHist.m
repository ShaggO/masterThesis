function [H] = ndHist(x,weights,binC,fHandle,r,varargin)
% NDHIST Create a n-dimensional histogram
% Params:
%   x       Values to make a histogram for
%   weights Weights on values x
%   binC    Bin centers
%   fHandle Bin filter (symmetric around d=0) taking one input: distances to bin center
%   r       Bin filter support radius 
% Optional parameter:
%   period  Period of periodic values

p = inputParser;
addOptional(p, 'period', zeros(1,size(x,2)), @isnumeric);
parse(p,varargin{:});
period = p.Results.period;

% Precompute variables for use when the histogram is periodic
periodic = period ~= 0;
mask = repmat(periodic,[size(x,1) 1]);
pMask = repmat(period(periodic),[size(x,1) 1]);

H = zeros(size(binC,1),1);
for i = 1:size(binC,1)
    d = abs(repmat(binC(i,:),[size(x,1) 1]) - x);
    if any(periodic)
        d(mask) = min(d(mask),pMask(:) - d(mask));
    end
    rMask = all(d <= repmat(r,[size(x,1) 1]),2);
    H(i) = sum(weights(rMask,:) .* fHandle(d(rMask,:)));
end

end
