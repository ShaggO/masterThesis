function Mnorm = pixelNormalization(M,type,sigma)
%PIXELNORMALIZATION Compute pixel-wise normalization
%
% Inputs:
%   M       Magnitude/weight {i}[:,:]
%   type    Filter type
%   sigma   Filter std.dev. [i,2]

Mnorm = cell(size(M));
for i = 1:numel(M)
    [f,r] = ndFilter(type,sigma(i,:));
    rMin = floor(-r);
    rMax = ceil(r);

    [X,Y] = meshgrid(rMin(2):rMax(2),rMin(1):rMax(1));

    V = f([X(:),Y(:)]);
    F = reshape(V,size(X));
    Mnorm{i} = M{i} ./ (imfilter(M{i},F,'conv','replicate') + eps);
end

end
