function s = svmArgs2string(args)

if ismember('logc',fieldnames(args))
    args.c = 10^args.logc;
    args = rmfield(args,'logc');
end

s = '';
fn = sort(fieldnames(args));

for i = 1:numel(fn)
    if i > 1
        s = [s ' '];
    end
    v = args.(fn{i});
    switch class(v)
        case 'double'
            s = [s '-' fn{i} ' ' num2str(v)];
        otherwise
            error('Unsupported class.')
    end
end

end