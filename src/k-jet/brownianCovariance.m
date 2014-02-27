function C = brownianCovariance(k,sigma)
% Covariance of Brownian images mapped into k-jet space
% See Kim's Ph.D. p. 126

beta = 1;

d = kJetCoeffs(k);

C = zeros(size(d,1));
for i = 1:size(d,1)
    for j = 1:size(d,1)
        n = d(i,1)+d(j,1);
        m = d(i,2)+d(j,2);
        if (mod(n,2) == 0) && (mod(m,2) == 0) 
            C(i,j) = (-1)^((n+m)/2+d(j,1)+d(j,2)) * ...
                beta^2/(2*pi*sigma^(n+m)) * ...
                factorial(n)*factorial(m)/(2^(n+m)*(n+m)*factorial(n/2)*factorial(m/2));
        end
    end
end

end

