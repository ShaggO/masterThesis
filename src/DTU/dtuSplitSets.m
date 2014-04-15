function S = dtuSplitSets(n,k)
%DTUSPLITSETS Splits the sets of the DTU dataset into n parts. Optionally
%only retrieve the k'th split(s).

if nargin < 2
    k = 1:n;
end

sets = 60;

rng(1)
S = reshape(randperm(sets),[sets/n n]);
S = S(:,k)';

end