clc, clear all;
sigma = 0.5;
fHandle = @(d) 1/(2*pi*sigma^2) * exp(-(d).^2/(2*sigma^2));

%fHandle = @(d) d <= repmat(0.25,[1 numel(x)])


x = (-5:0.1:4.9)';
y = ones(numel(x),1);
binC = createBinCenters(-5,5,10,'offset',0.5);

h = create1Dhist(x,y,binC,fHandle,10);
h = h ./ sum(h);

figure;
plot([binC binC]',[h zeros(size(binC))]','-b','LineWidth',2);
bPadding = (binC(end) - binC(1)) / 20;
axis([binC(1)-bPadding binC(end)+bPadding 0 1]);

binC2 = createBinCenters(-5,5,10,'endpoints',true);
h2 = create1Dhist(x,y,binC2,fHandle);
h2 = h2 ./ sum(h2);

figure;
plot([binC2';binC2'],[h2';zeros(size(binC2'))],'-b','LineWidth',2);
bPadding2 = (binC2(end) - binC2(1)) / 20;
axis([binC2(1)-bPadding2 binC2(end)+bPadding2 0 1]);

[X1,X2] = ndgrid(-1:0.1:0.9,-1:0.1:0.9);
X = [X1(:) X2(:)];
Y = ones(size(X,1),1);

[binC3, dimensions] = createBinCenters([-1,-1],[1,1],[10 10]);

fHandle3 = @(d) 1/(2*pi*sigma^2) * exp(-(sqrt(sum(d.^2,2))).^2/(2*sigma^2));

h3 = create1Dhist(X,Y,binC3,fHandle3,[2,2]);
h3 = h3 ./ sum(h3);
h3_ = reshape(h3,dimensions);
X_ = reshape(binC3(:,2),dimensions);
Y_ = reshape(binC3(:,1),dimensions);

figure;
plot3([binC3(:,1) binC3(:,1)]',...
      [binC3(:,2) binC3(:,2)]',...
      [h3 zeros(size(binC3,1),1)]',...
      '-b','LineWidth',2);
hold on;
surfc(X_, Y_, h3_);
