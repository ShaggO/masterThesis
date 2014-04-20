clc, clear all

match.CorrectMatch = [1 1 1 1 1 1 -1]';
match.distRatio = [0.8 0.7 0.6 0.5 0.4 0.3 0.15]';

match.setNum = 1;
match.imNum = 1;
match.liNum = 0;

[ROC, PR] = analyseMatches(match);
match.ROC = ROC;
match.PR = PR;
match.ROCAUC = ROCarea(match.ROC','roc');
match.PRAUC = ROCarea(match.PR','pr');

plotAnalyseMatches(match,0.5,'vl-dog-6.5-10-3_cellhist-gray-go-m-1.2599-0.5-concentric polar-8,2-10-box-Inf,Inf-gaussian-1,1-pixel-gaussian-2,2-gaussian-2.5-8')