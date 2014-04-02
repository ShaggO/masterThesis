clc, clear all

setNum = 1;
imNum = [1 12 24 25 26 37 49 50 57 64 65 94 95 119];
liNum = 1:19;
szI = size(imread(dtuImagePath(setNum(1),imNum(1),liNum(1))));

for s = setNum
    disp(['Set ' num2str(s) '/' num2str(numel(setNum))])
    for i = imNum
        I = zeros(szI);
        for l = liNum
            I = I + double(imread(dtuImagePath(s,i,l)));
        end
        I = uint8(1.5 * I / numel(liNum));
        imwrite(I,dtuImagePath(s,i,'diffuse'));
    end
end

