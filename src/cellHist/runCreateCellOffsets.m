clc, clear all

gridType = 'concentric log-polar';
gridSize = [6 3];
gridRadius = 50;
cellSigma = [50 50];
% cellSigma = [pi/gridSize(1) gridSpacing/2];

[c, cPol, cellSize] = createCellOffsets(gridType,gridSize,gridRadius);

figure
drawCircle(c(:,1),c(:,2),cellSize*cellSigma(1),'b')
hold on
drawCircle(0,0,gridRadius,'k')
axis equal