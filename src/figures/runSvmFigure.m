clc, clear all

n = 500;
iters = 1000;
acc1 = zeros(iters,1);
acc2 = zeros(iters,1);

for i = 1:iters
    p1 = normrnd(repmat([-1 -1],n,1),repmat([1 1],n,1),n,2);
    p2 = normrnd(repmat([1 1],n,1),repmat([1 1],n,1),n,2);
    q1 = normrnd(repmat([-1 -1],n,1),repmat([1 1],n,1),n,2);
    q2 = normrnd(repmat([1 1],n,1),repmat([1 1],n,1),n,2);
    
    svm = lineartrain([-ones(n,1); ones(n,1)],[sparse(p1); sparse(p2)]);
    [~,results,~] = linearpredict([-ones(n,1); ones(n,1)],[sparse(q1); sparse(q2)],svm);
    acc1(i) = results(1);
    
    p1 = [p1 normrnd(repmat([0 0],n,1),repmat([1 1],n,1),n,2)];
    p2 = [p2 normrnd(repmat([0 0],n,1),repmat([1 1],n,1),n,2)];
    q1 = [q1 normrnd(repmat([0 0],n,1),repmat([1 1],n,1),n,2)];
    q2 = [q2 normrnd(repmat([0 0],n,1),repmat([1 1],n,1),n,2)];
    
    svm = lineartrain([-ones(n,1); ones(n,1)],[sparse(p1); sparse(p2)]);
    [~,results,~] = linearpredict([-ones(n,1); ones(n,1)],[sparse(q1); sparse(q2)],svm);
    acc2(i) = results(1);
    
%     figure
%     plot(p1(:,1),p1(:,2),'b.')
%     hold on
%     plot(p2(:,1),p2(:,2),'r.')
%     axis([-3 3 -3 3])
%     plot((-10:10)*svm.w(2),-(-10:10)*svm.w(1),'k-','linewidth',2)
end

acc1Mean = mean(acc1)
acc1Std = std(acc1)

acc2Mean = mean(acc2)
acc2Std = std(acc2)