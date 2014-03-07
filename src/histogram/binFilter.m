function [f,r] = binFilter(type, sigma)
% BINFILTER Create bin filter of given type
% type  Type of bin filter.
% sigma Sigma/width of filter

switch type
    case 'gaussian'
        n = numel(sigma);
        f = @(d) 1/((2*pi)^(n/2)*prod(sigma)) * ...
                exp(-sum((d.^2)./(2*repmat(sigma,[size(d,1) 1])),2));

        r = 6*sigma;

    case 'box'
        f = @(d)boxFilter(sigma,d)
        r = sigma./2;

    case 'triangle'
        f = @(d)triangleFilter(sigma,d)
        r = sigma;
end
end


function v = triangleFilter(sigma,d)
    sigma = repmat(sigma,[size(d,1) 1]);
    v = prod((d <= sigma) .* (1-(d./sigma)),2);
end

function v = boxFilter(sigma,d)
    sigma = repmat(sigma/2,[size(d,1) 1]);
    v = prod((d < sigma) + (d == sigma)/2,2);
end
