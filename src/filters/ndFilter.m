function [f,r] = ndFilter(type, sigma)
% NDFILTER Create N-dimensional filter of given type
% type  Type of filter.
% sigma Sigma/width of filter

switch type
    case 'gaussian'
        f = @(d)gaussFilter(sigma,d);
        r = 3*sigma;
    case 'box'
        f = @(d)boxFilter(sigma,d);
        r = sigma;
    case 'triangle'
        f = @(d)triangleFilter(sigma,d);
        r = 2*sigma;
end
end


function v = triangleFilter(sigma,d)
    sz = size(d);
    sigma = repmat(sigma,[sz(1) 1 sz(3:end)]);
    v = prod((abs(d) <= 2*sigma) .* (1-(abs(d)./(2*sigma)))./(2*sigma),2);
end

function v = boxFilter(sigma,d)
    sz = size(d);
    sigma = repmat(sigma,[sz(1) 1 sz(3:end)]);
    v = prod((abs(d) <= sigma) .* 1./(2*sigma),2);
end

function v = gaussFilter(sigma,d)
%     disp([nums2str(size(d)) '=' num2str(numel(d))])
    sz = size(d);
    v = 1/((2*pi)^(numel(sigma)/2)*prod(sigma)) * ...
            exp(-sum((d.^2)./(2*repmat(sigma.^2,[sz(1) 1 sz(3:end)])),2));
end
