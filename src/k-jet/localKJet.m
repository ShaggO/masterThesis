function J = localKJet(I,F,k,sigma)
% Computes the local k-jet at given positions in an image

hsize = size(I);
d = kJetCoeffs(k);

for i = 1:size(d,1)
    F = dGaussFourier2d(d(i,1),d(i,2),hsize,sigma);
end

end

