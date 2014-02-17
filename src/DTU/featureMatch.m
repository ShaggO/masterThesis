function [matchIdx, dist] = featureMatch(D1, D2)

dists = zeros(size(D1,1),size(D2,1));
for i = 1:size(D1,1)
    for j = 1:size(D2,1)
%         dists(i,j) = featureDist(D1(i,:),D2(j,:));
        dists(i,j) = sum((D2(j,:) - D1(i,:)) .^ 2);
    end
end

[dist, matchIdx] = sort(dists,2);
dist = sqrt(dist(:,1:2));
matchIdx = matchIdx(:,1:2);

end

