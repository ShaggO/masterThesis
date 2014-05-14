function colorMapImshow(I,map,range,border)
% COLORMAPIMSHOW Show image with colormap and colorbar allowing white areas (border)
if nargin < 3 || isempty(range)
    range = [min(I(:)) max(I(:))];
end
if nargin < 4
    border = false(size(I,1),size(I,2));
end
indices = max(ceil((I - range(1)) / (range(2) - range(1)) * size(map,1)),1);
Irgb = ind2rgb(indices,map);
h = imshow(I,range);
hold on;
colormap(map);
b = colorbar;
cbfreeze(b,'on');
delete(h);
colormap(gray(size(map,1)));
set(gcf,'color','white');
set(gca,'color','white');
Irgb(repmat(border,[1 1 3])) = 1;
imshow(Irgb);
end
