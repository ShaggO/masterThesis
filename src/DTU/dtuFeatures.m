function [X,D] = dtuFeatures(setNum, imNum, liNum, mFunc, desSave)
% Wrapper function for extracting features from a DTU Robot image

if nargin < 5
    desSave = true;
end

% Load paths for the data
load('paths');

I = loadDtuImage(setNum,imNum,liNum);
imName = dtuImageName(setNum,imNum,liNum);

[X,D] = mFunc(I,dtuResults,imName,desSave);

end
