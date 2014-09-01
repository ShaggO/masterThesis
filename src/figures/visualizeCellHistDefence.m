function visualizeCellHistDefence(I,P,H,cells,binC,Jr,type)

J = I{P(3)}(round(P(2)) + (-Jr:Jr),round(P(1)) + (-Jr:Jr));
% [min(J(:)) max(J(:))]
% J(~circleMask(size(J,1))) = max(J(:));
cells = cells + Jr + 1;

switch type
    case 'go'
        x = repmat(cells(:,1)',[numel(binC) 1]);
        y = repmat(cells(:,2)',[numel(binC) 1]);
        u = repmat(cos(binC),[1 size(cells,1)]) .* H;
        v = repmat(sin(binC),[1 size(cells,1)]) .* H;
    case 'si'
        x = repmat(cells(:,1)',[numel(binC) 1]) + ...
            repmat(linspace(-1.2,1.2,numel(binC))',[1 size(cells,1)])
        y = repmat(cells(:,2)',[numel(binC) 1]);
        u = zeros([numel(binC) size(cells,1)]);
        v = -H
end

imagesc(J);
colormap('gray');
axis equal off
hold on
drawCircle(Jr+1,Jr+1,Jr,'c',true,'linewidth',2)
h = quiver(x,y,u,v,2.2,'color',[1 0.4 0.4],'autoscale','off');
plot(cells(:,1),cells(:,2),'y.','MarkerSize',5)
if strcmp(type,'si')
    set(h,'ShowArrowHead','off')
end

end