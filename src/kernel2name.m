function name = kernel2name(kernel)
    name = lower(kernel);
    name = strrep(kernel,'box','Box');
    name = strrep(name,'triangle','Tri');
    name = strrep(name,'gaussian','G');
    name = strrep(name,'polar','');
    name = strtrim(name);
end
