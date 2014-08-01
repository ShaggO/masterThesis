clc, clear all

% results = load('results/inriaHardNegatives');

%% Table
fid = fopen('table.txt','w');
dims = [17784,11115,4185,6669,4743];

s = 'Dimensions';
for i = 1:5
    s = [s ' & ' num2str(dims(i))];
end
fprintf(fid,[s ' \\\\\n']);

s = 'Initial PR AUC';

% s = [labels{i} ' & $' num2str(dims{i}) '$ & $' sprintf('%.4f',PRAUC(i)) '$ & $' sprintf('%.6f',ROCAUC(i)) '$ & $' sprintf('%.3f',recall(i)) '$ \\\\ \n'];