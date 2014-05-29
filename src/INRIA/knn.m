function ratio = knn(neighbours,Ltrain,Dtrain,Dtest)
%KNN k-nearest neighbour

% dists = pdist2(Dtest,Dtrain,'euclidean');
% [~, sortIdx] = sort(dists,2);
% save('last_knn')

load('last_knn','Ltrain','sortIdx')

ratio = sum(Ltrain(sortIdx(:,1:neighbours)) == 1,2) / neighbours;

end