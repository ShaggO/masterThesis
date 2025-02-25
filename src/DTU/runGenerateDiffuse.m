clc, clear all

setNum = 1;
imNum = [1 12 24 25 26 37 49 50 57 64 65 94 95 119];
liNum = 1:19;
overwrite = false;
szI = size(loadDtuImage(setNum(1),imNum(1),liNum(1)));

for s = setNum
    disp(['Set ' num2str(s) '/' num2str(numel(setNum))])
    for i = imNum
        I = zeros(szI);

        savePath = dtuImagePath(s,i,'diffuse');
        [~,ind] = find(savePath == '/',1,'last');

        if ~overwrite && exist(savePath,'file')
            % Skip creation if file exists and we arent asked to overwrite
            continue;
        end

        for l = liNum
            I = I + double(loadDtuImage(s,i,l));
        end
        if ~exist(savePath(1:ind),'dir')
            mkdir(savePath(1:ind));
        end
        I = uint8(1.5 * I / numel(liNum));
        imwrite(I,dtuImagePath(s,i,'diffuse'));
    end
end

