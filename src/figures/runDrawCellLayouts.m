clc, clear all, close all

%% Square
cellOffsets = createCellOffsets('square',[4 4],[70 70]);
cellType = 'gaussian';
cellSigma = [15 15];
centerType = 'box';
centerSigma = [Inf Inf];

fig('unit','inches','width',20,'height',20,'fontsize',8)
drawCellLayout(cellOffsets,centerType,centerSigma,cellType,cellSigma)
path = '../report/img/cellLayoutSquare.png';
saveTightFigure(gcf,path)
cropPng(path)

%% Polar
cellOffsets = createCellOffsets('polar',[8 2],70);
cellType = 'gaussian';
cellSigma = [15 15];
centerType = 'box';
centerSigma = [Inf Inf];

fig('unit','inches','width',20,'height',20,'fontsize',8)
drawCellLayout(cellOffsets,centerType,centerSigma,cellType,cellSigma)
path = '../report/img/cellLayoutPolar.png';
saveTightFigure(gcf,path)
cropPng(path)

%% Concentric polar
cellOffsets = createCellOffsets('concentric polar',[8 2],70);
cellType = 'gaussian';
cellSigma = [15 15];
centerType = 'box';
centerSigma = [Inf Inf];

fig('unit','inches','width',20,'height',20,'fontsize',8)
drawCellLayout(cellOffsets,centerType,centerSigma,cellType,cellSigma)
path = '../report/img/cellLayoutConcentricPolar.png';
saveTightFigure(gcf,path)
cropPng(path)

%% Square with center filter
cellOffsets = createCellOffsets('square',[4 4],[70 70]);
cellType = 'gaussian';
cellSigma = [15 15];
centerType = 'gaussian';
centerSigma = [140 140];

fig('unit','inches','width',20,'height',20,'fontsize',8)
drawCellLayout(cellOffsets,centerType,centerSigma,cellType,cellSigma)
path = '../report/img/cellLayoutSquareCenter.png';
saveTightFigure(gcf,path)
cropPng(path)

%% Polar with center filter
cellOffsets = createCellOffsets('polar',[8 2],70);
cellType = 'gaussian';
cellSigma = [15 15];
centerType = 'gaussian';
centerSigma = [175 175];

fig('unit','inches','width',20,'height',20,'fontsize',8)
drawCellLayout(cellOffsets,centerType,centerSigma,cellType,cellSigma)
path = '../report/img/cellLayoutPolarCenter.png';
saveTightFigure(gcf,path)
cropPng(path)

%% Concentric polar with center filter
cellOffsets = createCellOffsets('concentric polar',[8 2],70);
cellType = 'gaussian';
cellSigma = [15 15];
centerType = 'gaussian';
centerSigma = [175 175];

fig('unit','inches','width',20,'height',20,'fontsize',8)
drawCellLayout(cellOffsets,centerType,centerSigma,cellType,cellSigma)
path = '../report/img/cellLayoutConcentricPolarCenter.png';
saveTightFigure(gcf,path)
cropPng(path)