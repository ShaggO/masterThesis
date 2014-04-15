function [matchIdx, dist] = featureMatch(D1, D2)

% % Attempted optimization, was not faster
% step = 10;
% dists = zeros(size(D1,1),size(D2,1));
% D1 = permute(D1,[1 3 2]);
% D2 = permute(D2,[3 1 2]);
% for i = 1:step:size(D1,1)
%     idx = i:min(i+step-1,size(D1,1));
%     dists(idx,:) = sum(abs(repmat(D2,[numel(idx) 1]) - ...
%         repmat(D1(idx,1,:),[1 size(D2,2)])),3);
% end

dists = zeros(size(D1,1),size(D2,1));
for i = 1:size(D1,1)
    dists(i,:) = sum(abs(D2 - repmat(D1(i,:),[size(D2,1) 1])),2);
end

[dist, matchIdx] = sort(dists,2);
dist = sqrt(dist(:,1:2));
matchIdx = matchIdx(:,1:2);

end