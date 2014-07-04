clear all;

names = {'Go','Si'};

%% Load Go and Si splits
splits = 6;
for i = 1:splits
    go(i) = load(['results/optimize/parameterStudyGo_' num2str(i) '-of-' num2str(splits) '.mat']);
    goTable(i) = struct(go(i).method.descriptorArgs{:});
    si(i) = load(['results/optimize/parameterStudySi_' num2str(i) '-of-' num2str(splits) '.mat']);
    siTable(i) = struct(si(i).method.descriptorArgs{:});
end

goTable(end+1) = goTable(end)
siTable(end+1) = siTable(end)

goTable = rmfield(goTable,{'colour','contentType','magnitudeType','rescale','centerFilter','cellFilter','normType','cellNormStrategy'});
siTable = rmfield(siTable,{'colour','contentType','magnitudeType','rescale','centerFilter','cellFilter','normType','cellNormStrategy'});

tables{1} = struct2table(goTable,'RowNames',cat(1,mat2cell(num2str((1:6)'),ones(1,6),1),{'chosen'}));
tables{2} = struct2table(siTable,'RowNames',cat(1,mat2cell(num2str((1:6)'),ones(1,6),1),{'chosen'}));

for i = 1:numel(tables)
    tables{i}.gridType = cellfun(@(x) regexprep(x,'(.)(\w+)(\s*)','${upper($1)}'),tables{i}.gridType,'uniformoutput',false);
    tables{i}.gridSize = cellfun(@(x) ['$' num2str(x(1)) ' \times ' num2str(x(2)) '$'],mat2cell(tables{i}.gridSize,ones(1,7),2),'uniformoutput',false)
    tables{i}.gridSize{end} = ['$\mathbf{' tables{i}.gridSize{end}(2:end-1) '}$'];
    tables{i}.centerSigma = tables{i}.centerSigma(:,1);
    tables{i}.cellSigma = tables{i}.cellSigma(:,1);
    tables{i}.normSigma = tables{i}.normSigma(:,1);
end

% Choose additional parameters manually
tables{2}.gridRadius(end) = 13.5;
tables{1}.centerSigma(end) = 1.6;
tables{2}.centerSigma(end) = 2;
tables{2}.cellSigma(end) = 1.1;
tables{1}.binSigma(end) = 1.3;
tables{1}.binCount(end) = 14;

tables{1}
tables{2}

writetable(tables{1},'results/DTUparamsGo.csv','Delimiter',',','WriteRowNames',true);
writetable(tables{2},'results/DTUparamsSi.csv','Delimiter',',','WriteRowNames',true);

for name = names
    colNames = 'Row,Grid type,Grid size,Grid radius $r$,Center scale,Cell scale $\ESCAPE\alpha$,Norm. scale $\ESCAPE\eta$,Bin scale $\ESCAPE\beta$,Bin count $n$';
    csvContent = fileread(['results/DTUparams' name{:} '.csv']);
    [~,csvData] = strtok(csvContent,char(10));
    csvFile = fopen(['results/DTUparams' name{:} '.csv'],'w');
    fprintf(csvFile,'%s',[colNames csvData]);
    fclose(csvFile);
end
