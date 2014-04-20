clc, clear all

load('paths')
folders = ls(dtuResults);

for i = 3:size(folders,1)
    folder = [dtuResults '/' strtrim(folders(i,:))];
    files = ls(folder);
    
    for j = 3:size(files,1)
        file = strtrim(files(j,:));
        path = [folder '/' file];
        if strcmp(file(1:7),'matches')
            load(path)
            
            [match.ROC, match.PR] = analyseMatches(match);
            match.ROCAUC = ROCarea(match.ROC','roc');
            match.PRAUC = ROCarea(match.PR','pr');
            
            save(path,'match')
        end
    end
end