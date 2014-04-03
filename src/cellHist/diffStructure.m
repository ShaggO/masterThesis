function V = diffStructure(type,L,sigma)
% DIFFSTRUCTURE Compute various calculations on differential structure

if nargin < 3
    sigma = 0;
end

V = cell(1,numel(L));

for i = 1:numel(L)
switch type
    case 'Theta'
        V{i} = atan2(L(i).y,L(i).x);
    case 'M'
        V{i} = sqrt((L(i).x).^2 + (L(i).y).^2);
    case 'S'
        V{i} = 2/pi*atan2(-L(i).xx-L(i).yy,sqrt(4*L(i).xy.^2+(L(i).xx-L(i).yy).^2));
    case 'C'
        V{i} = sqrt(L(i).xx.^2 + 2*L(i).xy.^2 + L(i).yy.^2);
    case 'l'
        V{i} = atan(sigma(i)*(L(i).xx+L(i).yy) ./ sqrt(4*(L(i).x.^2 + L(i).y.^2) + ...
                    sigma(i)^2 .* ((L(i).xx-L(i).yy).^2) + 4*L(i).xy.^2));
    case 'b'
        V{i} = atan(sigma(i)* sqrt(((L(i).xx-L(i).yy).^2 + 4*L(i).xy.^2)./...
                (4 * (L(i).x.^2 + L(i).y.^2))));
    case 'a'
        V{i} = 1/2 * abs(atan(2 * ((L(i).x.^2-L(i).y.^2).*L(i).xy + ...
                L(i).x.*L(i).y.*(L(i).xx-L(i).yy)) ./ ((L(i).x.^2 - L(i).y.^2).* ...
                (L(i).xx-L(i).yy) + 4*L(i).x.*L(i).y.*L(i).xy)));
    case 'j2'
        V{i} = sqrt(sigma(i)^2 .* (L(i).x.^2+L(i).y.^2) + ...
                1/2 * sigma(i)^4 .* (L(i).xx.^2 + 2*L(i).xy.^2 + L(i).yy.^2));
end

end
