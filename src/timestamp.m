function s = timestamp(time)
if nargin < 1
    time = NaN;
end

if ~isnan(time);
    s = ['[' sprintf('%.0f',toc(time)) 's]'];
else
    s = ['[' sprintf('%.0f',toc) 's]'];
end

end

