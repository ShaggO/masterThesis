function [X,D] = getKJetDescriptors(I,F,k,sigma,domain)
% GETKJETDESCRIPTORS Compute k-jet descriptors

% assert(size(F,1) > 500 && size(F,1) < 2000, ...
%     ['Error: ' num2str(size(F,1)) ' features detected but not within bounds (1000 - 2000).'])

if strcmp(domain,'auto')
    if sigma > 62
        domain = 'fourier';
    else
        domain = 'spatial';
    end
end

X = F(:,1:2);

% Compute scaled covariance matrix (whitening factors)
BCov = brownianCovariance(k,sigma);
[V,lambda] = eig(BCov);
lambda = diag(1 ./ sqrt(diag(lambda)));
V = V * lambda;

% Compute k-Jets, whitening and L2 normalization
D = localKJet(rgb2gray(im2double(I)),F,k,sigma,domain);
D = D * V;
D = normalize(D,2);

end
