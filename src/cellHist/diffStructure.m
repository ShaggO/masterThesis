function V = diffStructure(type,L,sigma)
% DIFFSTRUCTURE Compute various calculations on differential structure

if nargin < 3
    sigma = 0;
end

switch type
    case 'Theta'
        V = atan2(L.y,L.x);
    case 'M'
        V = sqrt(L.x.^2 + L.y.^2);
    case 'S'
        V = 2/pi*atan2(-L.xx-L.yy,sqrt(4*L.xy.^2+(L.xx-L.yy).^2));
    case 'C'
        V = sqrt(L.xx.^2 + 2*L.xy.^2 + L.yy.^2);
    case 'l'
        V = atan(sigma.*(L.xx+L.yy) ./ sqrt(4*(L.x.^2 + L.y.^2) + ...
                    sigma.^2 .* ((L.xx-L.yy).^2) + 4*L.xy.^2));
    case 'b'
        V = atan(sigma .* sqrt(((L.xx-L.yy).^2 + 4*L.xy.^2)./...
                (4 * (L.x.^2 + L.y.^2))));
    case 'a'
        V = 1/2 * abs(atan(2 * ((L.x.^2-L.y.^2).*L.xy + ...
                L.x.*L.y.*(L.xx-L.yy)) ./ ((L.x.^2 - L.y.^2).* ...
                (L.xx-L.yy) + 4*L.x.*L.y.*L.xy)));
    case 'j2'
        V = sqrt(sigma.^2 .* (L.x.^2+L.y.^2) + ...
                1/2 * sigma.^4 .* (L.xx.^2 + 2*L.xy.^2 + L.yy.^2));
    case 'test'
        V = sqrt(1/6 * sigma.^6 .* (L.xxx.^2 + 3*L.xxy.^2 + 3*L.xyy.^2 + L.yyy.^2));
end
