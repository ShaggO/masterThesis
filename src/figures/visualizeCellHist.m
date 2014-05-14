function visualizeCellHist(I,P,H,cells,binC,r)

Jr = ceil(max(abs(cells(:)))) + r;
J = I{P(3)}(round(P(2)) + (-Jr:Jr),round(P(1)) + (-Jr:Jr));
cells = cells + Jr + 1;
x = repmat(cells(:,1)',[numel(binC) 1]);
y = repmat(cells(:,2)',[numel(binC) 1]);
u = repmat(cos(binC),[1 size(cells,1)]) .* H;
v = repmat(sin(binC),[1 size(cells,1)]) .* H;

%imshow(J)
imagesc(J);
colormap('gray');
axis equal off
hold on
% plot(cells(:,1),cells(:,2),'rx')
quiver(x,y,u,v,'r')
plot(x,y,'y.','MarkerSize',5)

end