function [X,D] = dtuFeatures(setNum, imNum, liNum, mFunc)
% Wrapper function for extracting features from a DTU Robot image

% Load paths for the data
% Loads the following variables:
%   dtuSavePath
%   dtuDataPath
%   dtuDataSet
load('paths');

I = imread(dtuImagePath(setNum,imNum,liNum));
imName = dtuImageName(setNum,imNum,liNum);

[X,D] = mFunc(I,dtuSavePath,imName);

end
