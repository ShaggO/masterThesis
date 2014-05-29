function I = shapeIndexImage(s)

if numel(s) == 1
    I = siImage(s);
else
    I = cell(size(s));
    for i = 1:numel(s)
        I{i} = siImage(s(i));
    end
end

end

function I = siImage(s)

theta = pi/2*s - pi/4;
k1 = cos(theta);
k2 = sin(theta);
[x,y] = meshgrid(-1:0.01:1,-1:0.01:1);

I = k1 * x.^2 + k2 * y.^2;
I = imnorm(I);

end