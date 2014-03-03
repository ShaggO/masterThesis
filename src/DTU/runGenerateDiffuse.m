clc, clear all

setNum = 1:60;
imNum = [1 12 24 25 26 37 49 50 57 64 65 94 95 119];
liNum = 1:19;

for s = setNum
    disp(['Set ' num2str(s) '/' num2str(numel(setNum))])
    for i = imNum
        I = zeros(1200,1600,3);
        for l = liNum
            I = I + double(imread(dtuImagePath(s,i,l)));
        end
        I = uint8(I / numel(liNum));
        imwrite(I,dtuImagePath(s,i,'diffuse'));
    end
end

