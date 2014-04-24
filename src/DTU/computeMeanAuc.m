function [meanAUC, stdAUC] = computeMeanAuc(AUC, nSet, nMethod)
%COMPUTEMEANAUC

AUCset = permute(mean(reshape(AUC,[],nSet,nMethod),1),[2 3 1]);
meanAUC = mean(AUCset,1);
stdAUC = std(AUCset,0,1);

end