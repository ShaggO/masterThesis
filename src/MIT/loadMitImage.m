function I = loadMitImage(n)

load('paths');

path = sprintf(mitDataFormat,mitDataSet,n);
I = imread(path);

end