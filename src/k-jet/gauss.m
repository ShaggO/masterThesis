function G = gauss(hsize, sigma, diff)

x = -(hsize-1)/2:(hsize-1)/2;
y = x';
[X,Y] = meshgrid(x,y);

switch diff
    case ''
        G = 1/(2*pi*sigma^2) * exp(-(X.^2+Y.^2)/(2*sigma^2));
    case 'x'
        G = -(X.*exp(-(X.^2 + Y.^2)/(2*sigma^2)))/(2*pi*sigma^4);
    case 'y'
        G = -(Y.*exp(-(X.^2 + Y.^2)/(2*sigma^2)))/(2*pi*sigma^4);
    case 'xx'
        G = -(exp(-(X.^2 + Y.^2)/(2*sigma^2)).*(sigma^2 - X.^2))/(2*pi*sigma^6);
    case 'xy'
        G = (X.*Y.*exp(-(X.^2 + Y.^2)/(2*sigma^2)))/(2*pi*sigma^6);
    case 'yy'
        G = -(exp(-(X.^2 + Y.^2)/(2*sigma^2)).*(sigma^2 - Y.^2))/(2*pi*sigma^6);
    case 'xxx'
        G = (X.*exp(-(X.^2 + Y.^2)/(2*sigma^2)).*(3*sigma^2 - X.^2))/(2*pi*sigma^8);
    case 'xxy'
        G = (Y.*exp(-(X.^2 + Y.^2)/(2*sigma^2)).*(sigma^2 - X.^2))/(2*pi*sigma^8);
    case 'xyy'
        G = (X.*exp(-(X.^2 + Y.^2)/(2*sigma^2)).*(sigma^2 - Y.^2))/(2*pi*sigma^8);
    case 'yyy'
        G = (Y.*exp(-(X.^2 + Y.^2)/(2*sigma^2)).*(3*sigma^2 - Y.^2))/(2*pi*sigma^8);
end

