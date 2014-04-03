function V = diffStructure(type,LS,sigmaS)
% DIFFSTRUCTURE Compute various calculations on differential structure

V = cell(1,numel(LS));

for i = 1:numel(LS)
    L = LS(i);
    s = sigmaS(i);
    switch type
        case 'Theta'
            V{i} = atan2(L.y,L.x);
        case 'M'
            V{i} = sqrt((L.x).^2 + (L.y).^2);
        case 'S'
            V{i} = 2/pi*atan2(-L.xx-L.yy,sqrt(4*L.xy.^2+(L.xx-L.yy).^2));
        case 'C'
            V{i} = sqrt(L.xx.^2 + 2*L.xy.^2 + L.yy.^2);
        case 'l'
            V{i} = atan(s*(L.xx+L.yy) ./ sqrt(4*(L.x.^2 + L.y.^2) + ...
                s^2 .* ((L.xx-L.yy).^2) + 4*L.xy.^2));
        case 'b'
            V{i} = atan(s* sqrt(((L.xx-L.yy).^2 + 4*L.xy.^2)./...
                (4 * (L.x.^2 + L.y.^2))));
        case 'a'
            V{i} = 1/2 * abs(atan(2 * ((L.x.^2-L.y.^2).*L.xy + ...
                L.x.*L.y.*(L.xx-L.yy)) ./ ((L.x.^2 - L.y.^2).* ...
                (L.xx-L.yy) + 4*L.x.*L.y.*L.xy)));
        case 'j2'
            V{i} = sqrt(s^2 .* (L.x.^2+L.y.^2) + ...
                1/2 * s^4 .* (L.xx.^2 + 2*L.xy.^2 + L.yy.^2));
        case '0'
            V{i} = zeros(size(nthField(L,1)));
        case '1'
            V{i} = ones(size(nthField(L,1)));
        case 'test'
            V{i} = sqrt(1/6 * s.^6 .* (L.xxx.^2 + 3*L.xxy.^2 + 3*L.xyy.^2 + L.yyy.^2));
    end
end