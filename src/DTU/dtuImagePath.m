function path = dtuImagePath(setNum,imNum,liNum)

% Load paths for the data
load('paths');

path = sprintf(dtuDataFormat,dtuDataSet,setNum,imNum,liNum);

end