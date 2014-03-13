function w = renormWeights(type, sigma, left, right, binC)
% RENORMWEIGHTS
% Inputs
%   type    Filter type: gaussian, box or triangle
%   sigma   Filter variance/width [1,d]
%   left    Left endpoint [1,d]
%   right   Right endpoint [1,d]
%   binC    Bin centers [i,d]

Sigma = repmat(sigma,[size(binC,1) 1]);
A = repmat(left,[size(binC,1) 1]) - binC;
B = repmat(right,[size(binC,1) 1]) - binC;

switch type
    case 'gaussian'
        w = 1 ./ prod(1/2*(erf(B./(sqrt(2)*Sigma)) - ...
            erf(A./(sqrt(2)*Sigma))),2);
        
    case 'box'
        w = 1 ./ prod(min(B,Sigma/2) - max(A,-Sigma/2),2);
        
    case 'triangle'
        A = max(A,-Sigma);
        B = min(B,Sigma);
        w = 1 ./ prod(B .* (1 - B./(2*Sigma)) - A .* (1 + A./(2*Sigma)),2);
end
end
