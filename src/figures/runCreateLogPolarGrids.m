clc, clear all

cells = struct();
cells(1).gridType = 'concentric log-polar';
cells(1).gridSize = [8 2];
cells(1).gridRadius = 50;
cells(1).cellSigma = [50 50];

cells(2).gridType = 'log-polar';
cells(2).gridSize = [8 2];
cells(2).gridRadius = 50;
cells(2).cellSigma = [50 50];
% cellSigma = [pi/gridSize(1) gridSpacing/2];

for i = 1:numel(cells)
    [c, cPol, cellSize] = createCellOffsets(cells(i).gridType,cells(i).gridSize,cells(i).gridRadius);

    fig('unit','inches','width',5,'height',5,'fontsize',8);
    plot(c(:,1),c(:,2),'xr');
    hold on
    drawCircle(c(:,1),c(:,2),cellSize*cells(i).cellSigma(1),'k',true)
    rectangle('Position',[-51 -51 102 102],'Curvature',[0 0],'EdgeColor','white');
    axis equal off;

    drawCircle(0,0,5,'g');
    drawCircle(0,0,cells(i).gridRadius(1),'b',true,'LineStyle','--');

    filePath = ['../report/img/gridType_' strrep(cells(i).gridType,' ','_') '.pdf'];
    saveTightFigure(gcf,filePath);
    open(filePath);
end;
