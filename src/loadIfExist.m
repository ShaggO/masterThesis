function [loaded,vars] = loadIfExist(fPath,type)
% LOADIFEXIST Load file if it exists and the load succeeds.

if nargin < 2
    type = 'file';
end

vars = [];

loaded = false;
if exist(fPath,type)
    try
        vars = load(fPath);
        loaded = true;
    catch err
        disp(['Load failed (' err.message ') Creating new file instead']);
    end
end

end
