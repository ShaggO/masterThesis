function f = d2d(m,n)
%D2D Differential filter

km = 1:m;
fm = (1-2*mod(m:-1:0,2)) .* [1 cumprod((m-km+1)./km)];
fm = interweave(fm,zeros([1 m]));
kn = 1:n;
fn = (1-2*mod(n:-1:0,2)) .* [1 cumprod((n-kn+1)./kn)];
fn = interweave(fn,zeros([1 n]));
f = fn' * fm;