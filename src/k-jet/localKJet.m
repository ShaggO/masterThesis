function D = localKJet(I,F,k,sigma,domain)
% Computes the local k-jet at given positions in an image

d = kJetCoeffs(k);
D = zeros(size(F,1),size(d,1));

% Perform k-Jet computation in either the frequency or spatial domain
switch domain
    case 'fourier'
        hsize = size(I)*2-1;
        Ifft = fft2(I,hsize(1),hsize(2));

        for i = 1:size(d,1)
            Filter = ifftshift(dGaussFourier2d(d(i,1),d(i,2),hsize,sigma),hsize(1));
            Ibig = real(ifft2(Ifft .* Filter,hsize(1),hsize(2)));
            I2 = Ibig(1:size(I,1),1:size(I,2));
            D(:,i) = interp2(I2,F(:,1),F(:,2),'bilinear');
        end
    case 'spatial'
        hsize = ceil(6*sigma);

        for i = 1:size(d,1)
            Filter = dGauss2d(d(i,1),d(i,2),hsize,sigma);
            I2 = imfilter(I,Filter,'conv','replicate');
%             D(:,i) = I2(sub2ind(size(I),F(:,2),F(:,1)));
            D(:,i) = interp2(I2,F(:,1),F(:,2),'bilinear');
        end
end
end
