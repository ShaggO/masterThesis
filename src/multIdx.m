function x = multIdx(x,varargin)
%MULTIDX Multiple successive indexing. Allows for cell array inputs.

for i = 1:numel(varargin)
    idx = varargin{i};
    if iscell(x)
        if iscell(idx)
            x = x{idx{:}};
        else
            x = x{idx};
        end
    else
        if iscell(idx)
            x = x(idx{:});
        else
            x = x(idx);
        end
    end
end

end