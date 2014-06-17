clc, clear all

%% Periodic

binSigma = 1/2;
left = -1;
right = 1;
binCount = 4;
binCArgin = {};
period = 1;
colour = {'k-','b-','m-','r-'};

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('gaussian',binSigma,left,right,binCount,binCArgin,period,colour)
export_fig('../report/img/binFilterGaussianPeriodic.pdf','-r600')

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('box',binSigma,left,right,binCount,binCArgin,period,colour)
export_fig('../report/img/binFilterBoxPeriodic.pdf','-r600')

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('triangle',binSigma,left,right,binCount,binCArgin,period,colour)
export_fig('../report/img/binFilterTrianglePeriodic.pdf','-r600')

%% Renormalized non-periodic

binSigma = 1/2;
left = -1;
right = 1;
binCount = 4;
binCArgin = {};
period = 0;
colour = {'k-','b-','m-','r-'};

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('gaussian',binSigma,left,right,binCount,binCArgin,period,colour)
export_fig('../report/img/binFilterGaussianRenorm.pdf','-r600')

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('box',binSigma,left,right,binCount,binCArgin,period,colour)
export_fig('../report/img/binFilterBoxRenorm.pdf','-r600')

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('triangle',binSigma,left,right,binCount,binCArgin,period,colour)
export_fig('../report/img/binFilterTriangleRenorm.pdf','-r600')