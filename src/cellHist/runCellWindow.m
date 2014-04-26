clc, clear all

% [P, minP, maxP, Ppol] = cellWindow('polar gaussian',3*[pi/4 5; pi/4 5],[0 10; 0 20]);
% 
% fCell = ndFilter('gaussian',[pi/4 5]);
% 
% points = abs(Ppol.data{1} - repmat([0 10],size(Ppol.data{1},1),1));
% points(:,1) = min(points(:,1),2*pi - points(:,1));
% wCell{1} = fCell(points);
% 
% points = abs(Ppol.data{2} - repmat([0 20],size(Ppol.data{2},1),1));
% points(:,1) = min(points(:,1),2*pi - points(:,1));
% wCell{2} = fCell(points);
% 
% figure
% axis([-30 30 -30 30 0 max(wCell{1}(:))])
% hold on
% plot3(P.data{1}(:,1), P.data{1}(:,2), wCell{1}(:), 'rx')
% plot3(P.data{2}(:,1), P.data{2}(:,2), wCell{2}(:), 'bx')

[cen,cenPol] = createCellOffsets('polar',[4 1],5)
% n = 16;
% cen = cen(n,:)
% cenPol = cenPol(n,:)
rCell = [3/4*pi 15];
fCell = ndFilter('gaussian',rCell);
rCell = repmat(rCell,[size(cen,1) 1]);
[win,minWin,maxWin,winPol] = cellWindow('polar gaussian',rCell,cenPol);

data = win.data{1}(:,:,1);
dataPol = winPol.data{1}(:,:,1);
points = abs(dataPol - repmat(cenPol(1,:),size(dataPol,1),1));
points(:,1,1) = min(points(:,1),2*pi - points(:,1,1));
% wCell{1} = fCell(points);
wCell{1} = polarDiffFunction(fCell,dataPol,repmat(cenPol(1,:),size(dataPol,1),1),1);

win.sizes

figure
% axis([-30 30 -30 30 0 max(wCell{1}(:))])
% hold on
plot3(data(:,1), data(:,2), wCell{1}(:), 'rx')