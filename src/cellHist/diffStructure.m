function V = diffStructure(Y,type,o,sigma)
% DIFFSTRUCTURE Compute various calculations on differential structure

if nargin < 3
    o = 0;
end
if nargin < 4
    sigma = 0;
end

switch type
    case 'Theta'
        V = atan2(Y{o+2},Y{o+1});
    case 'M'
        V = sqrt(Y{o+1} .^ 2 + Y{o+2} .^ 2);
    case 'S'
        V = 2/pi*atan2(-Y{o+1}-Y{o+3},sqrt(4*Y{o+2}.^2+(Y{o+1}-Y{o+3}).^2));
    case 'C'
        V = sqrt(Y{o+1}.^2 + 2*Y{o+2}.^2 + Y{o+3}.^2);
    case 'l'
        V = atan(sigma.*(Y{o+3}+Y{o+5}) ./ ...
                sqrt(4*(Y{o+1}.^2 + Y{o+2}.^2) +...
                    sigma.^2 .* ((Y{o+3}-Y{o+5}).^2) + 4*Y{o+4}.^2));
    case 'b'
        V = atan(sigma .* sqrt(((Y{o+3}-Y{o+5}).^2 + 4*Y{o+4}.^2)./...
                (4 * (Y{o+1}.^2 + Y{o+2}.^2))));
    case 'a'
        V = 1/2 * abs(atan(2 * ((Y{o+1}.^2-Y{o+2}.^2).*Y{o+4} + ...
                Y{o+1}.*Y{o+2}.*(Y{o+3}-Y{o+5})) ./ ((Y{o+1}.^2 - Y{o+2}.^2).* ...
                (Y{o+3}-Y{o+5}) + 4*Y{o+1}.*Y{o+2}.*Y{o+4})));
    case 'j2'
        V = sqrt(sigma.^2 .* (Y{o+1}.^2+Y{o+2}.^2) +...
                1/2 * sigma.^4 .* (Y{o+3}.^2 + 2*Y{o+4}.^2 + Y{o+5}.^2));
end
