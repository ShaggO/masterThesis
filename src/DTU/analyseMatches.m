function [ROC, PR] = analyseMatches(match)

T = [0; sort(match.distRatio,'ascend')];
ROC = zeros(numel(T),2);
PR = zeros(numel(T),2);
for i = 1:numel(T)
    t = T(i);
    TP = sum(match.distRatio <= t & match.CorrectMatch == 1);
    FP = sum(match.distRatio <= t & match.CorrectMatch == -1);
    TN = sum(match.distRatio > t & match.CorrectMatch == -1);
    FN = sum(match.distRatio > t & match.CorrectMatch == 1);
    ROC(i,1) = FP / (FP + TN);
    ROC(i,2) = TP / (TP + FN);
    PR(i,1) = FP / (FP + TP);
    PR(i,2) = TP / (TP + FN);
end
% Precision sometimes divides by 0, in this case it should be 0
PR(isnan(PR(:))) = 0;

end

