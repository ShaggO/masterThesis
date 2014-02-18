function [] = drawCircle(x,y,r,color)

if nargin < 4
    color = 'k'
end

rectangle('position',[x-r y-r 2*r 2*r],'curvature',[1 1],'edgecolor',color)

end

