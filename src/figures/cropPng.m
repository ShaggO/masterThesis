function [] = cropPng(path)

I = imread(path);
J = ~all(I == 255,3);
I = I(find(sum(J,2),1,'first') : find(sum(J,2),1,'last'), ...
    find(sum(J,1),1,'first') : find(sum(J,1),1,'last'),:);
imwrite(I,path);

end