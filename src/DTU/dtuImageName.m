function path = dtuImageName(setNum, imNum, liNum)

if isnumeric(liNum)
    path = sprintf('%.3d-%.3d-%.2d.mat',setNum,imNum,liNum);
elseif strcmp(liNum,'diffuse')
    path = sprintf('%.3d-%.3d-diffuse.mat',setNum,imNum);
end

end

