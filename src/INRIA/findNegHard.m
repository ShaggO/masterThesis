function idxHard = findNegHard(prob,n)

% % debugging
% if nargin == 0
%     m = 10^4;
%     prob = repmat({rand(m,1)},2000,1);
%     n = 10^6;
% end

Prob = cell2mat(prob);
[~,idxProb] = sort(Prob,'descend');
idxProb = idxProb(1:n);
offset = cumsum(cellfun(@numel,prob));
offset = [0; offset(:)];

idxHard = cell(size(prob));
for i = 1:numel(prob)
    idxHard{i} = idxProb(idxProb > offset(i) & idxProb <= offset(i+1)) - offset(i);
end

end