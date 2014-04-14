function h = imageHash(I)
%IMAGEHASH Summary of this function goes here

rng(1)
I = I .* randi(2^20,size(I));
h = sum(I(:));

end

