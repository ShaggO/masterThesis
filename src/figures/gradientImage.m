function I = gradientImage(theta)

if numel(theta) == 1
    I = goImage(theta);
else
    I = cell(size(theta));
    for i = 1:numel(theta)
        I{i} = goImage(theta(i));
    end
end

end

function I = goImage(t)

v1 = cos(t);
v2 = sin(t);
[x,y] = meshgrid(-1:0.01:1,-1:0.01:1);

I = v1 * x + v2 * y;
I = imnorm(I);

end