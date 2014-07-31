function name = window2name(window)
    name = strrep(window,'window','');
    name = strtrim(name);
    name = [upper(name(1)) name(2:end)];
end
