function [] = drawCircle(x,y,r,color)

if nargin < 4
    color = 'k';
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
for i = 1:numel(x)
    rectangle('position',positions(i,:),'curvature',[1 1],'edgecolor',color)
end

% Step through the angles manually
%theta = (0:2*pi/360:2*pi)';
%x = repmat(r,[numel(theta) 1]) .* repmat(cos(theta),[1 size(x,2)]) + repmat(x,[numel(theta) 1]);
%y = repmat(r,[numel(theta) 1]) .* repmat(sin(theta),[1 size(x,2)]) + repmat(y,[numel(theta) 1]);
%plot(x,y,['-' color]);

end
