function [X,D] = dtuFeatures(setNum, imNum, liNum, mFunc, mDir)
% Wrapper function for extracting features from a DTU Robot image

if nargin < 5
    mDir = '';
end

if isempty(mDir)
    [X,D] = mFunc(imread(dtuImagePath(setNum,imNum,liNum)));
else
    dPath = dtuDescriptorPath(mDir,setNum,imNum,liNum);
    if exist(dPath,'file')
        load(dPath)
    else
        [X,D] = mFunc(imread(dtuImagePath(setNum,imNum,liNum)));
        if ~exist(mDir,'dir')
            mkdir(mDir)
        end
        save(dPath,'X','D')
    end
end

end