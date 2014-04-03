function Mnorm = pixelNormalization(M,type,sigma)
%PIXELNORMALIZATION Compute pixel-wise normalization
%
% Inputs:
%   M       Magnitude/weight {i}[:,:]
%   type  Filter type
%   sigma   Filter std.dev.

[f,r] = ndFilter(type,sigma);
rMin = floor(-r);
rMax = ceil(r);

[X,Y] = meshgrid(rMin(2):rMax(2),rMin(1):rMax(1));

V = f([X(:),Y(:)]);
F = reshape(V,size(X));
Mnorm = M ./ imfilter(M,F,'conv','replicate');

end
