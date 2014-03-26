function path = dtuImagePath(setNum, imNum, liNum)

% Load paths for the data
% Loads the following variables:
%   dtuSavePath
%   dtuDataPath
%   dtuDataSet
load('paths');

if isnumeric(liNum)
    path = sprintf('%s/%s/SET%.3d/Img%.3d_%.2d.bmp',dtuDataPath,dtuDataSet,setNum,imNum,liNum);
elseif strcmp(liNum,'diffuse')
    path = sprintf('%s/%s/SET%.3d/Img%.3d_diffuse.bmp',dtuDataPath,dtuDataSet,setNum,imNum);
else
    error('invalid liNum')
end

