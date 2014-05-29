function I = imnorm(I)
%IMNORM Normalize image

I = (I - min(I(:))) / (max(I(:)) - min(I(:)));

end

