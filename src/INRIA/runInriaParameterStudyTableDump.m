clear all;

%% Load Go and Si splits
splits = 6;
names = {'Go','Si'};
for i = 1:numel(names)
    parameters = load(['results/optimize/inriaParameters' names{i}]);
    table(i) = struct(parameters.method.descriptorArgs{:});
end

table = rmfield(table,{'colour','contentType','magnitudeType','rescale','centerFilter','cellFilter','normType','cellNormStrategy','gridRadius','scaleBase','scaleOffset','gridType'});

table = struct2table(table,'RowNames',upper(names));

%table.gridType = cellfun(@(x) regexprep(x,'(.)(\w+)(\s*)','${upper($1)}'),table.gridType,'uniformoutput',false);
table.cellSigma = table.cellSigma(:,1);
table.normSigma = table.normSigma(:,1);


writetable(table,'results/INRIAparams.csv','Delimiter',',','WriteRowNames',true);

colNames = 'Row,Cell spacing,Cell scale $\ESCAPE\alpha$,Normalization scale $\ESCAPE\eta$,Bin scale $\ESCAPE\beta$,Bin count $n$';
csvContent = fileread('results/INRIAparams.csv');
[~,csvData] = strtok(csvContent,char(10));
csvFile = fopen('results/INRIAparams.csv','w');
fprintf(csvFile,'%s',[colNames csvData]);
fclose(csvFile);


namesLogC = {'Go','Si','GoSi','Hog','HogDT'};
for i = 1:numel(namesLogC);
    parameters = load(['results/optimize/inriaParameters' namesLogC{i}]);
    logC = parameters.svmArgs.logc;
    table2(i) = struct('C',['$' num2str(10^(logC - floor(logC)),2) '\cdot 10^{' num2str(floor(logC)) '}$']);
end
namesLogC = {'GO','SI','GO+SI','Hog (UoccTI)','Hog (DalalTriggs)'};

table2 = struct2table(table2,'RowNames',namesLogC);
writetable(table2,'results/INRIAparamC.csv','Delimiter',',','WriteRowNames',true);
