function [] = drawSquare(x,y,r,color,native,varargin)

if nargin < 4
    color = 'k';
end

if nargin < 5
    native = true;
end
if nargin < 6
    varargin = {};
end

if size(x,2) > 1
    x = x';
end
if size(y,2) > 1
    y = y';
end
if numel(r) == 1
    r = repmat(r,numel(x),1);
elseif size(r,1) < size(r,2)
    r = r';
end
positions = [x-r y-r 2*r 2*r];

% Use native implementation
if native
    for i = 1:numel(x)
        hold on;
        rectangle('position',positions(i,:),'edgecolor',color,varargin{:});
    end
else
    % Step through the angles manually
    theta = (0:2*pi/360:2*pi)';
    for i = 1:numel(x)
        xi = repmat(r(i),[numel(theta) 1]) .* repmat(cos(theta),[1 size(x,2)]) + repmat(x(i),[numel(theta) 1]);
        yi = repmat(r(i),[numel(theta) 1]) .* repmat(sin(theta),[1 size(x,2)]) + repmat(y(i),[numel(theta) 1]);
        plot(xi,yi,['-' color],varargin{:});
    end
end
