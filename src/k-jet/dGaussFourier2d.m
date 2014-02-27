function G = dGaussFourier2d(m,n,hsize,sigma)

if numel(hsize) == 1
    hsize(2) = hsize;
end

G = dGaussFourier1d(n,hsize(1),sigma)' * dGaussFourier1d(m,hsize(2),sigma);

end