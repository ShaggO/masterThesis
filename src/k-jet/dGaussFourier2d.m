function G = dGaussFourier2d(m,n,hsize,sigma)

G = dGaussFourier1d(n,hsize,sigma)' * dGaussFourier1d(m,hsize,sigma);

end