function G = dGauss2d(m,n,hsize,sigma)

G = fliplr(dGauss1d(n,hsize,sigma))' * dGauss1d(m,hsize,sigma);

end
