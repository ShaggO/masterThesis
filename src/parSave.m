function [] = parSave(path,varargin)
%PARSAVE Summary of this function goes here

% Create lock file
pathFinished = [path '.finished'];

% Create lock
for i = 1:2:numel(varargin)
    eval(sprintf('%s = varargin{%i};',varargin{i},i+1));
end

% Output to desired file
save(path,varargin{1:2:numel(varargin)});
% Close lock file and delete it
%fclose(fopen(pathFinished,'w'));

end
