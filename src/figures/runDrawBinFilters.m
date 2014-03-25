clc, clear all

binSigma = 1/2;
left = -1;
right = 1;
binCount = 4;
binCArgin = {};
period = 0;
colour = {'k-','b-','m-','r-'};

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('gaussian',binSigma,left,right,binCount,binCArgin,period,colour)
saveTightFigure(gcf,'../report/img/binFilterGaussian.pdf')

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('box',binSigma,left,right,binCount,binCArgin,period,colour)
saveTightFigure(gcf,'../report/img/binFilterBox.pdf')

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('triangle',binSigma,left,right,binCount,binCArgin,period,colour)
saveTightFigure(gcf,'../report/img/binFilterTriangle.pdf')