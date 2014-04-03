function Hnorm = blockNormalization(H,C,L,type,sigma)
%BLOCKNORMALIZATION Summary of this function goes here
% Input:
%   M       Magnitude weights
%   C       Cell offsets
%   L       Center offsets of local normalization filters
%   type    Type of filter: gaussian, box or triangle
%   sigma   Variance of filter

sizeH = size(H);

[f,~] = ndFilter(type,sigma);
C = permute(C,[3 2 1]);
d = f(abs(repmat(C,[size(L,1) 1 1])-repmat(L, [1 1 size(C,3)])));
d = repmat(d,[1 1 1 sizeH(4:end)]);
s = sum(repmat(sum(H,1),[size(L,1) 1 1]) .* d,3);
Hnorm = H .* repmat(sum(d ./ repmat(s,[1 1 size(C,3)]),1),[size(H,1) 1]);

end

