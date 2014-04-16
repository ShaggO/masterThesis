function h = imageHash(I)
%IMAGEHASH Summary of this function goes here

rng(1);
I = round(double(I)*10^5) .* randi(10^5,size(I));
h = sum(I(:));

end
