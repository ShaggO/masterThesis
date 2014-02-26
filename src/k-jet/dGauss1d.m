function G = dGauss1d(n,hsize,sigma)

a = 1/(sigma*sqrt(2));
x = -(hsize-1)/2:(hsize-1)/2;
G = (-a)^n * 1/(sqrt(2*pi)*sigma) * exp(-a^2 * x.^2) .* hermite(n,a*x);

end

