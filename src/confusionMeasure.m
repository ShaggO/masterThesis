function [ROC, PR] = confusionMeasure(groundTruth,prob)

T = [-Inf; sort(prob,'ascend')];
True = groundTruth == 1;
False = groundTruth == -1;
ROC = zeros(numel(T),2);
PR = ROC;
FPR = zeros(numel(T),1);
TPR = FPR;
OMP = FPR;
for i = 1:numel(T)

    t = T(i);
    Pos = prob > t;
    Neg = ~Pos;
    Conf = sum([True False False True] & [Pos Pos Neg Neg],1);
    TP = Conf(1);
    FP = Conf(2);
    TN = Conf(3);
    FN = Conf(4);
    FPR(i) = FP / (FP + TN); % False-positive rate
    TPR(i) = TP / (TP + FN); % True-positive rate / Recall
    OMP(i) = FP / (FP + TP); % 1-Precision
end

FPR(isnan(FPR)) = 0; % if there are no false matches, we define FPR = 0
TPR(isnan(TPR)) = 0; % if there are no true matches, we define TPR = 0
OMP(isnan(OMP)) = 0; % if there are no positive matches, we define OMP = 0

ROC(:,1) = FPR;
ROC(:,2) = TPR;
PR(:,1) = OMP;
PR(:,2) = TPR;

end
