clear all;

%% Load Go and Si splits
splits = 6;
for i = 1:splits
    go(i) = load(['results/optimize/parameterStudyGo_' num2str(i) '-of-' num2str(splits) '.mat']);
    goTable(i) = struct(go(i).method.descriptorArgs{:});
    si(i) = load(['results/optimize/parameterStudySi_' num2str(i) '-of-' num2str(splits) '.mat']);
    siTable(i) = struct(si(i).method.descriptorArgs{:});
end

tables{1} = rmfield(goTable,{'colour','contentType','magnitudeType','rescale','centerFilter','cellFilter','normType','cellNormStrategy'});
tables{2} = rmfield(siTable,{'colour','contentType','magnitudeType','rescale','centerFilter','cellFilter','normType','cellNormStrategy'});

tables{1} = struct2table(goTable);
tables{2} = struct2table(siTable);

for i = 1:numel(tables)
    tables{i}.gridAngles = tables{i}.gridSize(:,1);
    tables{i}.gridRings = tables{i}.gridSize(:,2);
    tables{i}.gridSize = [];
    tables{i}.centerSigma = tables{i}.centerSigma(:,1);
    tables{i}.cellSigma = tables{i}.cellSigma(:,1);
    tables{i}.normSigma = tables{i}.normSigma(:,1);
end

writetable(tables{1},'results/ICparamsGo.txt','Delimiter',',');
writetable(tables{2},'results/ICparamsSi.txt','Delimiter',',');
