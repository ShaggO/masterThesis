function [] = parStructSave(path,varargin)
%PARSAVE Summary of this function goes here

% Create lock
for i = 1:2:numel(varargin)
    eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
end

% Output to desired file
save(path,'-struct',varargin{1:2:numel(varargin)});

end
