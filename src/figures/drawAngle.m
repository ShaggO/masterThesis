function drawAngle(x,y,t1,t2,r,varargin)

if nargin < 5
    r = 1/4;
end

if abs(abs(t2-t1) - pi/2) < 1/10^5
    xi = [r sqrt(2)*r r] .* cos([t1 (t1+t2)/2 t2]) + x;
    yi = [r sqrt(2)*r r] .* sin([t1 (t1+t2)/2 t2]) + y;
    plot(xi,yi,varargin{:});
else
    % Step through the angles manually
    theta = linspace(t1,t2,100);
    xi = r * cos(theta) + x;
    yi = r * sin(theta) + y;
    plot(xi,yi,varargin{:});
end

end