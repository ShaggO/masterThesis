function [] = table2latex(T,firstRow,precision,bold)

if nargin < 2
    firstRow = repmat({''},1,width(T));
end
if nargin < 3
    precision = ones(1,width(T));
end
if nargin < 4
    bold = zeros(height(T),width(T));
end

fid = fopen('table.txt','w');
for i = 1:width(T)
    s = firstRow{i};
    for j = 1:height(T)
        v = T{j,i};
        if iscell(v)
            if bold(j,i)
                sj = ['\textbf{' v{:} '}'];
            else
                sj = v{:};
            end
        elseif isnumeric(v)
            if bold(j,i)
                sj = ['$\mathbf{' sprintf(['%.' num2str(precision(i)) 'f'],v) '}$'];
            else
                sj = ['$' sprintf(['%.' num2str(precision(i)) 'f'],v) '$'];
            end
        end
        s = [s ' & ' sj];
    end
    s = [strrep(s,'\','\\') ' \\\\\n'];
    fprintf(fid,s);
end

end