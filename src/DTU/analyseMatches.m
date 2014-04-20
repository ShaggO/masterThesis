function [ROC, PR] = analyseMatches(match)

T = [0; sort(match.distRatio,'ascend')];
True = match.CorrectMatch == 1;
False = match.CorrectMatch == -1;
ROC = zeros(numel(T),2);
PR = ROC;
FPR = zeros(numel(T),1);
TPR = FPR;
OMP = FPR;
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
    FPR(i) = FP / (FP + TN); % False-positive rate
    TPR(i) = TP / (TP + FN); % True-positive rate / Recall
    OMP(i) = FP / (FP + TP); % 1-Precision
%     PR(i,2) = ROC(i,2);
end

FPR(isnan(FPR)) = 0; % if there are no false matches, we define FPR = 0
TPR(isnan(TPR)) = 0; % if there are no true matches, we define TPR = 0
OMP(isnan(OMP)) = 0; % if there are no positive matches, we define OMP = 0

ROC(:,1) = FPR;
ROC(:,2) = TPR;
PR(:,1) = OMP;
PR(:,2) = TPR;

end

