function [P, d] = cellWindow(type, r, rCenter)
%CELLWINDOW Computes coordinate offsets of a cell window of some type and
%radius

r = ceil(r);
switch type
    case 'gaussian'        
        [X,Y] = meshgrid(-r(1):r(1),-r(2):r(2));
        mask = sqrt((X/r(1)).^2 + (Y/r(2)).^2) <= 1;
    case 'triangle'
        [X,Y] = meshgrid(-r(1):r(1),-r(2):r(2));
        mask = abs(X/r(1)) + abs(Y/r(2)) <= 1;
    case 'box'
        mask = ':';
    case 'polar'
        assert(r(1)*rCenter(2) == r(2)*rCenter(1), ...
            'r and rCenter must have same relative dimensions.')
        assert(~any(r == 0),'r must be nonzero')
        [X,Y] = meshgrid(0:rCenter(1)+r(1),0:rCenter(2)+r(2));
        if all(rCenter == 0)
            d = 1 * abs(sqrt((X/r(1)).^2 + (Y/r(2)).^2));
        else
            d = rCenter(1)/r(1) * abs(sqrt((X/rCenter(1)).^2 + (Y/rCenter(2)).^2) - 1);
        end
        mask = d <= 1;
        d = d(mask);
        % todo: calculate angles
end

P = [X(mask) Y(mask)];
% P = repmat(P,[1 1 size(centers,1)]) + ...
%     repmat(permute(centers,[3 2 1]),[size(P,1) 1]);

end