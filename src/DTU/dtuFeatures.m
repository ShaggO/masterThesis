function [X,D] = dtuFeatures(setNum, imNum, liNum, mFunc)
% Wrapper function for extracting features from a DTU Robot image

I = imread(dtuImagePath(setNum,imNum,liNum));
imName = dtuImageName(setNum,imNum,liNum);
[X,D] = mFunc(I,'DTU/results',imName);

end
