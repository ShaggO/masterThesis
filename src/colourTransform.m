function J = colourTransform(I, type)
%COLOURTRANSFORM Various colour transforms, assumes single/double precision
%RGB image input between 0 and 1

switch type
    case 'gray'
        J = rgb2gray(I);
    case 'opponent'
        M = [[1 -1 0]/sqrt(2); [1 1 -2]/sqrt(6); [1 1 1]/sqrt(3)];
        J = pixelTransform(I,@(x) M*x);
    case 'gaussian opponent'
        M = [0.06 0.63 0.27; 0.30 0.04 -0.35; 0.34 -0.60 0.17];
        J = pixelTransform(I,@(x) M*x);
    case 'c-colour'
        I = colourTransform(I,'gaussian opponent');
        % create filters
        sigma = 2;
        hsize = 6*sigma;
        Gx = dGauss2d(1,0,hsize,sigma);
        Gy = dGauss2d(0,1,hsize,sigma);
        % derive E channels
        E0 = I(:,:,1) + eps;
        E0x = imfilter(E0,Gx,'replicate','conv');
        E0y = imfilter(E0,Gy,'replicate','conv');
        E1 = I(:,:,2);
        E1x = imfilter(E1,Gx,'replicate','conv');
        E1y = imfilter(E1,Gy,'replicate','conv');
        E2 = I(:,:,3);
        E2x = imfilter(E2,Gx,'replicate','conv');
        E2y = imfilter(E2,Gy,'replicate','conv');
        % compute W, C1, C2
        J(:,:,1) = sqrt(E0x .^ 2 + E0y .^ 2) ./ E0;
        J(:,:,2) = sqrt(((E1x.*E0 - E1.*E0x) ./ (E0.^2)) .^ 2 + ...
            ((E1y.*E0 - E1.*E0y) ./ (E0.^2)) .^ 2);
        J(:,:,3) = sqrt(((E2x.*E0 - E2.*E0x) ./ (E0.^2)) .^ 2 + ...
            ((E2y.*E0 - E2.*E0y) ./ (E0.^2)) .^ 2);
    case 'xyz'
        ltMask = I <= 0.04045;
        gtMask = ~ltMask;
        I(ltMask) = I(ltMask) / 12.92;
        I(gtMask) = ((I(gtMask) + 0.055) / 1.055) .^ 2.4;
        M = [0.4124, 0.3576, 0.1805;
             0.2126, 0.7152, 0.0722;
             0.0193, 0.1192, 0.9502];
        J = pixelTransform(I,@(x) M*x);
    case 'perceptual'
        I = colourTransform(I,'xyz');
        B = [9.465229*10^-1,  2.946927*10^-1, -1.313419*10^-1;
            -1.179179*10^-1,  9.929960*10^-1,  7.371554*10^-3;
             9.230461*10^-2, -4.645794*10^-2,  9.946464*10^-1];
        A = [2.707439*10^1, -2.280783*10^1, -1.806681;
            -5.646736,      -7.722125,       1.286503*10^1;
            -4.163133,      -4.579428,      -4.576049];
        J = pixelTransform(I,@(x) A*log(B*x+eps));
end
end

function J = pixelTransform(I,pixelFunc)
    % Performs a given function (e.g. a 3x3 matrix multiplication) on each
    % pixel
    J = reshape((pixelFunc(reshape(I,numel(I)/3,3)'))',size(I));
end