function [f,r] = ndFilter(type, sigma)
% NDFILTER Create N-dimensional filter of given type
% type  Type of filter.
% sigma Sigma/width of filter

switch type
    case 'gaussian'
        f = @(d)gaussFilter(sigma,d);
        r = 6*sigma;

    case 'box'
        f = @(d)boxFilter(sigma,d);
        r = sigma./2;

    case 'triangle'
        f = @(d)triangleFilter(sigma,d);
        r = sigma;
end
end


function v = triangleFilter(sigma,d)
    sz = size(d);
    sigma = repmat(2*sigma,[sz(1) 1 sz(3:end)]);
    v = prod((d <= sigma) .* (1-(d./sigma))/2,2);
end

function v = boxFilter(sigma,d)
    sz = size(d);
    sigma = repmat(sigma,[sz(1) 1 sz(3:end)]);
    v = prod(d <= sigma,2)/2;
end

function v = gaussFilter(sigma,d)
%     disp([nums2str(size(d)) '=' num2str(numel(d))])
    sz = size(d);
    v = 1/((2*pi)^(numel(sigma)/2)*prod(sigma)) * ...
            exp(-sum((d.^2)./(2*repmat(sigma.^2,[sz(1) 1 sz(3:end)])),2));
end
