function I = imnorm(I,sym)
%IMNORM Normalize image

if nargin < 2
    sym = false;
end

if sym
    maxI = max(abs(I(:)));
    minI = -maxI;
else
    maxI = max(I(:));
    minI = min(I(:));
end

I = (I - minI) / (maxI - minI);

end