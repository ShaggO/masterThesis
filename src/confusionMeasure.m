function [ROC, PR] = confusionMeasure(groundTruth,prob)

[T,idx] = sort(prob);
groundTruth = groundTruth(idx);
True = groundTruth == 1;
False = groundTruth == -1;

[~,idxT] = unique(T);
idxT = [idxT; numel(T)+1];

FN = [0; cumsum(True)];
FN = FN(idxT);
TP = sum(True) - FN;
TN = [0; cumsum(False)];
TN = TN(idxT);
FP = sum(False) - TN;

FPR = FP ./ (FP + TN); % False-positive rate
TPR = TP ./ (TP + FN); % True-positive rate / Recall
OMP = FP ./ (FP + TP); % 1-Precision

FPR(isnan(FPR)) = 0; % if there are no false matches, we define FPR = 0
TPR(isnan(TPR)) = 0; % if there are no true matches, we define TPR = 0
OMP(isnan(OMP)) = 0; % if there are no positive matches, we define OMP = 0

ROC(:,1) = FPR;
ROC(:,2) = TPR;
PR(:,1) = OMP;
PR(:,2) = TPR;

end