function Mnorm = localNormalization(M,C,L,type,sigma)
%LOCALNORMALIZATION Summary of this function goes here
% Input:
%   M       Magnitude weights
%   C       Cell offsets
%   L       Center offsets of local normalization filters
%   type    Type of filter: gaussian, box or triangle
%   sigma   Variance of filter

[f,~] = ndFilter(type,sigma);
L = permute(L,[3 2 1]);
w = f(abs(repmat(C,[1 1 size(L,3)])-repmat(L, [size(C,1) 1 1])))
s = sum(repmat(M,[1 1 size(L,3)]) .* w,1)
Mnorm = M .* sum(w ./ repmat(s,[size(C,1) 1 1]),3);

end

