cells = struct();
cells(1).gridType = 'polar central';
cells(1).gridSize = [12 2];
cells(1).gridRadius = 13.5;
cells(1).cellSigma = [pi/cells(1).gridSize(1) cells(1).gridRadius];
cells(1).cellFilter = 'polar gaussian';

theta = linspace(0,2*pi,720)';
for i = 1:numel(cells)
    [c, cPol, cellSize] = createCellOffsets(cells(i).gridType,cells(i).gridSize,cells(i).gridRadius);

    fig('unit','inches','width',5,'height',5,'fontsize',8);
    plot(c(:,1),c(:,2),'xr');
    hold on

    for j = 1:size(cPol,1)
        if cPol(j,2) == 0
            thetaX = theta;
            rhoX = repmat(cellSize(j)*cells(i).cellSigma(2),[numel(theta) 1]);
        else
            % Compute gaussians circles in polar coordinates
            thetaX = repmat(cells(i).cellSigma(1),[numel(theta) 1])...
            .* cos(theta) + repmat(cPol(j,1),[numel(theta) 1]);

            rhoX = repmat(cellSize(j)*cells(i).cellSigma(2),[numel(theta) 1]) .* sin(theta) + repmat(cPol(j,2),[numel(theta) 1]);
        end
        % Transform polar coordinates to 
        [X,Y] = pol2cart(thetaX,rhoX);
        plot(X,Y,'-k');
    end

    drawCircle(0,0,1,'g');
    drawCircle(0,0,cells(i).gridRadius(1),'b',true,'LineStyle','--');
    rectangle('Position',[-14 -14 28 28],'Curvature',[0 0],'EdgeColor','white');
    axis equal off;

    filePath = ['../defence/img/gridExample.pdf'];
    saveTightFigure(gcf,filePath);
    open(filePath);
end;
