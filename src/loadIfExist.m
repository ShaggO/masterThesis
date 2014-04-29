function [loaded,vars] = loadIfExist(fPath,type)
% LOADIFEXIST Load file if it exists and the load succeeds.

if nargin < 2
    type = 'file';
end

vars = [];
%fPathFinished = [fPath '.finished'];

loaded = false;
if exist(fPath,type) %&& exist(fPathFinished,'file')
    try
        vars = load(fPath);
        loaded = true;
    catch err
        disp(['Load failed (' err.message ') Creating new file instead']);
    end
else
    disp('File does not exist');
    loaded = false;
    vars = {};
end

end
