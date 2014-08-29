function C = circleMask(n)

% Get circular region
c = (n+1)/2;
[X,Y] = meshgrid(1:n);
C = sqrt((X-c) .^ 2 + (Y-c) .^ 2) <= c-1;

end

