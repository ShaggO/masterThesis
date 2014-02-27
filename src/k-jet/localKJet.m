function J = localKJet(I,F,k,sigma,varargin)
% Computes the local k-jet at given positions in an image

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

d = kJetCoeffs(k);
J = zeros(size(F,1),size(d,1));

% Perform k-Jet computation in either the frequency or spatial domain
switch domain
    case 'fourier'
        hsize = size(I)*2-1;
        Ifft = fft2(I,hsize(1),hsize(2));

        for i = 1:size(d,1)
            Filter = ifftshift(dGaussFourier2d(d(i,1),d(i,2),hsize,sigma),hsize(1));
            Ibig = real(ifft2(Ifft .* Filter,hsize(1),hsize(2)));
            I2 = Ibig(1:size(I,1),1:size(I,2));
            J(:,i) = I2(sub2ind(size(I),F(:,1),F(:,2)));
        end
    case 'spatial'
        hsize = ceil(6*sigma);

        for i = 1:size(d,1)
            Filter = dGauss2d(d(i,1),d(i,2),hsize,sigma);
            I2 = imfilter(I,Filter,'conv','replicate');
            J(:,i) = I2(sub2ind(size(I),F(:,1),F(:,2)));
        end
