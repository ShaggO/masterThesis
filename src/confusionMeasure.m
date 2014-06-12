function [ROC, PR] = confusionMeasure(groundTruth,prob)

[T,idx] = sort(prob);
groundTruth = groundTruth(idx);
True = groundTruth == 1;
False = groundTruth == -1;

% FN = zeros(numel(T)+1,1);
% TN = zeros(numel(T)+1,1);
% for i = 1:numel(T)
%     if True(i)
%         FN(i+1) = 1;
%     else
%         TN(i+1) = 1;
%     end
% end

[~,idxT] = unique(T);
idxT = [idxT; numel(T)+1];
FN = zeros(numel(idxT),1);
TN = zeros(numel(idxT),1);
for i = 2:numel(idxT)
    FN(i) = sum(True(idxT(i-1):idxT(i)-1));
    TN(i) = sum(False(idxT(i-1):idxT(i)-1));
end

FN = cumsum(FN)';
TP = sum(True) - FN;
TN = cumsum(TN)';
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