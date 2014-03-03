function path = dtuDescriptorPath(dDir, setNum, imNum, liNum)

if isnumeric(liNum)
    path = sprintf('%s/descriptors_%.3d-%.3d-%.2d.mat',dDir,setNum,imNum,liNum);
elseif strcmp(liNum,'diffuse')
    path = sprintf('%s/descriptors_%.3d-%.3d-diffuse.mat',dDir,setNum,imNum);
end

end

