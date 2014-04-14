function P = cellWindow(type, r)
%CELLWINDOW Computes coordinate offsets of a cell window of some type and
%radius

r = ceil(r);
[X,Y] = meshgrid(-r(1):r(1),-r(2):r(2));
switch type
    case 'gaussian'        
        mask = sqrt((X/r(1)).^2 + (Y/r(2)).^2) <= 1;
    case 'triangle'
        mask = abs(X/r(1)) + abs(Y/r(2)) <= 1;
    case 'box'
        mask = ':';
end

P = [X(mask) Y(mask)];

end

