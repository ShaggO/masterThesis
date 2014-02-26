function h = hermite(n,x)

h = zeros(n+1,1);
for m = 0:floor(n/2)
    h(2*m+1) = factorial(n) * (-1)^m / (factorial(m) * factorial(n-2*m)) * 2^(n-2*m);
end

h = polyval(h,x);

end