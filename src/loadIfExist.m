function [loaded,vars] = loadIfExist(fPath,type)
% LOADIFEXIST Load file if it exists and the load succeeds.

if nargin < 2
    type = 'file';
end

loaded = false;
vars = struct;

try
    vars = load(fPath);
    loaded = true;
catch err
    return
%     disp(['Load failed (' err.message ') Creating new file instead']);
end

end