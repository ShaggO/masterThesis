function [matchIdx, dists] = featureMatch(D1, D2)

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

%dists = zeros(size(D1,1),size(D2,1));
%for i = 1:size(D1,1)
%    dists(i,:) = sum((D2 - repmat(D1(i,:),[size(D2,1) 1])) .^ 2,2);
%end
% Use built in function (utilizing a mex file)
if size(D1,1) > 0 && size(D2,1) > 0
    dists = pdist2(single(D1),single(D2),'euclidean');
else
    dists = zeros(size(D1,1),size(D2,1),'single');
end

[dists, matchIdx] = sort(dists,2);

switch size(dists,2) % handle special cases of few features
    case 0
        dists = ones(0,2,'single');
        matchIdx = ones(0,2,'single');
    case 1
        dists = [dists dists];
        matchIdx = [matchIdx matchIdx];
    otherwise
        dists = dists(:,1:2);
        matchIdx = matchIdx(:,1:2);
end

%dists = sqrt(dists);

end
