function D = getKJetDescriptors(I,F,k,sigma,domain)
% GETKJETDESCRIPTORS Compute k-jet descriptors

p = inputParser;
expectedDomains = {'auto','spatial','fourier'};
addRequired(p,'I');
addRequired(p,'F', @(x) size(x,2) == 2);
addRequired(p,'k');
addRequired(p,'sigma');
addOptional(p,'domain',expectedDomains{1},...
    @(x) any(validatestring(x,expectedDomains)));
parse(p,I,F,k,sigma,varargin{:});
domain = p.Results.domain;

if strcmp(domain,'auto')
    if sigma > 62
        domain = 'fourier';
    else
        domain = 'spatial';
    end
end

% Compute k-Jets, whitening and L2 normalization
BCov = brownianCovariance(k,sigma);
D = normalize(localKJet(I,F,k,sigma,domain) * BCov,2)

end
