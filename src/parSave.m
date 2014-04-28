function [] = parSave(path,varargin)
%PARSAVE Summary of this function goes here

for i = 1:2:numel(varargin)
    eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
end
lockName = [path '.lockFile']

lockId = fopen(lockName,'w');
fwrite(lockId,'');
% Output to desired file
save(path,varargin{1:2:numel(varargin)});
% Close lock file and delete it
fclose(lockId);
delete(lockName);

end
