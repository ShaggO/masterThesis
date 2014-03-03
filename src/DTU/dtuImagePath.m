function path = dtuImagePath(setNum, imNum, liNum)

if isnumeric(liNum)
    path = sprintf('DTU/img1200x1600/SET%.3d/Img%.3d_%.2d.bmp',setNum,imNum,liNum);
elseif strcmp(liNum, 'diffuse')
    path = sprintf('DTU/img1200x1600/SET%.3d/Img%.3d_diffuse.bmp',setNum,imNum);
end

