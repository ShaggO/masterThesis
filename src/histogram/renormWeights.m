function w = renormWeights(type, sigma, left, right, periodic, binC)
% RENORMWEIGHTS
% Inputs
%   type    Filter type: gaussian, box or triangle
%   sigma   Filter variance/width [1,d]
%   left    Left endpoint [1,d]
%   right   Right endpoint [1,d]
%   binC    Bin centers [i,d]
% Output
%   w       Weights [i,1]

assert(all(size(sigma) == size(left) & size(sigma) == size(right)),...
    'Sigma, left, and right need to have equal size');

left(periodic) = -Inf;
right(periodic) = Inf;

Sigma = repmat(sigma,[size(binC,1) 1]);
A = repmat(left,[size(binC,1) 1]) - binC;
B = repmat(right,[size(binC,1) 1]) - binC;

switch type
    case 'gaussian'
        w = 1 ./ prod(1/2*(erf(B./(sqrt(2)*Sigma)) - ...
            erf(A./(sqrt(2)*Sigma))),2);

    case 'box'
        w = 2 ./ prod(min(B,Sigma) - max(A,-Sigma),2);

    case 'triangle'
        A = max(A,-2*Sigma);
        B = min(B,2*Sigma);
        w = 2 ./ prod(B .* (1 - B./(4*Sigma)) - A .* (1 + A./(4*Sigma)),2);
end
end
