clc, clear all

n = 500;
p1 = normrnd(repmat([-1 -1],n,1),repmat([1 1],n,1),n,2);
p2 = normrnd(repmat([1 1],n,1),repmat([1 1],n,1),n,2);

svm = lineartrain([-ones(n,1); ones(n,1)],[sparse(p1); sparse(p2)]);

figure
plot(p1(:,1),p1(:,2),'b.')
hold on
plot(p2(:,1),p2(:,2),'r.')
axis([-3 3 -3 3])
plot((-10:10)*svm.w(2),-(-10:10)*svm.w(1),'k-','linewidth',2)