clc, clear all

cells = struct();
cells(1).gridType = 'square window';
cells(1).gridSize = 10;
cells(1).gridRadius = [120 120];
cells(1).cellSigma = [1 1];

cells(2).gridType = 'triangle window';
cells(2).gridSize = 10;
cells(2).gridRadius = [100 100];
cells(2).cellSigma = [1 1];

for i = 1:numel(cells)
    [c, cPol, cellSize] = createCellOffsets(cells(i).gridType,cells(i).gridSize,cells(i).gridRadius,cells(i).cellSigma);

    fig('unit','inches','width',5,'height',5,'fontsize',8);
    plot(c(:,1),c(:,2),'xr');
    hold on
    drawCircle(c(:,1),c(:,2),cellSize*cells(i).gridSize(1),'k',true)
    rectangle('Position',[-51 -51 102 102],'Curvature',[0 0],'EdgeColor','white');
    axis equal off;

    filePath = ['../report/img/gridType_' strrep(cells(i).gridType,' ','_') '.pdf'];
    saveTightFigure(gcf,filePath);
    open(filePath);
end;
