function path = dtuMatchPath(dDir, setNum, imNum, liNum)

if isnumeric(liNum)
    path = sprintf('%s/matches_%.3d-%.3d-%.2d.mat',dDir,setNum,imNum,liNum);
elseif strcmp(liNum,'diffuse')
    path = sprintf('%s/matches_%.3d-%.3d-diffuse.mat',dDir,setNum,imNum);
end

end

