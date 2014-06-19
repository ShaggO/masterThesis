clc, clear all

load('results/inriaStabilityTest','nWindows','name','PRAUC')

x = repmat(nWindows',1,numel(name));
mu = mean(PRAUC,3);
sigma = std(PRAUC,1,3);

figure
hold on
i = 2;
plot(x(:,i),mu(:,i)+sigma(:,i))
plot(x(:,i),mu(:,i)-sigma(:,i))
% semilogy(x,sigma)
% errorbar(x,mu,sigma)
legend(name{i})