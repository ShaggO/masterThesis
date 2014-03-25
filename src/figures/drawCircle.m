function [] = drawCircle(x,y,r,color)

if nargin < 4
    color = 'k';
end

if size(x,1) > size(x,2)
    x = x';
end
if size(y,1) > size(y,2)
    y = y';
end
if size(r,1) > size(r,2)
    r = r';
end

% Step through the angles
theta = (0:2*pi/360:2*pi)';
x = repmat(r,[numel(theta) 1]) .* repmat(cos(theta),[1 size(x,2)]) + repmat(x,[numel(theta) 1]);
y = repmat(r,[numel(theta) 1]) .* repmat(sin(theta),[1 size(x,2)]) + repmat(y,[numel(theta) 1]);
plot(x,y,['-' color]);

end