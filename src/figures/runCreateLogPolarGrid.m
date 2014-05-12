cells = struct();
cells(1).gridType = 'concentric polar central';
cells(1).gridSize = [8 2];
cells(1).gridRadius = 50;
cells(1).cellSigma = [50 50];
cells(1).cellSigma = [pi/cells(1).gridSize(1) cells(1).gridRadius];
cells(1).cellFilter = 'polar gaussian';

cells(2).gridType = 'polar central';
cells(2).gridSize = [8 2];
cells(2).gridRadius = 50;
cells(2).cellSigma = [50 50];
cells(2).cellSigma = [pi/cells(2).gridSize(1) cells(2).gridRadius];
cells(2).cellFilter = 'polar gaussian';

cells(3).gridType = 'concentric polar';
cells(3).gridSize = [8 2];
cells(3).gridRadius = 50;
cells(3).cellSigma = [50 50];
cells(3).cellSigma = [pi/cells(3).gridSize(1) cells(3).gridRadius];
cells(3).cellFilter = 'polar gaussian';

cells(4).gridType = 'polar';
cells(4).gridSize = [8 2];
cells(4).gridRadius = 50;
cells(4).cellSigma = [50 50];
cells(4).cellSigma = [pi/cells(4).gridSize(1) cells(4).gridRadius];
cells(4).cellFilter = 'polar gaussian';

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

    drawCircle(0,0,5,'g');
    drawCircle(0,0,cells(i).gridRadius(1),'b',true,'LineStyle','--');
    rectangle('Position',[-51 -51 102 102],'Curvature',[0 0],'EdgeColor','white');
    axis equal off;

    filePath = ['../report/img/gridType_' strrep(cells(i).gridType,' ','_') '_polar_gaussian.pdf'];
    saveTightFigure(gcf,filePath);
    open(filePath);
end;
