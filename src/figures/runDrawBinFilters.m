clc, clear all

%% Periodic

binSigma = 1/2;
left = -1;
right = 1;
binCount = 4;
binCArgin = {};
period = 1;
colour = {'k-','b-','m-','r-'};
options = {'-r300'};

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('gaussian',binSigma,left,right,binCount,binCArgin,period,colour)
export_fig('../report/img/binFilterGaussianPeriodic.pdf',options{:})

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('box',binSigma,left,right,binCount,binCArgin,period,colour)
export_fig('../report/img/binFilterBoxPeriodic.pdf',options{:})

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('triangle',binSigma,left,right,binCount,binCArgin,period,colour)
export_fig('../report/img/binFilterTrianglePeriodic.pdf',options{:})

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
export_fig('../report/img/binFilterGaussianRenorm.pdf',options{:})

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('box',binSigma,left,right,binCount,binCArgin,period,colour)
export_fig('../report/img/binFilterBoxRenorm.pdf',options{:})

fig('unit','inches','width',6,'height',4,'fontsize',8)
drawBinFilters('triangle',binSigma,left,right,binCount,binCArgin,period,colour)
export_fig('../report/img/binFilterTriangleRenorm.pdf',options{:})
