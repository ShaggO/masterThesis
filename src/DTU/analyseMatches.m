function [ROC, PR] = analyseMatches(match)

T = [0; sort(match.distRatio,'ascend')];
True = match.CorrectMatch == 1;
False = match.CorrectMatch == -1;
ROC = zeros(numel(T),2);
PR = zeros(numel(T),2);
for i = 1:numel(T)
%     t = T(i);
%     Pos = match.distRatio <= t;
%     Neg = match.distRatio > t;
%     TP = sum(True & Pos);
%     FP = sum(False & Pos);
%     TN = sum(False & Neg);
%     FN = sum(True & Neg);
%     ROC(i,1) = FP / (FP + TN);
%     ROC(i,2) = TP / (TP + FN);
%     PR(i,1) = FP / (FP + TP);
%     PR(i,2) = TP / (TP + FN);

    t = T(i);
    Pos = match.distRatio <= t;
    Neg = ~Pos;
    Conf = sum([True False False True] & [Pos Pos Neg Neg],1);
    TP = Conf(1);
    FP = Conf(2);
    TN = Conf(3);
    FN = Conf(4);
    ROC(i,1) = FP / (FP + TN);
    ROC(i,2) = TP / (TP + FN);
    PR(i,1) = FP / (FP + TP);
    PR(i,2) = TP / (TP + FN);
end
% Precision sometimes divides by 0, in this case it should be 0
PR(isnan(PR(:))) = 0;

end

