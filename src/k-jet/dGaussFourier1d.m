function G = dGaussFourier1d(n,hsize,sigma)

u = linspace(-pi,pi,hsize);
G = (1i*u).^n .* exp(-u.^2*sigma^2/2);

end

