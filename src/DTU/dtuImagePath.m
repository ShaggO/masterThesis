function path = dtuImagePath(setNum, imNum, liNum,liType)

if nargin < 4
    liType = 'raw';
end
assert(strcmp(liType,'raw') || strcmp(liType,'x') || strcmp(liType,'z'),...
    ['Lighting type not supported: ' liType '. Must be raw, x or z']);

% Load paths for the data
load('paths');

switch liType
    case 'raw'
        if isnumeric(liNum)
            path = sprintf('%s/SET%.3d/Img%.3d_%.2d.bmp',dtuDataSet,setNum,imNum,liNum);
        elseif strcmp(liNum,'diffuse')
            path = sprintf('%s/SET%.3d/Img%.3d_diffuse.bmp',dtuDataGenerated,setNum,imNum);
        else
            error('invalid linum');
        end
    otherwise
        path = sprintf('%s/SET%.3d/Img%.3d_light-%s_%.2d.bmp',dtuDataGenerated,setNum,imNum,liType,liNum);
end

end
