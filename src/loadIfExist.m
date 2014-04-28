function [loaded,vars] = loadIfExist(fPath,type)
% LOADIFEXIST Load file if it exists and the load succeeds.

if nargin < 2
    type = 'file';
end

vars = [];
lockName = [fPath '.lockFile'];

loaded = false;
if exist(fPath,type)
    try
        % Perform busy waiting, could possibly be changed using a timer
        while exist(lockName,'file')
            continue
        end
        vars = load(fPath);
        loaded = true;
    catch err
        disp(['Load failed (' err.message ') Creating new file instead']);
    end
end

end
