clc, clear all

cells = struct();
cells(1).gridType = 'square window';
cells(1).gridSize = 2.5;
cells(1).gridRadius = [134 70];
cells(1).cellSigma = [1];

%cells(2).gridType = 'triangle window';
%cells(2).gridSize = 10;
%cells(2).gridRadius = [100 100];
%cells(2).cellSigma = [1 1];

for i = 1:numel(cells)
    [c, cPol, cellSize] = createCellOffsets(cells(i).gridType,cells(i).gridSize,cells(i).gridRadius,cells(i).cellSigma);

    fig('unit','inches','width',3,'height',5,'fontsize',8);
    plot(c(:,1),c(:,2),'xr','markersize',2);
    hold on
    drawCircle(c(:,1),c(:,2),cellSize*cells(i).gridSize(1),'k',true,'linewidth',0.5)
    rectangle('Position',[-35 -67 70 134],'Curvature',[0 0],'EdgeColor','blue');
    axis equal off;

    filePath = ['../defence/img/pedestrianWindowGrid.pdf'];
    saveTightFigure(gcf,filePath);
    open(filePath);
end;
