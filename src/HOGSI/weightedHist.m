function h = weightedHist(v, w, binranges)
% Histogram with weights

bins = numel(binranges)-1;
h = zeros(1,bins);
for i = 1:numel(v)
    binIdx = find(v(i) >= binranges(1:end-1) & ...
        v(i) <= binranges(end),1,'last');
    if ~isempty(binIdx)
        h(binIdx) = h(binIdx) + w(i);
    end
end

end

