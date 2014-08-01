function name = kernel2name(kernel)
    name = lower(kernel);
    name = strrep(kernel,'box','\textit{Box}');
    name = strrep(name,'triangle','\textit{Tri}');
    name = strrep(name,'gaussian','\textit{G}');
    name = strrep(name,'polar','');
    name = strtrim(name);
end
