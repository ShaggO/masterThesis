function [] = parSave(path,varargin)
%PARSAVE Summary of this function goes here

for i = 1:2:numel(varargin)
    eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
end

save(path,varargin{1:2:numel(varargin)});

end