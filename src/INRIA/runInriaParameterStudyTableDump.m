clc, clear all;

%% Load Go and Si splits
splits = 6;
names = {'Go','Si'};
for i = 1:numel(names)
    parameters = load(['results/optimize/inriaParameters' names{i}]);
    table(i) = struct(parameters.method.descriptorArgs{:});
end

table = rmfield(table,{'colour','contentType','magnitudeType','rescale','centerFilter','normType','cellNormStrategy','gridRadius','scaleBase','scaleOffset','smooth'});

table = struct2table(table,'RowNames',upper(names));

%table.gridType = cellfun(@(x) regexprep(x,'(.)(\w+)(\s*)','${upper($1)}'),table.gridType,'uniformoutput',false);
table.cellSigma = table.cellSigma(:,1);
table.normSigma = table.normSigma(:,1);

table.gridType = cellfun(@window2name,table.gridType,'UniformOutput',0);
table.cellFilter = cellfun(@kernel2name,table.cellFilter,'UniformOutput',0);
table.binFilter = cellfun(@kernel2name,table.binFilter,'UniformOutput',0);

table = table(:,{'gridType','gridSize','cellFilter','cellSigma','binCount','binFilter','binSigma','normSigma'});
% writetable(table,'results/INRIAparams.csv','Delimiter',',','WriteRowNames',true);
% colNames = 'Row,Grid type,Cell spacing $r$,Cell kernel,Cell scale $\ESCAPE\alpha$,Bin count $n$,Bin kernel,Bin scale $\ESCAPE\beta$,Normalization scale $\ESCAPE\eta$';
% csvContent = fileread('results/INRIAparams.csv');
% [~,csvData] = strtok(csvContent,char(10));
% csvFile = fopen('results/INRIAparams.csv','w');
% fprintf(csvFile,'%s',[colNames csvData]);
% fclose(csvFile);

namesLogC = {'Go','Si','GoSi','Compact3','Hog','HogSi'};
for i = 1:numel(namesLogC);
    parameters = load(['results/optimize/inriaParameters' namesLogC{i}]);
    logC = parameters.svmArgs.logc;
    table2(i) = struct('C',['$' sprintf('%.1f',10^(logC - floor(logC))) '\cdot 10^{' sprintf('%.0f',floor(logC)) '}$']);
end
namesLogC = {'GO','SI','GO+SI','Compact GO+SI','HOG','HOG+SI'};

table2 = struct2table(table2,'RowNames',namesLogC);
% writetable(table2,'results/INRIAparamC.csv','Delimiter',',','WriteRowNames',true);

%% Latex tables

varNames = {'Grid type','Cell spacing $r$','Cell kernel','Cell scale $\alpha$','Bin count $n$','Bin kernel','Bin scale $\beta$','Normalization scale $\eta$'};
precision = [0 1 0 1 0 0 1 1];
table2latex(table,varNames,precision)

varNames = {'$\log C$'};
precision = 1;
table2latex(table2,varNames,precision)
