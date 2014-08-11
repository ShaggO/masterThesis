clc, clear all

results = load('results/inriaHardNegatives');

%% Table
fid = fopen('table.txt','w');
dims = [8316,4743,4554,21346,11115,10231];

fprintf(fid,'Measure & HOG+SI & HOG & Compact GO+SI & GO+SI & GO & SI \\\\ \\midrule\n');

s = 'Dimensions';
for i = 1:6
    s = [s ' & ' num2str(dims(i))];
end
fprintf(fid,[s ' \\\\\n']);

s = 'Hard negatives';
for i = 1:6
    s = [s ' & ' num2str(results.nHardAuto(i))];
end
fprintf(fid,[s ' \\\\\n']);

s = 'Initial PR AUC';
for i = 1:6
    s = [s ' & ' num2str(results.PRAUC(2,i),4)];
end
fprintf(fid,[s ' \\\\\n']);

s = 'PR AUC';
for i = 1:6
    s = [s ' & ' num2str(results.PRAUC(1,i),4)];
end
fprintf(fid,[s ' \\\\\n']);

s = 'ROC AUC';
for i = 1:6
    s = [s ' & ' num2str(results.ROCAUC(1,i),6)];
end
fprintf(fid,[s ' \\\\\n']);

s = 'Recall at $10^{-4}$ FPR';
for i = 1:6
    s = [s ' & ' num2str(results.recall(1,i),3)];
end
fprintf(fid,[s ' \\\\\n']);

% s = [labels{i} ' & $' num2str(dims{i}) '$ & $' sprintf('%.4f',PRAUC(i)) '$ & $' sprintf('%.6f',ROCAUC(i)) '$ & $' sprintf('%.3f',recall(i)) '$ \\\\ \n'];
